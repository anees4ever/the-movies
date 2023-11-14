import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_movies/app/api/api.dart';
import 'package:the_movies/app/theme/colors.dart';
import 'package:the_movies/app/theme/styles.dart';
import 'package:the_movies/app/widgets/fade_animation.dart';
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
            ],
            color: colorNavBar,
          ),
        ),
      ),
      extendBody: true,
      bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
            ],
            color: colorNavBar,
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(30),
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: 1,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.apps_outlined),
                  label: "Dashboard",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.ondemand_video_outlined),
                  label: "Watch",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.video_library_outlined),
                  label: "Media Library",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.list_outlined),
                  label: "More",
                ),
              ],
            ),
          )),
      body: BlocConsumer<MoviesBloc, MoviesState>(
        bloc: moviesBloc,
        listener: (context, state) {},
        builder: (context, state) {
          switch (state.runtimeType) {
            case MoviesFetchingLoadingState:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case MoviesFetchingSuccessfulState:
              final successState = state as MoviesFetchingSuccessfulState;

              return ListView.builder(
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
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Container(
                          padding: const EdgeInsets.all(0),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                            color: colorAppBackground,
                            shape: BoxShape.rectangle,
                          ),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(8.0)),
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: urlTMdbImagesW500 +
                                      successState.movies[index].backdropPath,
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) =>
                                          Center(
                                    child: SizedBox(
                                      height: 42,
                                      width: 42,
                                      child: CircularProgressIndicator(
                                        value: downloadProgress.progress,
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
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
                                      colors: [
                                        Colors.transparent,
                                        Colors.black87,
                                      ],
                                    ),
                                  ),
                                  child: Text(
                                    successState.movies[index].title,
                                    style: upcomingMovieNameStyle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            default:
              return const SizedBox();
          }
        },
      ),
    );
  }
}
