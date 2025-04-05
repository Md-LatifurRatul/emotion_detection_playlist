import 'package:emotion_music_app/ui/screens/main_bottom_nav_bar_screen.dart';
import 'package:flutter/material.dart';

class EmotionDetecterPlaylistApp extends StatelessWidget {
  const EmotionDetecterPlaylistApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: "Emotion Playlist App",
      home: const MainBottomNavBarScreen(),
      // home: MusicPlayerScreen(),
    );
  }
}
