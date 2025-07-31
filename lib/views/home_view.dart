import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/yt_controller.dart';
import '../custom_widgets/yt_player_widget.dart';

class ShortsHomePage extends StatelessWidget {
  const ShortsHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final YTController controller = Get.put(YTController());

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: controller.videoIds.length,
        itemBuilder: (context, index) {
          return YTShortPlayer(videoId: controller.videoIds[index]);
        },
      );
    });
  }
}
