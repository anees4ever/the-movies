import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_movies/app/api/api.dart';
import 'package:the_movies/app/theme/colors.dart';
import 'package:the_movies/app/theme/styles.dart';
import 'package:the_movies/app/widgets/buttons.dart';
import 'package:the_movies/app/widgets/error_page.dart';
import 'package:the_movies/app/widgets/image.dart';
import 'package:the_movies/features/movies/bloc/movies_bloc.dart';
import 'package:the_movies/features/movies/model/movies_model.dart';
import 'package:the_movies/features/movies/ui/movie_trailer.dart';

class MovieDetailsPage extends StatefulWidget {
  static const String routeName = "/movies";
  const MovieDetailsPage({super.key, required this.movieModel});

  final MoviesModel movieModel;

  @override
  State<MovieDetailsPage> createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  final MoviesBloc moviesBloc = MoviesBloc();

  @override
  void initState() {
    if (widget.movieModel.id > 0) {
      moviesBloc
          .add(MovieDetailsInitialFetchEvent(movieId: widget.movieModel.id));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.movieModel.id <= 0) {
      return const ErrorPage(
        title: "Movie Details not found...",
        error: "No movie found in the response.",
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Watch",
          style: appBarSubTitleStyle,
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
          switch (state.runtimeType) {
            case MovieDetailsFetchingLoadingState:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case MovieDetailsFetchingSuccessfulState:
              final successState = state as MovieDetailsFetchingSuccessfulState;
              double width = MediaQuery.of(context).size.width;
              double buttonSize = width * 0.5;
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      getNetworkImage(
                            urlTMdbImagesBig,
                            successState.movieDetails.backdropPath,
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
                            borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(8.0)),
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
                              if (successState.movieImageList.logos.isEmpty)
                                Text(
                                  widget.movieModel.title,
                                  style: movieNameStyle,
                                ),
                              if (successState.movieImageList.logos.isNotEmpty)
                                SizedBox(
                                  width: buttonSize,
                                  child: AspectRatio(
                                    aspectRatio: successState
                                        .movieImageList.logos[0].aspectRatio,
                                    child: getNetworkImage(
                                          urlTMdbImagesBig,
                                          successState
                                              .movieImageList.logos[0].filePath,
                                          progressWidget: Center(
                                            child: Text(
                                              widget.movieModel.title,
                                              style: movieNameStyle,
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
                                "In Theaters ${widget.movieModel.releaseDateFormatted}",
                                style: appBarSubTitleStyle,
                              ),
                              const SizedBox(
                                height: 8.0,
                              ),
                              getPrimaryButton(
                                title: "Get Tickets",
                                width: buttonSize,
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          "This feature is not implemented."),
                                    ),
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
                                    Navigator.pushNamed(
                                      context,
                                      MovieTrailerPlayerPage.routeName,
                                      arguments: state.movieDetails,
                                    );
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
                          style: appBarTitleStyle,
                        ),
                        Wrap(
                          direction: Axis.horizontal,
                          alignment: WrapAlignment.start,
                          spacing: 8.0,
                          children: state.movieDetails.genres
                              .map(
                                (genre) => Chip(
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  ),
                                  label: Text(genre.name, style: chipTextStyle),
                                  backgroundColor: getTileColor(
                                      state.movieDetails.genres.indexOf(genre)),
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
                          style: appBarTitleStyle,
                        ),
                        Text(
                          successState.movieDetails.overview,
                          style: overviewTextStyle,
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            default:
              return const SizedBox();
          }
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
