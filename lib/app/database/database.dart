import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:the_movies/features/movies/model/genres_model.dart';

import 'package:the_movies/features/movies/model/movie_data_model.dart';
import 'package:the_movies/features/movies/model/movie_genres_model.dart';
import 'package:the_movies/features/movies/model/movie_images_model.dart';
import 'package:the_movies/features/movies/model/movie_videos_model.dart';

part 'database.g.dart'; // the generated code will be there

AppDatabase? appDatabase;

Future<AppDatabase?> getDatabase() async {
  appDatabase ??=
      await $FloorAppDatabase.databaseBuilder('movies_data.db').build();
  return appDatabase;
}

@Database(
    version: 1,
    entities: [Genres, MovieData, MovieGenres, MovieImages, MovieVideos])
abstract class AppDatabase extends FloorDatabase {
  GenresDao get genresDao;
  MovieDataDao get movieDataDao;
  MovieGenresDao get movieGenresDao;
  MovieVideosDao get movieVideosDao;
  MovieImagesDao get movieImagesDao;
}
//dart run build_runner build
//dart run build_runner watch
