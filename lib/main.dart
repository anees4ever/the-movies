import 'package:flutter/material.dart';
import 'package:the_movies/app/api/database.dart';
import 'package:the_movies/app/themovies.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await getDatabase();

  setPathUrlStrategy();

  runApp(const TheMoviesApp());
}
