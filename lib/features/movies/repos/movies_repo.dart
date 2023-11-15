import 'dart:developer';

import 'package:the_movies/app/api/api.dart';
import 'package:the_movies/app/api/database.dart';
import 'package:the_movies/features/movies/model/genres_model.dart';
import 'package:the_movies/features/movies/model/movie_genres_model.dart';
import 'package:the_movies/features/movies/model/movie_images_model.dart';
import 'package:the_movies/features/movies/model/movie_data_model.dart';
import 'package:the_movies/features/movies/model/movie_videos_model.dart';

class MoviesRepo {
  static Future<List<MovieInfo>> fetchMovies() async {
    List<MovieInfo> movieInfo = [];
    try {
      var response = await ApiCalls.get("$urlTMdb/movie/upcoming");

      Map<String, dynamic> responseData = response.data;

      List<dynamic> results = responseData["results"];

      if (results.isNotEmpty) {
        AppDatabase? db = await getDatabase();
        db!.movieDataDao.deleteAllRecords();

        for (int i = 0; i < results.length; i++) {
          MovieData model = MovieData.fromMap(results[i]);

          int movieId = await db.movieDataDao.insertMovie(model);

          await db.movieGenresDao.deleteByMovie(movieId);
          List<MovieGenres> genres = [];
          for (var id in results[i]["genre_ids"]) {
            MovieGenres genre = MovieGenres(null, movieId, id);
            await db.movieGenresDao.insertGenre(genre);
            genres.add(genre);
          }
          MovieData? movieData = await db.movieDataDao.findMovieById(movieId);
          if (movieData != null) {
            MovieInfo info = MovieInfo(movieData);
            info.genres = genres;
            info.genresMaster = await db.genresDao.findAllGenres();
            movieInfo.add(info);
          }
        }
      }

      return movieInfo;
    } catch (e, s) {
      log("$e, $s");
      return [];
    }
  }

  static Future<List<MovieVideos>> fetchMovieVideos(int movieId) async {
    List<MovieVideos> videos = [];
    try {
      AppDatabase? db = await getDatabase();
      if (db == null) {
        return [];
      }

      var response = await ApiCalls.get("$urlTMdb/movie/$movieId/videos");

      Map<String, dynamic> responseData = response.data;

      List<dynamic> results = responseData["results"];

      if (results.isNotEmpty) {
        await db.movieVideosDao.deleteByMovie(movieId);

        for (int i = 0; i < results.length; i++) {
          results[i]["movie_id"] = movieId;
          MovieVideos video = MovieVideos.fromMap(results[i]);
          await db.movieVideosDao.insertVideo(video);
          videos.add(video);
        }
      }

      return videos;
    } catch (e, s) {
      log("$e, $s");
      return [];
    }
  }

  static Future<ImageListData> fetchMovieImageList(int movieId) async {
    List<String> imageList = [
      "backdrops",
      "logos",
      "posters",
    ];
    ImageListData listData = ImageListData();
    try {
      AppDatabase? db = await getDatabase();
      if (db == null) {
        return listData;
      }

      var response =
          await ApiCalls.get("$urlTMdb/movie/$movieId/images?language=en");

      Map<String, dynamic> responseData = response.data;
      await db.movieImagesDao.deleteByMovie(movieId);

      for (String key in imageList) {
        List<dynamic> results = responseData[key];
        List<MovieImages> images = [];
        for (int i = 0; i < results.length; i++) {
          results[i]["movie_id"] = movieId;
          results[i]["image_type"] = key;
          MovieImages image = MovieImages.fromMap(results[i]);
          await db.movieImagesDao.insertImage(image);
          images.add(image);
        }
        listData[key] = images;
      }

      return listData;
    } catch (e, s) {
      log("$e, $s");
      return ImageListData();
    }
  }

  static Future<List<MovieInfo>> searchMovies(String query) async {
    List<MovieInfo> movies = [];
    try {
      AppDatabase? db = await getDatabase();

      var response = await ApiCalls.get(
          "$urlTMdb/search/movie?language=en-US&query=$query");

      Map<String, dynamic> responseData = response.data;
      List<dynamic> results = responseData["results"];

      for (int i = 0; i < results.length; i++) {
        MovieData model = MovieData.fromMap(results[i]);
        MovieInfo info = MovieInfo(model);

        info.genres = await db!.movieGenresDao.findAllByMovie(model.id);
        info.genresMaster = await db.genresDao.findAllGenres();

        movies.add(info);
      }

      return movies;
    } catch (e, s) {
      log("$e, $s");
      return [];
    }
  }

  static Future<bool> loadGenres() async {
    try {
      AppDatabase? db = await getDatabase();
      if (db == null || (await db.genresDao.findAllGenres()).isNotEmpty) {
        return true;
      }
      var response =
          await ApiCalls.get("$urlTMdb/genre/movie/list?language=en");

      Map<String, dynamic> responseData = response.data;

      List<dynamic> results = responseData["genres"];

      for (int i = 0; i < results.length; i++) {
        Genres genre = Genres.fromMap(results[i]);
        await db.genresDao.insertGenre(genre);
      }

      return true;
    } catch (e, s) {
      log("$e, $s");
      return false;
    }
  }
}
