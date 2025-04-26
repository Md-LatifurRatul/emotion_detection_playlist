import 'package:emotion_music_app/controller/services/auth_exception.dart';
import 'package:emotion_music_app/controller/services/firebase_auth_service.dart';
import 'package:emotion_music_app/ui/screens/auth/login_screen.dart';
import 'package:emotion_music_app/ui/widgets/confirm_alert_dialogue.dart';
import 'package:emotion_music_app/ui/widgets/mood_detection_button.dart';
import 'package:emotion_music_app/ui/widgets/snack_message.dart';
import 'package:flutter/material.dart';

class EmotionDetectionHomeScreen extends StatelessWidget {
  const EmotionDetectionHomeScreen({super.key});

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
                  onTap: () {},
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
        leading: const Icon(Icons.music_note, color: Colors.white),

        title: Text(
          titles[index],
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),

        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.white54,
          size: 18,
        ),
        onTap: () {},
      ),
    );
  }
}
