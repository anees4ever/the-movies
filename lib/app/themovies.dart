import 'package:flutter/material.dart';
import 'package:the_movies/features/movies/model/movie_details_model.dart';
import 'package:the_movies/features/movies/model/movies_model.dart';
import 'package:the_movies/features/movies/ui/movie_details.dart';
import 'package:the_movies/features/movies/ui/movie_trailer.dart';
import 'package:the_movies/features/movies/ui/movies.dart';

class TheMoviesApp extends StatelessWidget {
  const TheMoviesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => const MoviesPage(title: 'Flutter Demo Home Page'),
      },
      onGenerateRoute: (settings) {
        if (settings.name == "/movie") {
          return MaterialPageRoute(
            builder: (context) {
              return MovieDetailsPage(
                  movieModel: settings.arguments as MoviesModel);
            },
          );
        } else if (settings.name == "/movie/trailer") {
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
