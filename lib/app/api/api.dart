import 'dart:io';

import 'package:dio/dio.dart';

const apiKeyTMDB = '0efe6c11aa517d8e04e87cdfa1494308';
const apiTokenTMDB =
    'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwZWZlNmMxMWFhNTE3ZDhlMDRlODdjZGZhMTQ5NDMwOCIsInN1YiI6IjY1NTI0NTY3OTY1M2Y2MTNmNjI4ZGZmOSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.jZMMPkblXRobLAUto-ymZbru7n_gXOiiCX17STtFE24';
const urlTMdb = 'https://api.themoviedb.org/3';
const urlTMdbImagesBig = 'https://image.tmdb.org/t/p/original/';
const urlTMdbImagesW500 = 'https://image.tmdb.org/t/p/w500/';

final Dio dio = Dio();

class ApiCalls {
  static String apiSufix = '?api_key=$apiKeyTMDB';
  static post(String url, Map<String, dynamic> data) async {
    return await dio.post(url + apiSufix,
        data: data,
        options: Options(
          headers: {
            Headers.acceptHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer $apiTokenTMDB",
          },
        ));
  }

  static get(String url) async {
    return await dio.get(url,
        options: Options(
          headers: {
            Headers.acceptHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer $apiTokenTMDB",
          },
        ));
  }
}
