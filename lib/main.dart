import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

import 'views/home_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const YouTubeShortsApp());
}

class YouTubeShortsApp extends StatelessWidget {
  const YouTubeShortsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'YouTube Shorts Viewer',
      theme: ThemeData.dark(),
      home: const ShortsHomePage(),
    );
  }
}
