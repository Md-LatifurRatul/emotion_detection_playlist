import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class CurrentTrackNotifier extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();

  Map<String, String>? _track;
  Map<String, String>? get track => _track;
  AudioPlayer get player => _player;

  CurrentTrackNotifier() {
    _initAudioSession();
  }

  Future<void> _initAudioSession() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());
  }

  Future<void> playTrack(Map<String, String> newTrack) async {
    _track = newTrack;
    notifyListeners();
    final url = newTrack['preview_url']!;
    await _player.setUrl(url);
    _player.play();
  }

  void pause() {
    _player.pause();
    notifyListeners();
  }

  void resume() {
    _player.play();
    notifyListeners();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
