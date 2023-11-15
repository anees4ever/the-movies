part of 'movies_bloc.dart';

@immutable
sealed class MoviesState {}

final class MoviesInitial extends MoviesState {}

class MoviesFetchingLoadingState extends MoviesState {}

class MoviesFetchingErrorState extends MoviesState {}

class MoviesFetchingSuccessfulState extends MoviesState {
  final List<MovieInfo> movies;
  MoviesFetchingSuccessfulState({
    required this.movies,
  });
}

class MovieDetailsFetchingLoadingState extends MoviesState {}

class MovieDetailsFetchingErrorState extends MoviesState {}

class MovieDetailsFetchingSuccessfulState extends MoviesState {
  final MovieInfo movieInfo;
  MovieDetailsFetchingSuccessfulState({
    required this.movieInfo,
  });
}

class MovieSearchEntryState extends MoviesState {}

class MovieSearchLoadingState extends MoviesState {}

class MovieSearchErrorState extends MoviesState {}

class MovieSearchSuccessfulState extends MoviesState {
  final List<MovieInfo> movies;
  MovieSearchSuccessfulState({
    required this.movies,
  });
}
