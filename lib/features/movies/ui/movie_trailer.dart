import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_movies/app/widgets/buttons.dart';
import 'package:the_movies/app/widgets/error_page.dart';
import 'package:the_movies/features/movies/model/movie_details_model.dart';
import 'package:the_movies/features/movies/model/movie_videos_model.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MovieTrailerPlayerPage extends StatefulWidget {
  static const String routeName = "/movies/trailer";
  final MovieDetailsModel movieDetails;
  const MovieTrailerPlayerPage({super.key, required this.movieDetails});

  @override
  State<MovieTrailerPlayerPage> createState() => _MovieTrailerPlayerPageState();
}

class _MovieTrailerPlayerPageState extends State<MovieTrailerPlayerPage> {
  late YoutubePlayerController youtubePlayerController;
  String videoId = "";
  @override
  void initState() {
    videoId = widget.movieDetails.movieVideos.isEmpty
        ? ""
        : widget.movieDetails.movieVideos[0].key;
    if (widget.movieDetails.movieVideos.isNotEmpty) {
      for (MovieVideosModel video in widget.movieDetails.movieVideos) {
        if (video.type.toLowerCase().contains("trailer")) {
          videoId = video.key;
          break;
        }
      }
    }

    //videoId = "";
    if (videoId.isNotEmpty) {
      youtubePlayerController = YoutubePlayerController(
        initialVideoId: videoId,
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
    } else {
      youtubePlayerController = YoutubePlayerController(initialVideoId: "");
    }
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
    if (videoId.isEmpty) {
      return const ErrorPage(
        title: "No Trailer Video Found...",
        error: "No Trailer video found in the response.",
      );
    }
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
          getSecondaryButton(
            title: "Done",
            icon: Icons.close_outlined,
            height: 32,
            width: 120,
            onPressed: () {
              SystemChrome.setPreferredOrientations(DeviceOrientation.values)
                  .then((value) => Navigator.of(context).pop());
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
