import 'dart:developer';

import 'package:the_movies/app/api/api.dart';
import 'package:the_movies/features/movies/model/images_model.dart';
import 'package:the_movies/features/movies/model/movie_details_model.dart';
import 'package:the_movies/features/movies/model/movies_model.dart';

class MoviesRepo {
  static Future<List<MoviesModel>> fetchMovies() async {
    List<MoviesModel> models = [];
    try {
      var response = await ApiCalls.get("$urlTMdb/movie/upcoming");

      Map<String, dynamic> responseData = response.data;

      List<dynamic> results = responseData["results"];

      for (int i = 0; i < results.length; i++) {
        MoviesModel model = MoviesModel.fromMap(results[i]);
        models.add(model);
      }

      return models;
    } catch (e, s) {
      log("$e, $s");
      return [];
    }
  }

  static Future<MovieDetailsModel> fetchMovieDetails(int movieId) async {
    try {
      var response = await ApiCalls.get(
          "$urlTMdb/movie/$movieId?append_to_response=videos");

      Map<String, dynamic> responseData = response.data;

      MovieDetailsModel detail = MovieDetailsModel.fromMap(responseData);

      return detail;
    } catch (e, s) {
      log("$e, $s");
      return MovieDetailsModel.empty();
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
      var response =
          await ApiCalls.get("$urlTMdb/movie/$movieId/images?language=en");

      Map<String, dynamic> responseData = response.data;

      for (String key in imageList) {
        List<dynamic> results = responseData[key];
        List<ImagesModel> images = [];
        for (int i = 0; i < results.length; i++) {
          ImagesModel image = ImagesModel.fromMap(results[i]);
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

  static Future<List<MoviesModel>> searchMovies(String query) async {
    List<MoviesModel> models = [];
    try {
      var response = await ApiCalls.get(
          "$urlTMdb/search/movie?language=en-US&query=$query");

      Map<String, dynamic> responseData = response.data;

      List<dynamic> results = responseData["results"];

      for (int i = 0; i < results.length; i++) {
        MoviesModel model = MoviesModel.fromMap(results[i]);
        models.add(model);
      }

      return models;
    } catch (e, s) {
      log("$e, $s");
      return [];
    }
  }
}
