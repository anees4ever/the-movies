import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_movies/app/api/api.dart';
import 'package:the_movies/app/theme/colors.dart';
import 'package:the_movies/app/theme/styles.dart';
import 'package:the_movies/app/widgets/bottom_navbar.dart';
import 'package:the_movies/app/widgets/error_page.dart';
import 'package:the_movies/app/widgets/image.dart';
import 'package:the_movies/app/widgets/shimmer_skeleton.dart';
import 'package:the_movies/features/movies/bloc/movies_bloc.dart';
import 'package:the_movies/features/movies/model/genres_model.dart';
import 'package:the_movies/features/movies/model/movie_data_model.dart';
import 'package:the_movies/features/movies/model/movie_genres_model.dart';
import 'package:the_movies/features/movies/ui/movie_details.dart';

class MoviesSearchPage extends StatefulWidget {
  static const String routeName = "/movies/search";
  const MoviesSearchPage({super.key});

  @override
  State<MoviesSearchPage> createState() => _MoviesSearchPageState();
}

class _MoviesSearchPageState extends State<MoviesSearchPage> {
  final MoviesBloc moviesBloc = MoviesBloc();

  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  List<GenresEx> genresList = [];
  List<MovieInfo> movieInfoList = [];

  MoviesState currentState = MovieSearchInitState();

  @override
  void initState() {
    moviesBloc.add(MovieSearchInitEvent());
    super.initState();
  }

  startSearching() {
    moviesBloc.add(MovieSearchSearchingEvent(query: _controller.text.trim()));
  }

