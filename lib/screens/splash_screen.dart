import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heavenly/main.dart';
import 'package:lottie/lottie.dart';
import 'package:audioplayers/audioplayers.dart';

bool getStatus() {
  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user != null) {
      isSignedIn = true;
    }
  });
  return isSignedIn;
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late AudioPlayer audioPlayer;
  bool signInStatus = getStatus();
  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    audioPlayer.play(AssetSource('welcome_chime.mp3'));
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(
          context, signInStatus ? 'home' : 'login_screen');
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/animations/greenStarLogo.json',
            repeat: false,
          ),
          const Text(
            'Heavenly',
            style: TextStyle(
              fontFamily: 'Cheva',
              fontSize: 50,
            ),
          ),
          Text(
            'Find your vibe',
            style: GoogleFonts.josefinSans(
                textStyle: const TextStyle(fontSize: 20)),
          ),
        ],
      ),
    );
  }
}
