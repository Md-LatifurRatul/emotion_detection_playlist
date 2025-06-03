import 'package:emotion_music_app/controller/current_track_notifier.dart';
import 'package:emotion_music_app/controller/navigation_provider.dart';
import 'package:emotion_music_app/controller/song_provider.dart';
import 'package:emotion_music_app/model/song_model.dart';
import 'package:emotion_music_app/services/auth_exception.dart';
import 'package:emotion_music_app/services/firebase_auth_service.dart';
import 'package:emotion_music_app/ui/screens/auth/login_screen.dart';
import 'package:emotion_music_app/ui/widgets/confirm_alert_dialogue.dart';
import 'package:emotion_music_app/ui/widgets/mood_detection_button.dart';
import 'package:emotion_music_app/ui/widgets/snack_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmotionDetectionHomeScreen extends StatefulWidget {
  const EmotionDetectionHomeScreen({super.key});

  @override
  State<EmotionDetectionHomeScreen> createState() =>
      _EmotionDetectionHomeScreenState();
}

class _EmotionDetectionHomeScreenState
    extends State<EmotionDetectionHomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SongProvider>(
        context,
        listen: false,
      ).setMoodAndFetch("happy");
    });
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
    final songProvider = context.watch<SongProvider>();
    final currentSongs = songProvider.songs;

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

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Mood Songs List (${songProvider.currentMood.toUpperCase()})",

              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child:
                songProvider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : currentSongs.isEmpty
                    ? const Center(
                      child: Text(
                        "No songs found for this mood",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                    : ListView.builder(
                      itemCount: songProvider.songs.length,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemBuilder: (context, index) {
                        final SongModel song = currentSongs[index];

                        return _buildPlaylistCard(song, currentSongs, index);
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaylistCard(
    SongModel songs,
    List<SongModel> currentSongs,
    int index,
  ) {
    return Card(
      color: Colors.grey[850],

      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),

      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            songs.coverpage,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          songs.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          songs.artist,
          style: const TextStyle(color: Colors.white70),
        ),

        trailing: const Icon(Icons.play_arrow, color: Colors.white),
        onTap: () {
          context.read<CurrentTrackNotifier>().setPlayList(currentSongs, index);
          context.read<NavigationProvider>().setSelectedIndex(1);
        },
      ),
    );
  }
}
