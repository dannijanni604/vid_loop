import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class YTService {
  final String apiKey = dotenv.env['YOUTUBE_API_KEY']!;
  final String channelId = dotenv.env['CHANNEL_ID']!;

  Future<List<String>> fetchShortsVideoIds() async {
    try {
      // Step 1: Get uploads playlist ID
      final channelRes = await http.get(
        Uri.parse(
          'https://www.googleapis.com/youtube/v3/channels?part=contentDetails&id=$channelId&key=$apiKey',
        ),
      );

      final uploadsPlaylistId = json.decode(
        channelRes.body,
      )['items'][0]['contentDetails']['relatedPlaylists']['uploads'];

      // Step 2: Get videos from uploads playlist
      final playlistRes = await http.get(
        Uri.parse(
          'https://www.googleapis.com/youtube/v3/playlistItems?part=contentDetails&maxResults=25&playlistId=$uploadsPlaylistId&key=$apiKey',
        ),
      );

      final videoIds = (json.decode(playlistRes.body)['items'] as List)
          .map((item) => item['contentDetails']['videoId'] as String)
          .toList();

      return videoIds;
    } catch (e) {
      print("Error fetching videos: $e");
      return [];
    }
  }
}
