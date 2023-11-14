part of 'movies_bloc.dart';

@immutable
sealed class MoviesEvent {}

class MoviesInitialFetchEvent extends MoviesEvent {}

class MovieDetailsInitialFetchEvent extends MoviesEvent {
  final int movieId;

  MovieDetailsInitialFetchEvent({required this.movieId});
}

class MovieSearchEntryEvent extends MoviesEvent {}

class MovieSearchFetchEvent extends MoviesEvent {
  final String query;

  MovieSearchFetchEvent({required this.query});
}
