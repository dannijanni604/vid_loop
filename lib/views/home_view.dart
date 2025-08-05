import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vid_loop/views/shorts_home_view.dart';
import 'package:vid_loop/views/watch_together_view.dart';
import 'meet_home_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: () => Get.to(()=>ShortsHomePage()) , child: const Text('Shorts View')),
            ElevatedButton(onPressed: () => Get.to(()=>MeetHomeView()) , child: const Text('Meet People')),
            ElevatedButton(onPressed: () => Get.to(()=>WatchTogetherScreen()) , child: const Text('Watch Together')),

          ],
        ),
      ),
    );
  }
}

