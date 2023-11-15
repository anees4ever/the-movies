import 'package:flutter/material.dart';
import 'package:the_movies/app/theme/colors.dart';

class BottomNavBarWidget extends StatelessWidget {
  const BottomNavBarWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
        ));
  }
}
