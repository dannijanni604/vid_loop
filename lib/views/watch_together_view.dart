import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../controllers/watch_together_controller.dart';

class WatchTogetherScreen extends StatelessWidget {
  WatchTogetherScreen({Key? key}) : super(key: key);

  final controller = Get.put(WatchTogetherController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Watch Together')),
      body: Obx(() {
        if (!controller.isInRoom.value) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: controller.roomInput,
                  decoration: const InputDecoration(
                    labelText: 'Enter Room ID',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.joinRoom,
                  child: const Text('Join Room'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.createRoom,
                  child: const Text('Create Room'),
                ),
              ],
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Room ID: ${controller.roomID.value}', style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                if (controller.isHost.value) ...[
                  TextField(
                    controller: controller.videoUrlInput,
                    decoration: const InputDecoration(
                      labelText: 'Share YouTube Video URL',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: controller.shareVideo,
                    child: const Text('Share Video'),
                  ),
                ],
                const SizedBox(height: 20),
                if (controller.sharedVideoUrl.value.isNotEmpty)
                  YoutubePlayerBuilder(
                    player: YoutubePlayer(
                      controller: YoutubePlayerController(
                        initialVideoId: YoutubePlayer.convertUrlToId(controller.sharedVideoUrl.value) ?? '',
                        flags: const YoutubePlayerFlags(autoPlay: false),
                      ),
                      showVideoProgressIndicator: true,
                    ),
                    builder: (context, player) => player,
                  )
                else
                  const Center(child: Text("No video shared yet.")),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: controller.leaveRoom,
                  child: const Text('Leave Room'),
                ),
              ],
            ),
          );
        }
      }),
    );
  }
}
