import 'dart:convert';

import 'package:floor/floor.dart';

@entity
class MovieGenres {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final int movieId;
  final int genreId;

  MovieGenres(
    this.id,
    this.movieId,
    this.genreId,
  );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'movie_id': movieId,
      'genre_id': genreId,
    };
  }

  factory MovieGenres.fromMap(Map<String, dynamic> map) {
    return MovieGenres(
      0,
      map['movie_id'] ?? 0,
      map['id'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory MovieGenres.fromJson(String source) =>
      MovieGenres.fromMap(json.decode(source));
}

@dao
abstract class MovieGenresDao {
  @Query('SELECT * FROM MovieGenres WHERE movieId=:movieId')
  Future<List<MovieGenres>> findAllByMovie(int movieId);

  @Query('SELECT * FROM MovieGenres WHERE genreId = :genreId')
  Future<List<MovieGenres>> findAllByGenre(int genreId);

  @insert
  Future<void> insertGenre(MovieGenres data);

  @Query('DELETE FROM MovieGenres WHERE movieId = :movieId')
  Future<int?> deleteByMovie(int movieId);
}
