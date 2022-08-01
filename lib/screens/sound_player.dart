import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';

final storageRef = FirebaseStorage.instance.ref();

class SoundPlayer extends StatelessWidget {
  const SoundPlayer(
      {Key? key,
      required this.title,
      required this.image,
      required this.fileName})
      : super(key: key);

  final String title;
  final String image;
  final String fileName;

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
                image: NetworkImage(image),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: GlassmorphicContainer(
                        margin: const EdgeInsets.all(20),
                        blur: 20,
                        height: 50,
                        width: 50,
                        border: 2,
                        borderRadius: 20,
                        borderGradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFFffffff).withOpacity(0.5),
                            const Color(0xFFFFFFFF).withOpacity(0.5),
                          ],
                        ),
                        linearGradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFFffffff).withOpacity(0.1),
                            const Color(0xFFFFFFFF).withOpacity(0.05),
                          ],
                          stops: const [
                            0.1,
                            1,
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    GlassmorphicContainer(
                      margin: const EdgeInsets.all(20),
                      blur: 20,
                      height: 50,
                      width: 50,
                      border: 2,
                      borderRadius: 20,
                      borderGradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFFffffff).withOpacity(0.5),
                          const Color(0xFFFFFFFF).withOpacity(0.5),
                        ],
                      ),
                      linearGradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFFffffff).withOpacity(0.1),
                          const Color(0xFFFFFFFF).withOpacity(0.05),
                        ],
                        stops: const [
                          0.1,
                          1,
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.bookmark_border_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                GlassmorphicContainer(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 2.3,
                  margin:
                      const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
                  borderRadius: 20,
                  blur: 20,
                  border: 2,
                  linearGradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFFffffff).withOpacity(0.1),
                      const Color(0xFFFFFFFF).withOpacity(0.05),
                    ],
                    stops: const [
                      0.1,
                      1,
                    ],
                  ),
                  borderGradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFFffffff).withOpacity(0.5),
                      const Color(0xFFFFFFFF).withOpacity(0.5),
                    ],
                  ),
                  child: SoundPlayerControls(
                    title: title,
                    fileName: fileName,
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
  late Source fileSource;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
    storageRef.child(widget.fileName).getDownloadURL().then((value) {
      player.setSource(UrlSource(value));
    });

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
                  isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
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
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
              Slider(
                thumbColor: Colors.white,
                activeColor: Colors.teal,
                inactiveColor: Colors.white12,
                value: position.inSeconds.toDouble(),
                max: duration.inSeconds.toDouble(),
                onChanged: (double value) {
                  setState(() {
                    Duration d = Duration(seconds: value.toInt());
                    player.seek(d);
                    position = d;
                  });
                },
              ),
              Text(
                '${duration.inSeconds}',
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
