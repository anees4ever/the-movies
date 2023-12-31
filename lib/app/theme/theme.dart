import 'package:flutter/material.dart';
import 'package:the_movies/app/theme/colors.dart';
import 'package:the_movies/app/theme/styles.dart';

class ThemeClass {
  static ThemeData lightTheme(BuildContext context) => ThemeData(
        primaryColor: textColor,
        appBarTheme: const AppBarTheme(
          color: colorAppbar,
          foregroundColor: colorAppbar,
          titleTextStyle: text16BoldStyle,
          iconTheme: IconThemeData(
            color: textColor,
            size: 32,
          ),
        ),
        scaffoldBackgroundColor: colorAppBackground, //page content area
        textTheme: Theme.of(context).textTheme.apply(
              fontFamily: 'Poppins',
              bodyColor: textColor,
            ),
        useMaterial3: true,

        canvasColor: colorAppBackground, //reset of the area / drawer

        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: colorAppBackground,
          unselectedItemColor: colorIcons,
          backgroundColor: colorNavBar,
          selectedLabelStyle: text10RobotoStyle,
          unselectedLabelStyle: text10RobotoStyle,
        ),
      );
}
