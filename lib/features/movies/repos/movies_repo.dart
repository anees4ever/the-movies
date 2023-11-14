import 'dart:developer';

import 'package:the_movies/app/api/api.dart';
import 'package:the_movies/features/movies/model/movie_details_model.dart';
import 'package:the_movies/features/movies/model/movies_model.dart';

class MoviesRepo {
  static Future<List<MoviesModel>> fetchMovies() async {
    List<MoviesModel> posts = [];
    try {
      var response = await ApiCalls.get("$urlTMdb/upcoming");

      Map<String, dynamic> responseData = response.data;

      List<dynamic> results = responseData["results"];

      for (int i = 0; i < results.length; i++) {
        MoviesModel post = MoviesModel.fromMap(results[i]);
        posts.add(post);
      }

      return posts;
    } catch (e, s) {
      log("$e, $s");
      return [];
    }
  }

  static Future<MovieDetailsModel> fetchMovieDetails(int movieId) async {
    try {
      var response =
          await ApiCalls.get("$urlTMdb/$movieId?append_to_response=videos");

      Map<String, dynamic> responseData = response.data;

      MovieDetailsModel detail = MovieDetailsModel.fromMap(responseData);

      return detail;
    } catch (e, s) {
      log("$e, $s");
      return MovieDetailsModel.empty();
    }
  }
}
