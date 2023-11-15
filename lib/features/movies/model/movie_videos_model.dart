import 'dart:convert';

import 'package:floor/floor.dart';

@entity
class MovieVideos {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final int movieId;
  final String iso_639_1;
  final String iso_3166_1;
  final String name;
  final String key;
  final String site;
  final int size;
  final String type;
  final bool official;
  final String publishedAt; //2022-02-18T17:00:25.000Z
  MovieVideos(
    this.id,
    this.movieId,
    this.iso_639_1,
    this.iso_3166_1,
    this.name,
    this.key,
    this.site,
    this.size,
    this.type,
    this.official,
    this.publishedAt,
  );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'movie_id': movieId,
      'iso_639_1': iso_639_1,
      'iso_3166_1': iso_3166_1,
      'name': name,
      'key': key,
      'site': site,
      'size': size,
      'type': type,
      'official': official,
      'published_at': publishedAt,
    };
  }

  factory MovieVideos.fromMap(Map<String, dynamic> map) {
    return MovieVideos(
      null,
      map['movie_id'] ?? 0,
      map['iso_639_1'],
      map['iso_3166_1'],
      map['name'],
      map['key'],
      map['site'],
      map['size'],
      map['type'],
      map['official'],
      map['published_at'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MovieVideos.fromJson(String source) =>
      MovieVideos.fromMap(json.decode(source) as Map<String, dynamic>);
}

@dao
abstract class MovieVideosDao {
  @Query('SELECT * FROM MovieVideos WHERE movieId=:movieId')
  Future<List<MovieVideos>> findAllByMovie(int movieId);

  @Query('DELETE FROM MovieVideos WHERE movieId = :movieId')
  Future<int?> deleteByMovie(int movieId);

  @insert
  Future<void> insertVideo(MovieVideos data);
}
