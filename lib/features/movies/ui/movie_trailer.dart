import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_movies/features/movies/model/movie_details_model.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MovieTrailerPlayerPage extends StatefulWidget {
  final MovieDetailsModel movieDetails;
  const MovieTrailerPlayerPage({super.key, required this.movieDetails});

  @override
  State<MovieTrailerPlayerPage> createState() => _MovieTrailerPlayerPageState();
}

class _MovieTrailerPlayerPageState extends State<MovieTrailerPlayerPage> {
  late YoutubePlayerController youtubePlayerController;

  @override
  void initState() {
    youtubePlayerController = YoutubePlayerController(
      initialVideoId: widget.movieDetails.movieVideos[0].key,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.initState();
  }

  void listener() {
    if (mounted && !youtubePlayerController.value.isFullScreen) {
      //setState(() { });
    }
  }

  @override
  void deactivate() {
    youtubePlayerController.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    youtubePlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      onExitFullScreen: () {
        SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      },
      onEnterFullScreen: () {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      },
      player: YoutubePlayer(
        controller: youtubePlayerController,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.blueAccent,
        topActions: <Widget>[
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              youtubePlayerController.metadata.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
              size: 25.0,
            ),
            onPressed: () {
              log('Settings Tapped!');
            },
          ),
        ],
        onReady: () {
          if (!youtubePlayerController.value.isFullScreen) {
            youtubePlayerController.toggleFullScreenMode();
          }
        },
        onEnded: (data) async {
          SystemChrome.setPreferredOrientations(DeviceOrientation.values)
              .then((value) => Navigator.of(context).pop());
        },
      ),
      builder: (context, player) {
        youtubePlayerController.toggleFullScreenMode();
        return player;
      },
    );
  }
}
