import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/material.dart';
import 'package:the_movies/app/api/database.dart';
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
    on<MovieSearchFetchEvent>(movieSearchEvent, transformer: restartable());
    on<MovieSearchEntryEvent>(movieSearchEntryEvent,
        transformer: restartable());
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

  FutureOr<void> movieSearchEvent(
      MovieSearchFetchEvent event, Emitter<MoviesState> emit) async {
    emit(MovieSearchLoadingState());

    List<MovieInfo> movies = await MoviesRepo.searchMovies(event.query);

    emit(MovieSearchSuccessfulState(
      movies: movies,
    ));
  }

  FutureOr<void> movieSearchEntryEvent(
      MovieSearchEntryEvent event, Emitter<MoviesState> emit) async {
    emit(MovieSearchEntryState());
  }
}
