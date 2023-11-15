part of 'movies_bloc.dart';

@immutable
sealed class MoviesEvent {}

class MoviesInitialFetchEvent extends MoviesEvent {}

class MovieDetailsInitialFetchEvent extends MoviesEvent {
  final int movieId;

  MovieDetailsInitialFetchEvent({required this.movieId});
}

class MovieSearchInitEvent extends MoviesEvent {
  final List<GenresEx> genres;

  MovieSearchInitEvent({this.genres = const []});
}

class MovieSearchSearchingEvent extends MoviesEvent {
  final String query;

  MovieSearchSearchingEvent({required this.query});
}

class MovieSearchResultEvent extends MoviesEvent {
  final List<MovieInfo> movies;
  final int genreId;

  MovieSearchResultEvent({this.movies = const [], this.genreId = 0});
}
