import 'package:flutter/material.dart';
import 'package:the_movies/app/theme/colors.dart';
import 'package:the_movies/app/theme/styles.dart';
import 'package:the_movies/app/widgets/buttons.dart';
import 'package:the_movies/app/widgets/image.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage(
      {super.key, this.back = true, required this.title, required this.error});

  final bool back;
  final String title;
  final String error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          getNoImage(),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Color(0x00FFFFFF),
                    Colors.black54,
                    Colors.black54,
                    Color(0x00FFFFFF),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 0.4, 0.6, 1.0],
                  tileMode: TileMode.clamp),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline_outlined,
                  size: 72,
                  color: colorTileGreen,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: text20RobotoRedStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        error,
                        style: text16BoldDarkStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                if (back) const SizedBox(height: 16),
                if (back)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      getPrimaryButton(
                        title: "Back",
                        icon: Icons.arrow_back_ios_outlined,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
