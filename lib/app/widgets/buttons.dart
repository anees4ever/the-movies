import 'package:flutter/material.dart';
import 'package:the_movies/app/theme/colors.dart';
import 'package:the_movies/app/theme/styles.dart';

getPrimaryButton(
    {required String title,
    IconData? icon,
    double? width,
    double height = 48,
    bool isBig = false,
    void Function()? onPressed}) {
  return SizedBox(
    width: width,
    height: height,
    child: ElevatedButton(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(colorSecondary),
        backgroundColor: MaterialStateProperty.all(colorSecondary),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: const BorderSide(
              color: colorSecondary,
            ),
          ),
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null)
            Icon(
              icon,
              size: isBig ? 20 : 14,
              color: textColorDark,
            ),
          Text(
            title,
            style: isBig ? text16BoldDarkStyle : text14BoldDarkStyle,
          ),
        ],
      ),
    ),
  );
}

getSecondaryButton(
    {required String title,
    IconData? icon,
    double? width,
    double height = 48,
    bool isBig = false,
    void Function()? onPressed}) {
  return SizedBox(
    width: width,
    height: height,
    child: ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.black12),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: const BorderSide(
              color: colorSecondary,
            ),
          ),
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null)
            Icon(
              icon,
              size: isBig ? 20 : 14,
              color: textColorDark,
            ),
          if (icon != null) const SizedBox(width: 6.0),
          Text(
            title,
            style: isBig ? text16BoldDarkStyle : text14BoldDarkStyle,
          ),
        ],
      ),
    ),
  );
}
