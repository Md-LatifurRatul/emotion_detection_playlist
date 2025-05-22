import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

class SpotifyService {
  static Future<bool> connectToSpotify({
    required String clientId,
    required String redirectUrl,
  }) async {
    try {
      return await SpotifySdk.connectToSpotifyRemote(
        clientId: clientId,
        redirectUrl: redirectUrl,
        scope:
            'app-remote-control,user-modify-playback-state,user-read-playback-state,streaming',
      );
    } catch (e) {
      print("Error connecting to Spotify: $e");
      return false;
    }
  }

  static Future<void> play(String spotifyUri) async {
    try {
      await SpotifySdk.play(spotifyUri: spotifyUri);
    } catch (e) {
      print("Play error: $e");
    }
  }

  static Future<PlayerState?> getPlayerState() async {
    try {
      return await SpotifySdk.getPlayerState();
    } catch (e) {
      print("Playerstater error: $e");
      return null;
    }
  }
}
