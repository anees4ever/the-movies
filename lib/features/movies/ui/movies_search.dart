import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_movies/app/api/api.dart';
import 'package:the_movies/app/theme/colors.dart';
import 'package:the_movies/app/theme/styles.dart';
import 'package:the_movies/app/widgets/fade_animation.dart';
import 'package:the_movies/app/widgets/image.dart';
import 'package:the_movies/features/movies/bloc/movies_bloc.dart';
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
          style: appBarTitleStyle,
        ),
      ),
      extendBody: true,
      body: const Center(
        child: CircularProgressIndicator(),
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
        child: Text("Search for your favorite movies.",
            style: searchMovieNameStyle),
      ),
    );
  }

  Widget getSearchResultScafold(final MovieSearchSuccessfulState successState) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${successState.movies.length} Results Found",
          style: appBarTitleStyle,
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
            return FadeAnimation(
              delay: (index + 1) * 10,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    MovieDetailsPage.routeName,
                    arguments: successState.movies[index],
                  );
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 5,
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
                                          .movies[index].backdropPath) ??
                                  getNoImage(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 5,
                        child: Text(
                          successState.movies[index].title,
                          style: searchMovieNameStyle,
                        ),
                      ),
                      const Icon(
                        Icons.more_horiz_outlined,
                        color: colorSecondary,
                        size: 32,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
