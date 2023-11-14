import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_movies/app/api/api.dart';
import 'package:the_movies/features/movies/bloc/movies_bloc.dart';
import 'package:the_movies/features/movies/model/movies_model.dart';

class MovieDetailsPage extends StatefulWidget {
  const MovieDetailsPage({super.key, required this.movieModel});

  final MoviesModel movieModel;

  @override
  State<MovieDetailsPage> createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  final MoviesBloc moviesBloc = MoviesBloc();

  @override
  void initState() {
    moviesBloc
        .add(MovieDetailsInitialFetchEvent(movieId: widget.movieModel.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.movieModel.title),
      ),
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

              return ListView(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                    child: Image(
                      fit: BoxFit.cover,
                      image: NetworkImage(urlTMdbImagesW500 +
                          successState.movieDetails.backdropPath),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        "/movie/trailer",
                        arguments: state.movieDetails,
                      );
                    },
                    child: const Text("Watch Trailer"),
                  ),
                  Text(
                    successState.movieDetails.title,
                    style: const TextStyle(color: Colors.black),
                  ),
                  Text(
                    successState.movieDetails.overview,
                    style: const TextStyle(color: Colors.black),
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
}
