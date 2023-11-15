import 'dart:convert';

import 'package:floor/floor.dart';

class ImageListData {
  final List<MovieImages> backdrops = [];
  final List<MovieImages> logos = [];
  final List<MovieImages> posters = [];

  ImageListData();
  operator [](String key) {
    switch (key) {
      case 'backdrops':
        return backdrops;
      case 'logos':
        return logos;
      case 'posters':
        return posters;
    }
    return [];
  }

  operator []=(String key, List<MovieImages> data) {
    switch (key) {
      case 'backdrops':
        backdrops.clear();
        backdrops.addAll(data);
        break;
      case 'logos':
        logos.clear();
        logos.addAll(data);
        break;
      case 'posters':
        posters.clear();
        posters.addAll(data);
        break;
    }
  }
}

@entity
class MovieImages {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final int movieId;
  final String imageType;
  final double aspectRatio;
  final int height;
  final String iso_639_1;
  final String filePath;
  final double voteAverage;
  final int voteCount;
  final int width;
  MovieImages(
    this.id,
    this.movieId,
    this.imageType,
    this.aspectRatio,
    this.height,
    this.iso_639_1,
    this.filePath,
    this.voteAverage,
    this.voteCount,
    this.width,
  );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'movie_id': movieId,
      'image_type': imageType,
      'aspect_ratio': aspectRatio,
      'height': height,
      'iso_639_1': iso_639_1,
      'file_path': filePath,
      'vote_average': voteAverage,
      'vote_count': voteCount,
      'width': width,
    };
  }

  factory MovieImages.fromMap(Map<String, dynamic> map) {
    return MovieImages(
      null,
      map['movie_id'] ?? 0,
      map['image_type'] ?? "",
      map['aspect_ratio'],
      map['height'],
      map['iso_639_1'],
      map['file_path'],
      map['vote_average'],
      map['vote_count'],
      map['width'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MovieImages.fromJson(String source) =>
      MovieImages.fromMap(json.decode(source));
}

@dao
abstract class MovieImagesDao {
  @Query('SELECT * FROM MovieImages WHERE movieId=:movieId')
  Future<List<MovieImages>> findAllByMovie(int movieId);

  @Query('DELETE FROM MovieImages WHERE movieId = :movieId')
  Future<int?> deleteByMovie(int movieId);

  @insert
  Future<void> insertImage(MovieImages data);
}
