import 'package:emotion_music_app/ui/screens/music_player_screen.dart';
import 'package:flutter/material.dart';

class EmotionDetecterPlaylistApp extends StatelessWidget {
  const EmotionDetecterPlaylistApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: "Emotion Playlist App",
      // home: const EmotionDetectionHomeScreen(),
      home: MusicPlayerScreen(),
    );
  }
}