  startSearchDone() {
    _focusNode.nextFocus();
    moviesBloc.add(MovieSearchResultEvent(movies: movieInfoList));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (currentState.runtimeType == MovieSearchSuccessfulState ||
            currentState.runtimeType == MovieSearchSearchingState) {
          _controller.text = "";
          movieInfoList = [];
          moviesBloc.add(MovieSearchInitEvent(genres: genresList));
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 79,
            automaticallyImplyLeading: false,
            title: BlocConsumer<MoviesBloc, MoviesState>(
              bloc: moviesBloc,
              listener: (context, state) {},
              builder: (context, state) {
                currentState = state;
                if (state.runtimeType == MovieSearchSuccessfulState) {
                  var successState = state as MovieSearchSuccessfulState;
                  return Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_outlined,
                          color: textColor,
                          size: 28,
                        ),
                        onPressed: () {
                          _controller.text = "";
                          movieInfoList = [];
                          moviesBloc
                              .add(MovieSearchInitEvent(genres: genresList));
                        },
                      ),
                      Text(
                        "${successState.movies.length} Results Found",
                        style: text16BoldStyle,
                      ),
                    ],
                  );
                }
                return TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        borderSide:
                            BorderSide(color: colorAppBackground, width: 1.0)),
                    focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        borderSide:
                            BorderSide(color: colorAppBackground, width: 1.0)),
                    prefixIcon: const Icon(
                      Icons.search_outlined,
                      color: textColor,
                      size: 32,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        if (_controller.text.isEmpty) {
                          Navigator.of(context).pop();
                        } else {
                          _controller.text = "";
                          moviesBloc
                              .add(MovieSearchInitEvent(genres: genresList));
                          _focusNode.requestFocus();
                        }
                      },
                      icon: const Icon(
                        Icons.close_outlined,
                        color: textColor,
                        size: 32,
                      ),
                    ),
                    border: InputBorder.none,
                    filled: true,
                    fillColor: colorAppBackground,
                    hintText: "TV shows, movies and more",
                  ),
                  onChanged: (value) {
                    startSearching();
                  },
                  onEditingComplete: () {
                    if (_controller.text.trim().isNotEmpty) {
                      startSearchDone();
                    } else {
                      _focusNode.nextFocus();
                    }
                  },
                );
              },
            ),
          ),
          extendBody: true,
          bottomNavigationBar: const BottomNavBarWidget(),
          body: BlocConsumer<MoviesBloc, MoviesState>(
            bloc: moviesBloc,
            listener: (context, state) {},
            builder: (context, state) {
              switch (state.runtimeType) {
                case MovieSearchSuccessfulState:
                  final MovieSearchSuccessfulState successState =
                      state as MovieSearchSuccessfulState;
                  movieInfoList = successState.movies;
                  return getSearchResultView(false, successState.movies);
                case MovieSearchErrorState:
                  return const ErrorPage(
                    back: false,
                    title: "No Search results!",
                    error: "Search result failed to show movie results.",
                  );

                case MovieSearchSearchingState:
                  final MovieSearchSearchingState searchingState =
                      state as MovieSearchSearchingState;
                  movieInfoList = searchingState.movies;
                  if (_controller.text.trim().isEmpty) {
                    return getSearchMainScreen();
                  } else {
                    return getSearchResultView(true, searchingState.movies);
                  }

                case MovieSearchMainState:
                  genresList = (state as MovieSearchMainState).genres;
                  return getSearchMainScreen();
                case MovieSearchInitState:
                default:
                  return getLoadingScreen();
              }
            },
          )),
    );
  }

  Widget getLoadingScreen() {
    Widget row = const Row(
      children: [
        Expanded(
          child: AspectRatio(
            aspectRatio: 14 / 9,
            child: ShimmerLoading(
              isLoading: true,
              child: SizedBox(
                height: 140,
                child: ShimmerSkeleton(),
              ),
            ),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: AspectRatio(
            aspectRatio: 14 / 9,
            child: ShimmerLoading(
              isLoading: true,
              child: SizedBox(
                height: 140,
                child: ShimmerSkeleton(),
              ),
            ),
          ),
        ),
      ],
    );
    return Shimmer(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            row,
            const SizedBox(height: 16.0),
            row,
            const SizedBox(height: 16.0),
            row,
            const SizedBox(height: 16.0),
            row,
            const SizedBox(height: 16.0),
            row,
            const SizedBox(height: 16.0),
            row,
          ],
        ),
      ),
    );
  }

  Widget getSearchMainScreen() {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 60),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 14 / 9,
      ),
      itemCount: genresList.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            moviesBloc.add(
              MovieSearchResultEvent(genreId: genresList[index].id),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(0),
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              color: colorAppBackground,
              shape: BoxShape.rectangle,
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  child: getNetworkImage(
                          urlTMdbImagesW500, genresList[index].image) ??
                      getNoImage(),
                ),
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
                        colors: [
                          Colors.transparent,
                          Colors.black87,
                        ],
                      ),
                    ),
                    child: Text(
                      genresList[index].name,
                      style: text16BoldDarkStyle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget getSearchResultView(final bool isSearching, List<MovieInfo> movies) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isSearching)
            const Text(
              "Top Results",
              style: text12BoldStyle,
            ),
          if (isSearching)
            const Divider(
              height: 16,
              thickness: 1,
              color: colorDivider,
            ),
          Expanded(
            child: ListView.builder(
              itemCount: isSearching ? min(movies.length, 6) : movies.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      MovieDetailsPage.routeName,
                      arguments: movies[index],
                    );
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Container(
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                color: colorAppBackground,
                                shape: BoxShape.rectangle,
                              ),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(8.0)),
                                child: getNetworkImage(urlTMdbImagesW500,
                                        movies[index].data.backdropPath) ??
                                    getNoImage(),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                            flex: 6,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  movies[index].data.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: text16BoldStyle,
                                ),
                                Text(
                                  getGenreNameFromIds(movies[index].genres,
                                      movies[index].genresMaster),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: text12TintedStyle,
                                ),
                              ],
                            )),
                        const Icon(
                          Icons.more_horiz_outlined,
                          color: colorSecondary,
                          size: 32,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String getGenreNameFromIds(List<MovieGenres> genreIds, List<Genres> genres) {
    String names = "";
    for (var movieGenre in genreIds) {
      Genres? genre = genres
          .where((element) => element.id == movieGenre.genreId)
          .firstOrNull;
      names += genre == null ? "" : (names.isEmpty ? "" : ", ") + genre.name;
    }
    return names;
  }
}
