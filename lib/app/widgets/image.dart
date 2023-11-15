import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget? getNetworkImage(String path, String url,
    {Widget errorWidget = const AspectRatio(
      aspectRatio: 1,
      child: Image(
        fit: BoxFit.cover,
        image: AssetImage("assets/images/movie-background.jpg"),
      ),
    ),
    Widget? progressWidget,
    bool noProgress = false,
    Widget Function(BuildContext, ImageProvider<Object>)? imageBuilder}) {
  return url.isEmpty
      ? null
      : CachedNetworkImage(
          fit: BoxFit.cover,
          imageUrl: path + url,
          imageBuilder: imageBuilder,
          progressIndicatorBuilder: noProgress
              ? null
              : (context, url, downloadProgress) =>
                  progressWidget ??
                  AspectRatio(
                    aspectRatio: 1,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        getNoImage(),
                        Center(
                          child: SizedBox(
                            height: 42,
                            width: 42,
                            child: CircularProgressIndicator(
                              value: downloadProgress.progress,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          errorWidget: (context, url, error) => errorWidget,
        );
}

Widget getNoImage() {
  return const AspectRatio(
    aspectRatio: 1,
    child: Image(
      fit: BoxFit.cover,
      image: AssetImage("assets/images/movie-background.jpg"),
    ),
  );
}
