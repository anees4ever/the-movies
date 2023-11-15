import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_movies/app/api/api.dart';
import 'package:the_movies/app/theme/colors.dart';
import 'package:the_movies/app/theme/styles.dart';
import 'package:the_movies/app/widgets/buttons.dart';
import 'package:the_movies/app/widgets/error_page.dart';
import 'package:the_movies/app/widgets/image.dart';
import 'package:the_movies/features/booking/ui/booking_slots.dart';
import 'package:the_movies/features/movies/bloc/movies_bloc.dart';
import 'package:the_movies/features/movies/model/genres_model.dart';
import 'package:the_movies/features/movies/model/movie_data_model.dart';
import 'package:the_movies/features/movies/ui/movie_trailer.dart';

class MovieDetailsPage extends StatefulWidget {
  static const String routeName = "/movies";
  const MovieDetailsPage({super.key, required this.movieInfo});

  final MovieInfo movieInfo;

  @override
  State<MovieDetailsPage> createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  final MoviesBloc moviesBloc = MoviesBloc();

  @override
  void initState() {
    if (widget.movieInfo.data.id > 0) {
      moviesBloc.add(
          MovieDetailsInitialFetchEvent(movieId: widget.movieInfo.data.id));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.movieInfo.data.id <= 0) {
      return const ErrorPage(
        title: "Movie Details not found...",
        error: "No movie found in the response.",
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Watch",
          style: text16BoldDarkStyle,
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_outlined,
            color: textColorDark,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: BlocConsumer<MoviesBloc, MoviesState>(
        bloc: moviesBloc,
        listener: (context, state) {},
        builder: (context, state) {
          MovieDetailsFetchingSuccessfulState? successState =
              state.runtimeType == MovieDetailsFetchingSuccessfulState
                  ? state as MovieDetailsFetchingSuccessfulState
                  : null;
          double width = MediaQuery.of(context).size.width;
          double buttonSize = width * 0.5;
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Stack(
                children: [
                  getNetworkImage(
                        urlTMdbImagesBig,
                        widget.movieInfo.data.backdropPath,
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: const AspectRatio(
                            aspectRatio: 1,
                          ),
                        ),
                      ) ??
                      getNoImage(),
                  Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(
                        borderRadius:
                            BorderRadius.vertical(bottom: Radius.circular(8.0)),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0, 0.3, 0.9],
                          colors: [
                            Colors.transparent,
                            Colors.black54,
                            Colors.black,
                          ],
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 8.0,
                          ),
                          if (successState == null ||
                              successState.movieInfo.images.logos.isEmpty)
                            Text(
                              widget.movieInfo.data.title,
                              textAlign: TextAlign.center,
                              style: text16BoldDarkStyle,
                            ),
                          if (successState != null &&
                              successState.movieInfo.images.logos.isNotEmpty)
                            SizedBox(
                              width: buttonSize,
                              child: AspectRatio(
                                aspectRatio: successState
                                    .movieInfo.images.logos[0].aspectRatio,
                                child: getNetworkImage(
                                      urlTMdbImagesBig,
                                      successState
                                          .movieInfo.images.logos[0].filePath,
                                      progressWidget: Center(
                                        child: Text(
                                          widget.movieInfo.data.title,
                                          textAlign: TextAlign.center,
                                          style: text16BoldDarkStyle,
                                        ),
                                      ),
                                    ) ??
                                    getNoImage(),
                              ),
                            ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          Text(
                            "In Theaters ${widget.movieInfo.data.releaseDateFormatted}",
                            style: text16DarkStyle,
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          getPrimaryButton(
                            title: "Get Tickets",
                            width: buttonSize,
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                BookingSlotsPage.routeName,
                                arguments: successState == null
                                    ? widget.movieInfo
                                    : successState.movieInfo,
                              );
                            },
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          getSecondaryButton(
                              title: "Watch Trailer",
                              icon: Icons.play_arrow,
                              width: buttonSize,
                              onPressed: () {
                                if (successState == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Trailer videos are being downloaded. Please wait...")));
                                } else {
                                  Navigator.pushNamed(
                                    context,
                                    MovieTrailerPlayerPage.routeName,
                                    arguments: successState.movieInfo,
                                  );
                                }
                              }),
                          const SizedBox(
                            height: 16.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    const Text(
                      "Genres",
                      style: text16BoldStyle,
                    ),
                    Wrap(
                      direction: Axis.horizontal,
                      alignment: WrapAlignment.start,
                      spacing: 8.0,
                      children: widget.movieInfo.genres
                          .map(
                            (genre) => Chip(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              label: Text(
                                  Genres.getGenreMaster(
                                          widget.movieInfo.genresMaster,
                                          genre.genreId)
                                      .name,
                                  style: text12DarkStyle),
                              backgroundColor: getTileColor(
                                  widget.movieInfo.genres.indexOf(genre)),
                              side: BorderSide.none,
                              elevation: 0.0,
                            ),
                          )
                          .toList(),
                    ),
                    const Divider(
                      height: 32.0,
                      thickness: 1,
                      color: colorDivider,
                    ),
                    const Text(
                      "Overview",
                      style: text16BoldStyle,
                    ),
                    Text(
                      widget.movieInfo.data.overview,
                      style: text12Style,
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  getTileColor(int index) {
    return [
      colorTileGreen,
      colorTileMagenta,
      colorTilePurple,
      colorSecondary,
      colorTileYellow
    ][index % 5];
  }
}
