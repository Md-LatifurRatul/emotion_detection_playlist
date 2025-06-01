import 'package:emotion_music_app/services/auth_exception.dart';
import 'package:emotion_music_app/services/firebase_auth_service.dart';
import 'package:emotion_music_app/ui/screens/auth/login_screen.dart';
import 'package:emotion_music_app/ui/widgets/confirm_alert_dialogue.dart';
import 'package:emotion_music_app/ui/widgets/mood_detection_button.dart';
import 'package:emotion_music_app/ui/widgets/snack_message.dart';
import 'package:flutter/material.dart';

class EmotionDetectionHomeScreen extends StatefulWidget {
  const EmotionDetectionHomeScreen({super.key});

  @override
  State<EmotionDetectionHomeScreen> createState() =>
      _EmotionDetectionHomeScreenState();
}

class _EmotionDetectionHomeScreenState
    extends State<EmotionDetectionHomeScreen> {
  // List<Map<String, String>> _songs = [];
  // bool _isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _signOut(BuildContext context) async {
    final firebaseAuthService = FirebaseAuthService();

    try {
      await firebaseAuthService.signOut();

      SnackMessage.showSnakMessage(context, "Sign out success");

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false,
      );
    } on AuthException catch (e) {
      print("Sign out error: ${e.message}");
      SnackMessage.showSnakMessage(context, "Sign out failed");
    } catch (e) {
      print(e.toString());
    }
  }

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
        elevation: 0,
        actions: [
          IconButton(
            style: IconButton.styleFrom(backgroundColor: Colors.tealAccent),

            onPressed: () {
              ConfirmAlertDialogue.showAlertDialogue(
                context,
                title: "Sign Out",
                content: "Are you sure you want to log-out?",
                confirmString: "Log-out",
                onPressed: () {
                  _signOut(context);
                },
              );
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MoodDetectionButton(
                  icon: Icons.camera_alt,
                  label: 'Face Detection',
                  onTap: () {},
                ),

                MoodDetectionButton(
                  icon: Icons.mic,
                  label: 'Speech Detection',
                  onTap: () async {},
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Suggested Playlists",

              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: ListView.builder(
              itemCount: 5,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemBuilder: (context, index) {
                return _buildPlaylistCard(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaylistCard(int index) {
    final titles = [
      "Happy Vibes",
      "Relaxing Tunes",
      "Energetic Beats",
      "Chill Hits",
      "Focus Mode",
    ];
    return Card(
      color: Colors.grey[850],

      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),

      child: ListTile(
        // leading: ClipRRect(
        //   borderRadius: BorderRadius.circular(8),
        //   child: Image.network(
        //     titles[index],
        //     width: 50,
        //     height: 50,
        //     fit: BoxFit.cover,
        //   ),
        // ),
        title: Text(
          titles[index],
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          "Mood: ${titles[index]}",
          style: const TextStyle(color: Colors.white70),
        ),

        trailing: const Icon(Icons.play_arrow, color: Colors.white),
        onTap: () {},
      ),
    );
  }
}
