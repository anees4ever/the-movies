import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_movies/app/theme/theme.dart';
import 'package:the_movies/features/booking/provider/booking_provider.dart';
import 'package:the_movies/features/booking/ui/booking_seats.dart';
import 'package:the_movies/features/booking/ui/booking_slots.dart';
import 'package:the_movies/features/movies/model/movie_data_model.dart';
import 'package:the_movies/features/movies/ui/movie_details.dart';
import 'package:the_movies/features/movies/ui/movie_trailer.dart';
import 'package:the_movies/features/movies/ui/movies.dart';
import 'package:the_movies/features/movies/ui/movies_search.dart';

class TheMoviesApp extends StatelessWidget {
  const TheMoviesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => BookingProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'The Movies',
        theme: ThemeClass.lightTheme(context),
        initialRoute: MoviesPage.routeName,
        routes: {
          MoviesPage.routeName: (context) => const MoviesPage(),
          MoviesSearchPage.routeName: (context) => const MoviesSearchPage(),
          BookingSeatsPage.routeName: (context) => const BookingSeatsPage(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == MovieDetailsPage.routeName) {
            return MaterialPageRoute(
              builder: (context) {
                return MovieDetailsPage(
                    movieInfo: settings.arguments as MovieInfo);
              },
            );
          } else if (settings.name == MovieTrailerPlayerPage.routeName) {
            return MaterialPageRoute(
              builder: (context) {
                return MovieTrailerPlayerPage(
                    movieInfo: settings.arguments as MovieInfo);
              },
            );
          } else if (settings.name == BookingSlotsPage.routeName) {
            return MaterialPageRoute(
              builder: (context) {
                return BookingSlotsPage(
                    movieInfo: settings.arguments as MovieInfo);
              },
            );
          }
          assert(false, 'Implementation not found for ${settings.name}');
          return null;
        },
      ),
    );
  }
}
