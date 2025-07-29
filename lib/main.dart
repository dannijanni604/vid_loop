import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'views/home_view.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(YouTubeShortsApp());
}

class YouTubeShortsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YouTube Shorts Viewer',
      theme: ThemeData.dark(),
      home: ShortsHomePage(),
    );
  }
}
