import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ShortsHomePage extends StatefulWidget {
  const ShortsHomePage({super.key});

  @override
  State<ShortsHomePage> createState() => _ShortsHomePageState();
}

class _ShortsHomePageState extends State<ShortsHomePage> {
  final String apiKey = '';
  final String channelId = '';
  List<String> videoIds = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchVideoIds();
  }

  Future<void> fetchVideoIds() async {
    try {
      // Step 1: Get Uploads Playlist ID
      final channelRes = await http.get(
        Uri.parse(
          'https://www.googleapis.com/youtube/v3/channels?part=contentDetails&id=$channelId&key=$apiKey',
        ),
      );
      final channelJson = json.decode(channelRes.body);
      final uploadsPlaylistId =
          channelJson['items'][0]['contentDetails']['relatedPlaylists']['uploads'];

      // Step 2: Get videos from Uploads Playlist
      final playlistRes = await http.get(
        Uri.parse(
          'https://www.googleapis.com/youtube/v3/playlistItems?part=contentDetails&maxResults=25&playlistId=$uploadsPlaylistId&key=$apiKey',
        ),
      );
      final playlistJson = json.decode(playlistRes.body);

      final ids = (playlistJson['items'] as List)
          .map((item) => item['contentDetails']['videoId'] as String)
          .toList();

      setState(() {
        videoIds = ids;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching videos: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: videoIds.length,
      itemBuilder: (context, index) {
        return YouTubeShortPlayer(videoId: videoIds[index]);
      },
    );
  }
}

class YouTubeShortPlayer extends StatefulWidget {
  final String videoId;

  const YouTubeShortPlayer({super.key, required this.videoId});

  @override
  State<YouTubeShortPlayer> createState() => _YouTubeShortPlayerState();
}

class _YouTubeShortPlayerState extends State<YouTubeShortPlayer> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
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
