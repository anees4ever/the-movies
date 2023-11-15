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
import 'package:the_movies/features/movies/ui/movie_details.dart';
import 'package:the_movies/features/movies/ui/movies_search.dart';

class MoviesPage extends StatefulWidget {
  static const String routeName = "/";
  const MoviesPage({super.key});

  @override
  State<MoviesPage> createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {
  final MoviesBloc moviesBloc = MoviesBloc();

  @override
  void initState() {
    moviesBloc.add(MoviesInitialFetchEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Watch"),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_outlined),
            onPressed: () {
              Navigator.pushNamed(context, MoviesSearchPage.routeName);
            },
          ),
        ],
      ),
      extendBody: true,
      bottomNavigationBar: const BottomNavBarWidget(),
      body: BlocConsumer<MoviesBloc, MoviesState>(
        bloc: moviesBloc,
        listener: (context, state) {},
        builder: (context, state) {
          switch (state.runtimeType) {
            case MoviesFetchingLoadingState:
              return Shimmer(
                child: ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: List.generate(
                    5,
                    (index) => const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: ShimmerLoading(
                        isLoading: true,
                        child: SizedBox(
                          height: 200,
                          child: ShimmerSkeleton(),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            case MoviesFetchingSuccessfulState:
              final successState = state as MoviesFetchingSuccessfulState;

              return ListView.builder(
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
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Container(
                        padding: const EdgeInsets.all(0),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          color: colorAppBackground,
                          shape: BoxShape.rectangle,
                        ),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8.0)),
                              child: getNetworkImage(
                                      urlTMdbImagesW500,
                                      successState
                                          .movies[index].data.backdropPath) ??
                                  getNoImage(),
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
                                  successState.movies[index].data.title,
                                  style: text18BoldDarkStyle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            case MoviesFetchingErrorState:
              return const ErrorPage(
                back: false,
                title: "No Upcoming movies!",
                error:
                    "No Upcoming movies or unable to load movies from server.",
              );
            default:
              return const SizedBox();
          }
        },
      ),
    );
  }
}
