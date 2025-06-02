import 'package:audio_session/audio_session.dart';
import 'package:emotion_music_app/model/song_model.dart';
import 'package:emotion_music_app/services/supbase_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class MusicPlayerScreen extends StatefulWidget {
  const MusicPlayerScreen({super.key, this.track});
  final Map<String, String>? track;

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _imageAnimation;
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;
  int _currentIndex = 0;
  List<SongModel> _songsList = [];

  @override
  void initState() {
    super.initState();
    // _initAudio();
    // _loadSongs();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _audioPlayer = AudioPlayer();

    _imageAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _animationController.repeat(reverse: true);
  }

  final List<Map<String, String>> _songs = [
    {
      "title": "Chill Vibes",
      "artist": "Warfaze",

      "url":
          "https://www.music.com.bd/download/Music/W/Warfaze/Shotto/04.%20Warfaze%20-%20Purnota%20(music.com.bd).mp3",

      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRI6oe0i5K8vjoaCdABY5I9uJffX2M1NIkSQA&s",
    },

    {
      "title": "Mood Booster",
      "artist": "Artcell",

      "url":
          "https://music.com.bd/download/Music/A/Artcell/Oniket%20Prantor/Artcell%20-%20Oniket%20Prantor%20(music.com.bd).mp3",

      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRI6oe0i5K8vjoaCdABY5I9uJffX2M1NIkSQA&s",
    },

    {
      "title": "Chill Vibes",
      "artist": "Warfaze",

      "url":
          "https://www.music.com.bd/download/Music/W/Warfaze/Shotto/04.%20Warfaze%20-%20Purnota%20(music.com.bd).mp3",

      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRI6oe0i5K8vjoaCdABY5I9uJffX2M1NIkSQA&s",
    },
  ];

  Future<void> _initAudio() async {
    _audioPlayer = AudioPlayer();

    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());

    try {
      await _audioPlayer.setUrl(_songs[_currentIndex]["url"]!);
    } catch (e) {
      print("Error loading audio: $e");
    }
  }

  Future<void> _loadSongs() async {
    final songs = await SupbaseService().fetchSongsByMood('happy');
    // print(songs);
    setState(() {
      _songsList = songs;
    });
  }

  void _playPause() {
    if (_audioPlayer.playing) {
      _audioPlayer.pause();
      _animationController.stop();
      setState(() {
        isPlaying = false;
      });
    } else {
      _audioPlayer.play();
      _animationController.repeat();
      setState(() {
        isPlaying = true;
      });
    }
  }

  void _playNext() {
    if (_currentIndex < _songs.length - 1) {
      _currentIndex++;
      _loadAndPlay();
    } else {
      _currentIndex = 0;
      _loadAndPlay();
    }
  }

  void _playPrevious() {
    if (_currentIndex > 0) {
      _currentIndex--;
      _loadAndPlay();
    }
  }

  Future<void> _loadAndPlay() async {
    await _audioPlayer.setUrl(_songs[_currentIndex]['url']!);
    _audioPlayer.play();
    setState(() {
      isPlaying = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Now Playing", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ScaleTransition(
              scale: _imageAnimation,

              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: NetworkImage(_songs[_currentIndex]['image']!),
                    fit: BoxFit.cover,
                  ),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.white12,
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 30),

            Text(
              _songs[_currentIndex]['title']!,
              style: TextStyle(
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              _songs[_currentIndex]['artist']!,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 20),

            StreamBuilder<Duration>(
              stream: _audioPlayer.positionStream,
              builder: (context, snapshot) {
                final position = snapshot.data ?? Duration.zero;

                final total = _audioPlayer.duration ?? Duration.zero;
                final totalSeconds =
                    total.inSeconds > 0 ? total.inSeconds.toDouble() : 1.0;
                final positionSeconds =
                    position.inSeconds.clamp(0, total.inSeconds).toDouble();

                return Slider(
                  min: 0.0,
                  value: positionSeconds,
                  max: totalSeconds,

                  onChanged: (value) {
                    _audioPlayer.seek(Duration(seconds: value.toInt()));
                  },
                  activeColor: Colors.blueAccent,
                  inactiveColor: Colors.white24,
                );
              },
            ),

            // Slider(
            //   value: 0.5,
            //   onChanged: (value) {},
            //   activeColor: Colors.white,
            //   inactiveColor: Colors.grey,
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.skip_previous, color: Colors.white),
                  iconSize: 36,
                  onPressed: _playPrevious,
                ),
                const SizedBox(width: 10),

                ElevatedButton(
                  onPressed: () {
                    _playPause();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.all(18),
                  ),

                  child: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.skip_next, color: Colors.white),
                  color: Colors.white,
                  iconSize: 36,
                  onPressed: _playNext,
                ),
              ],
            ),
            SizedBox(height: 10),

            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListView(
                  children: [
                    Text(
                      'Lyrics Line 1',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Text(
                      "Lyrics Line 2",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Text(
                      "Lyrics Line 3",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.chat),
        onPressed: () {},
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }
}
