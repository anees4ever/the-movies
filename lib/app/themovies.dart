import 'package:flutter/material.dart';
import 'package:the_movies/app/theme/theme.dart';
import 'package:the_movies/features/movies/model/movie_details_model.dart';
import 'package:the_movies/features/movies/model/movies_model.dart';
import 'package:the_movies/features/movies/ui/movie_details.dart';
import 'package:the_movies/features/movies/ui/movie_trailer.dart';
import 'package:the_movies/features/movies/ui/movies.dart';
import 'package:the_movies/features/movies/ui/movies_search.dart';

class TheMoviesApp extends StatelessWidget {
  const TheMoviesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'The Movies',
      theme: ThemeClass.lightTheme(context),
      initialRoute: MoviesPage.routeName,
      routes: {
        MoviesPage.routeName: (context) => const MoviesPage(),
        MoviesSearchPage.routeName: (context) => const MoviesSearchPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == MovieDetailsPage.routeName) {
          return MaterialPageRoute(
            builder: (context) {
              return MovieDetailsPage(
                  movieModel: settings.arguments as MoviesModel);
            },
          );
        } else if (settings.name == MovieTrailerPlayerPage.routeName) {
          return MaterialPageRoute(
            builder: (context) {
              return MovieTrailerPlayerPage(
                  movieDetails: settings.arguments as MovieDetailsModel);
            },
          );
        }
        assert(false, 'Implementation not found for ${settings.name}');
        return null;
      },
    );
  }
}
