import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_movies/app/api/api.dart';
import 'package:the_movies/app/theme/colors.dart';
import 'package:the_movies/app/theme/styles.dart';
import 'package:the_movies/app/widgets/error_page.dart';
import 'package:the_movies/app/widgets/image.dart';
import 'package:the_movies/app/widgets/shimmer_skeleton.dart';
import 'package:the_movies/features/movies/bloc/movies_bloc.dart';
import 'package:the_movies/features/movies/model/genres_model.dart';
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

  Timer? _timer;

  @override
  void initState() {
    _focusNode.requestFocus();
    super.initState();
  }

  clearSearch() {
    try {
      if (_timer != null) {
        _timer!.cancel();
      }
    } catch (e, s) {
      log("$e, $s");
    }
  }

  startASearchDelayed() {
    clearSearch();
    _timer = Timer(const Duration(seconds: 2), startASearch);
  }

  startASearch() {
    clearSearch();

    _focusNode.nextFocus();
    moviesBloc.add(MovieSearchFetchEvent(query: _controller.text.trim()));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MoviesBloc, MoviesState>(
      bloc: moviesBloc,
      listener: (context, state) {},
      builder: (context, state) {
        switch (state.runtimeType) {
          case MovieSearchLoadingState:
            return getLoadingScafold();

          case MovieSearchSuccessfulState:
            final MovieSearchSuccessfulState successState =
                state as MovieSearchSuccessfulState;
            return getSearchResultScafold(successState);
          case MovieSearchErrorState:
            return const ErrorPage(
              back: false,
              title: "No Search results!",
              error: "Search result failed to show movie results.",
            );
          case MovieSearchEntryState:
          default:
            return getSearchbarScafold();
        }
      },
    );
  }

  Widget getLoadingScafold() {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 79,
        automaticallyImplyLeading: false,
        title: const Text(
          "Searching for movies...",
          style: text16BoldStyle,
        ),
      ),
      extendBody: true,
      body: Shimmer(
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          children: List.generate(
            5,
            (index) => const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: ShimmerLoading(
                isLoading: true,
                child: SizedBox(
                  height: 120,
                  child: Row(
                    children: [
                      Expanded(flex: 4, child: ShimmerSkeleton()),
                      SizedBox(width: 16),
                      Expanded(
                          flex: 6,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ShimmerSkeleton(height: 22),
                              SizedBox(height: 8),
                              ShimmerSkeleton(height: 22),
                            ],
                          )),
                      SizedBox(width: 4),
                      ShimmerSkeleton(
                        height: 32,
                        width: 32,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getSearchbarScafold() {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 79,
        automaticallyImplyLeading: false,
        title: TextField(
          controller: _controller,
          focusNode: _focusNode,
          decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                borderSide: BorderSide(color: colorAppBackground, width: 1.0)),
            focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                borderSide: BorderSide(color: colorAppBackground, width: 1.0)),
            prefixIcon: const Icon(
              Icons.search_outlined,
              color: textColor,
              size: 32,
            ),
            suffixIcon: IconButton(
              onPressed: () {
                clearSearch();
                if (_controller.text.isEmpty) {
                  Navigator.of(context).pop();
                } else {
                  _controller.text = "";
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
            startASearchDelayed();
          },
          onEditingComplete: () {
            startASearch();
          },
        ),
      ),
      extendBody: true,
      body: const Center(
        child: Text("Search for your favorite movies.", style: text16BoldStyle),
      ),
    );
  }

  Widget getSearchResultScafold(final MovieSearchSuccessfulState successState) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${successState.movies.length} Results Found",
          style: text16BoldStyle,
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_outlined,
            color: textColor,
          ),
          onPressed: () {
            _controller.text = "";
            _focusNode.requestFocus();
            moviesBloc.add(MovieSearchEntryEvent());
          },
        ),
      ),
      extendBody: true,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: successState.movies.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  MovieDetailsPage.routeName,
                  arguments: successState.movies[index],
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
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
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8.0)),
                            child: getNetworkImage(
                                    urlTMdbImagesW500,
                                    successState
                                        .movies[index].data.backdropPath) ??
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
                              successState.movies[index].data.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: text16BoldStyle,
                            ),
                            Text(
                              getGenreNameFromIds(
                                  successState.movies[index].genres,
                                  successState.movies[index].genresMaster),
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
