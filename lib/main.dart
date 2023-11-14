import 'package:flutter/material.dart';
import 'package:the_movies/app/themovies.dart';
import 'package:url_strategy/url_strategy.dart';

void main() {
  setPathUrlStrategy();

  runApp(const TheMoviesApp());
}
