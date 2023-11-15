// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:floor/floor.dart';
import 'package:intl/intl.dart';

import 'package:the_movies/app/extensions/dateformat.dart';
import 'package:the_movies/features/movies/model/genres_model.dart';
import 'package:the_movies/features/movies/model/movie_genres_model.dart';
import 'package:the_movies/features/movies/model/movie_images_model.dart';
import 'package:the_movies/features/movies/model/movie_videos_model.dart';

class MovieInfo {
  final MovieData data;
  List<MovieGenres> genres = [];
  ImageListData images = ImageListData();
  List<MovieVideos> videos = [];
  MovieInfo(this.data);
  List<Genres> genresMaster = [];
}

@entity
class MovieData {
  @PrimaryKey(autoGenerate: false)
  final int id;
  final bool adult;
  final String backdropPath;
  final String originalLanguage;
  final String originalTitle;
  final String overview;
  final double popularity;
  final String posterPath;
  final String releaseDate;
  final String title;
  final bool video;
  final double voteAverage;
  final int voteCount;

  String get releaseDateFormatted {
    if (releaseDate.isEmpty) {
      return "";
    }
    return DateFormat("yyyy-MM-dd")
        .parse(releaseDate)
        .quickFormat("MMMM dd, yyyy");
  }

  MovieData(
    this.id,
    this.adult,
    this.backdropPath,
    this.originalLanguage,
    this.originalTitle,
    this.overview,
    this.popularity,
    this.posterPath,
    this.releaseDate,
    this.title,
    this.video,
    this.voteAverage,
    this.voteCount,
  );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'adult': adult,
      'backdrop_path': backdropPath,
      'original_language': originalLanguage,
      'original_title': originalTitle,
      'overview': overview,
      'popularity': popularity,
      'poster_path': posterPath,
      'release_date': releaseDate,
      'title': title,
      'video': video,
      'vote_average': voteAverage,
      'vote_count': voteCount
    };
  }

  factory MovieData.fromMap(Map<String, dynamic> map) {
    return MovieData(
      map['id'],
      map['adult'],
      map['backdrop_path'] ?? "",
      map['original_language'],
      map['original_title'],
      map['overview'],
      map['popularity'],
      map['poster_path'] ?? "",
      map['release_date'],
      map['title'],
      map['video'],
      map['vote_average'],
      map['vote_count'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MovieData.fromJson(String source) =>
      MovieData.fromMap(json.decode(source));
}

@dao
abstract class MovieDataDao {
  @Query('SELECT * FROM MovieData')
  Future<List<MovieData>> findAllMovies();

  @Query('SELECT * FROM MovieData WHERE id = :id')
  Future<MovieData?> findMovieById(int id);

  @insert
  Future<int> insertMovie(MovieData data);

  @Query('DELETE FROM MovieData')
  Future<int?> deleteAllRecords();
}
