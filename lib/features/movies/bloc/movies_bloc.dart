import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/material.dart';
import 'package:the_movies/app/database/database.dart';
import 'package:the_movies/features/movies/model/genres_model.dart';
import 'package:the_movies/features/movies/model/movie_genres_model.dart';
import 'package:the_movies/features/movies/model/movie_images_model.dart';
import 'package:the_movies/features/movies/model/movie_data_model.dart';
import 'package:the_movies/features/movies/model/movie_videos_model.dart';
import 'package:the_movies/features/movies/repos/movies_repo.dart';

part 'movies_event.dart';
part 'movies_state.dart';

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  MoviesBloc() : super(MoviesInitial()) {
    on<MoviesInitialFetchEvent>(moviesInitialFetchEvent,
        transformer: restartable());
    on<MovieDetailsInitialFetchEvent>(movieDetailsInitialFetchEvent,
        transformer: restartable());
    on<MovieSearchInitEvent>(movieSearchInitEvent, transformer: restartable());
    on<MovieSearchSearchingEvent>(movieSearchingEvent,
        transformer: restartable());
    on<MovieSearchResultEvent>(movieSearchEvent, transformer: restartable());
  }

  FutureOr<void> moviesInitialFetchEvent(
      MoviesInitialFetchEvent event, Emitter<MoviesState> emit) async {
    emit(MoviesFetchingLoadingState());

    await MoviesRepo.loadGenres();
    List<MovieInfo> movies = await MoviesRepo.fetchMovies();
    if (movies.isEmpty) {
      AppDatabase? db = await getDatabase();
      List<MovieData> movieDataList =
          db == null ? [] : await db.movieDataDao.findAllMovies();
      for (MovieData data in movieDataList) {
        MovieInfo movieInfo = MovieInfo(data);
        movieInfo.genres = await db!.movieGenresDao.findAllByMovie(data.id);
        movieInfo.genresMaster = await db.genresDao.findAllGenres();
        movies.add(movieInfo);
      }
    }
    if (movies.isEmpty) {
      emit(MoviesFetchingErrorState());
    } else {
      emit(MoviesFetchingSuccessfulState(movies: movies));
    }
  }

  FutureOr<void> movieDetailsInitialFetchEvent(
      MovieDetailsInitialFetchEvent event, Emitter<MoviesState> emit) async {
    emit(MovieDetailsFetchingLoadingState());

    MovieInfo? movieInfo;
    AppDatabase? db = await getDatabase();
    if (db != null) {
      MovieData? data = await db.movieDataDao.findMovieById(event.movieId);
      List<MovieGenres> genres =
          await db.movieGenresDao.findAllByMovie(event.movieId);
      List<Genres> genresMaster = await db.genresDao.findAllGenres();

      List<MovieImages> imageList =
          await db.movieImagesDao.findAllByMovie(event.movieId);

      ImageListData images = imageList.isEmpty
          ? await MoviesRepo.fetchMovieImageList(event.movieId)
          : ImageListData();
      if (imageList.isNotEmpty) {
        for (var image in imageList) {
          images[image.imageType].add(image);
        }
      }

      List<MovieVideos> videos =
          await db.movieVideosDao.findAllByMovie(event.movieId);
      if (videos.isEmpty) {
        videos = await MoviesRepo.fetchMovieVideos(event.movieId);
      }
      if (data != null) {
        movieInfo = MovieInfo(data);
        movieInfo.genres = genres;
        movieInfo.genresMaster = genresMaster;
        movieInfo.images = images;
        movieInfo.videos = videos;
      }
    }

    if (movieInfo == null) {
      emit(MovieDetailsFetchingErrorState());
    } else {
      emit(MovieDetailsFetchingSuccessfulState(movieInfo: movieInfo));
    }
  }

  FutureOr<void> movieSearchInitEvent(
      MovieSearchInitEvent event, Emitter<MoviesState> emit) async {
    emit(MovieSearchInitState());

    List<GenresEx> genres = [...event.genres];
    if (genres.isEmpty) {
      AppDatabase? db = await getDatabase();
      if (db != null) {
        List<MovieGenres> movieGenres =
            await db.movieGenresDao.findUniqueGenres();
        for (var genre in movieGenres) {
          MovieData? data = await db.movieDataDao.findMovieById(genre.movieId);
          Genres? genreData = await db.genresDao.findGenreById(genre.genreId);
          if (data != null && genreData != null) {
            genres
                .add(GenresEx(genreData.id, genreData.name, data.backdropPath));
          }
        }
      }
    }

    emit(MovieSearchMainState(
      genres: genres,
    ));
  }

  FutureOr<void> movieSearchingEvent(
      MovieSearchSearchingEvent event, Emitter<MoviesState> emit) async {
    emit(MovieSearchSearchingState(movies: const []));

    List<MovieInfo> movies = [];

    AppDatabase? db = await getDatabase();
    if (db != null) {
      List<MovieData> movieData =
          await db.movieDataDao.searchMovies('%${event.query}%');

      //Sort the output based on best match
      movieData.sort(
        (a, b) => a.scoreOf(event.query).compareTo(b.scoreOf(event.query)),
      );

      for (var data in movieData) {
        MovieInfo movieInfo = MovieInfo(data);
        movieInfo.genres = await db.movieGenresDao.findAllByMovie(data.id);
        movieInfo.genresMaster = await db.genresDao.findAllGenres();
        movies.add(movieInfo);
      }
    }
    //live search
    //List<MovieInfo> movies = await MoviesRepo.searchMovies(event.query);

    emit(MovieSearchSearchingState(movies: movies));
  }

  FutureOr<void> movieSearchEvent(
      MovieSearchResultEvent event, Emitter<MoviesState> emit) async {
    List<MovieInfo> movies = [...event.movies];
    if (event.genreId > 0) {
      AppDatabase? db = await getDatabase();
      if (db != null) {
        List<MovieData> movieData =
            await db.movieDataDao.searchMoviesByGenre(event.genreId);
        for (var data in movieData) {
          MovieInfo movieInfo = MovieInfo(data);
          movieInfo.genres = await db.movieGenresDao.findAllByMovie(data.id);
          movieInfo.genresMaster = await db.genresDao.findAllGenres();
          movies.add(movieInfo);
        }
      }
    }
    emit(MovieSearchSuccessfulState(
      movies: movies,
    ));
  }
}
