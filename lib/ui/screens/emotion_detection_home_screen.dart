import 'package:flutter/material.dart';

class EmotionDetectionHomeScreen extends StatelessWidget {
  const EmotionDetectionHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "Emotion-Based Music",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
      ),

      body: Column(
        children: [
          Container(
            height: 250,
            width: double.infinity,
            color: Colors.grey[900],

            child: Center(
              child: Icon(Icons.camera, size: 50, color: Colors.white),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.grey[800],
                  child: ListTile(
                    leading: Icon(Icons.music_note, color: Colors.white),
                    title: Text(
                      "Happy Vibes Playlist",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 10,

        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,

        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.music_note), label: "Music"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
        ],
      ),
    );
  }
}
