import 'package:emotion_music_app/core/image_path.dart';
import 'package:flutter/material.dart';

class MusicPlayerScreen extends StatefulWidget {
  const MusicPlayerScreen({super.key});

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _imageAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _imageAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _animationController.repeat(reverse: true);
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
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: NetworkImage(ImagePath.networkMusicImage),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            SizedBox(height: 30),

            Text(
              "Song Title",
              style: TextStyle(
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Artist Name",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 20),
            Slider(
              value: 0.5,
              onChanged: (value) {},
              activeColor: Colors.white,
              inactiveColor: Colors.grey,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.skip_previous, color: Colors.white),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.play_arrow, color: Colors.white, size: 40),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.skip_next, color: Colors.white),
                  onPressed: () {},
                ),
              ],
            ),
            SizedBox(height: 20),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
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
    super.dispose();
  }
}
