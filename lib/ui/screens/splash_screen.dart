import 'dart:async';

import 'package:emotion_music_app/controller/services/firebase_auth_service.dart';
import 'package:emotion_music_app/ui/screens/auth/login_screen.dart';
import 'package:emotion_music_app/ui/screens/main_bottom_nav_bar_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  Color backgroundColor = Colors.blue.shade400;
  final List<Color> _colors = [
    Colors.blue.shade400,
    Colors.purple.shade700,
    Colors.cyan.shade600,
  ];

  final int _colorIndex = 0;

  late AnimationController _animationController;
  late Animation<double> _iconScaleAnimation;

  final authService = FirebaseAuthService();
  StreamSubscription<User?>? _authSubscription;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);

    _iconScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(_animationController);

    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        backgroundColor = _colors[(_colorIndex + 1) % _colors.length];
      });
      _proccedToNextScreen();
    });
  }

  void _proccedToNextScreen() {
    _authSubscription = authService.authStateChanges().listen((User? user) {
      if (mounted) {
        if (user == null) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
          );
        } else {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const MainBottomNavBarScreen(),
            ),
            (route) => false,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _iconScaleAnimation,
              child: Icon(Icons.equalizer, size: 100, color: Colors.white),
            ),

            Text(
              "Emotion Music",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _authSubscription?.cancel();
    super.dispose();
  }
}
