import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YTShortPlayer extends StatefulWidget {
  final String videoId;

  const YTShortPlayer({super.key, required this.videoId});

  @override
  State<YTShortPlayer> createState() => _YTShortPlayerState();
}

class _YTShortPlayerState extends State<YTShortPlayer> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        enableCaption: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(controller: _controller),
      builder: (context, player) {
        return Scaffold(
          body: Stack(
            children: [
              Center(child: player),
              Positioned(
                bottom: 50,
                right: 20,
                child: Column(
                  children: const [
                    Icon(Icons.favorite_border, size: 30),
                    SizedBox(height: 10),
                    Icon(Icons.comment, size: 30),
                    SizedBox(height: 10),
                    Icon(Icons.share, size: 30),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
