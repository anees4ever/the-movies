import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_movies/app/database/database.dart';
import 'package:the_movies/app/themovies.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await getDatabase();

  setPathUrlStrategy();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const TheMoviesApp());
}
