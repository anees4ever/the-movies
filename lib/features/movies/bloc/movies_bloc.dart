import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/material.dart';
import 'package:the_movies/features/movies/model/images_model.dart';
import 'package:the_movies/features/movies/model/movie_details_model.dart';
import 'package:the_movies/features/movies/model/movies_model.dart';
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
    List<MoviesModel> movies = await MoviesRepo.fetchMovies();

    emit(MoviesFetchingSuccessfulState(movies: movies));
  }

  FutureOr<void> movieDetailsInitialFetchEvent(
      MovieDetailsInitialFetchEvent event, Emitter<MoviesState> emit) async {
    emit(MovieDetailsFetchingLoadingState());
    MovieDetailsModel movieDetails =
        await MoviesRepo.fetchMovieDetails(event.movieId);
    ImageListData movieImageList =
        await MoviesRepo.fetchMovieImageList(event.movieId);

    emit(MovieDetailsFetchingSuccessfulState(
        movieDetails: movieDetails, movieImageList: movieImageList));
  }

  FutureOr<void> movieSearchEvent(
      MovieSearchFetchEvent event, Emitter<MoviesState> emit) async {
    emit(MovieSearchLoadingState());

    List<MoviesModel> movies = await MoviesRepo.searchMovies(event.query);

    emit(MovieSearchSuccessfulState(movies: movies));
  }

  FutureOr<void> movieSearchEntryEvent(
      MovieSearchEntryEvent event, Emitter<MoviesState> emit) async {
    emit(MovieSearchEntryState());
  }
}
