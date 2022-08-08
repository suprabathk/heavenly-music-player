import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as cf;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism_widgets/glassmorphism_widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heavenly/components/page_header.dart';
import 'package:heavenly/miscellaneous/loading_image.dart';
import 'package:heavenly/screens/pages/saved_page.dart';
import 'package:lottie/lottie.dart';

final storageRef = FirebaseStorage.instance.ref();
final firestore = cf.FirebaseFirestore.instance;

class SoundPlayer extends StatefulWidget {
  const SoundPlayer({
    Key? key,
    required this.soundID,
  }) : super(key: key);

  final String soundID;

  @override
  State<SoundPlayer> createState() => _SoundPlayerState();
}

class _SoundPlayerState extends State<SoundPlayer> {
  String imageURL = loadingImage;

  String imageFile = 'loading';
  String soundTitle = 'loading';
  String soundFile = 'loading';

  Future<void> getSoundData() async {
    await firestore
        .collection('Sounds')
        .doc(widget.soundID)
        .get()
        .then((value) {
      setState(() {
        imageFile = value.data()!['image'];
        soundTitle = value.data()!['title'];
        soundFile = value.data()!['file_name'];
      });
    });
    await storageRef.child('Images/$imageFile').getDownloadURL().then((value) {
      setState(() {
        imageURL = value;
      });
    });
    return;
  }

  @override
  void initState() {
    getSoundData();
    super.initState();
  }

  void _showToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Added to saved'),
        action: SnackBarAction(
            label: 'Hide', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fitHeight,
                image: NetworkImage(imageURL),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const GlassContainer(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _showToast(context);
                          if (!savedUserSounds.contains(widget.soundID)) {
                            savedUserSounds.add(widget.soundID);
                            firestore
                                .collection('saved')
                                .doc(loggedIn.uid)
                                .set({'saved_sounds': savedUserSounds});
                          }
                        },
                        child: const GlassContainer(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.bookmark_border_rounded,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                GlassContainer(
                  width: double.infinity,
                  margin:
                      const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
                  child: SoundPlayerControls(
                    title: soundTitle,
                    fileName: 'Music/$soundFile',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SoundPlayerControls extends StatefulWidget {
  const SoundPlayerControls(
      {Key? key, required this.title, required this.fileName})
      : super(key: key);
  final String title;
  final String fileName;

  @override
  State<SoundPlayerControls> createState() => _SoundPlayerControlsState();
}

class _SoundPlayerControlsState extends State<SoundPlayerControls> {
  late AudioPlayer player;
  Duration duration = const Duration();
  Duration position = const Duration();
  bool fileSource = false;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();

    //automatically set duration
    player.onDurationChanged.listen((Duration d) {
      setState(() => duration = d);
    });
    //automatically set position
    player.onPositionChanged.listen((Duration d) {
      setState(() => position = d);
    });
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  Future<void> getPlayer() async {
    await storageRef.child(widget.fileName).getDownloadURL().then((value) {
      fileSource = true;
      player.setSource(UrlSource(value));
    });
    return;
  }

  void playToggle() async {
    isPlaying ? await player.pause() : await player.resume();
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: GoogleFonts.montserrat(
              textStyle: const TextStyle(
                  fontSize: 50,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
          FutureBuilder(
            future: getPlayer(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (duration.inSeconds != 0) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.fast_rewind_rounded,
                          color: Colors.white,
                          size: 80,
                        ),
                        GestureDetector(
                          onTap: playToggle,
                          child: Icon(
                            isPlaying
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 120,
                          ),
                        ),
                        const Icon(
                          Icons.fast_forward_rounded,
                          color: Colors.white,
                          size: 80,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${position.inSeconds.toDouble()}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 15),
                        ),
                        Slider(
                          thumbColor: Colors.white,
                          activeColor: Colors.teal,
                          inactiveColor: Colors.white12,
                          value: position.inSeconds.toDouble(),
                          max: duration.inSeconds.toDouble(),
                          onChangeEnd: (double value) {
                            setState(() {
                              Duration d = Duration(seconds: value.toInt());
                              player.seek(d);
                              position = d;
                            });
                          },
                          onChanged: (double value) {},
                        ),
                        Text(
                          '${duration.inSeconds}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 15),
                        ),
                      ],
                    ),
                  ],
                );
              } else {
                return Lottie.asset('assets/animations/loading.json');
              }
            },
          ),
        ],
      ),
    );
  }
}
