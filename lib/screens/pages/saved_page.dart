import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:heavenly/components/saved_card.dart';
import '../../components/page_header.dart';
import '../sound_player.dart';

final firestore = FirebaseFirestore.instance;
List savedUserSounds = [];

class SavedPage extends StatefulWidget {
  const SavedPage({Key? key}) : super(key: key);

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const PageHeader(
          title: 'Saved sounds',
          requireSearchBar: true,
          requireUserDetails: true,
        ),
        const SizedBox(height: 10),
        StreamBuilder(
          stream: firestore.collection('saved').doc(loggedIn.uid).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            return Expanded(
              child: ListView(
                children: List.generate(savedUserSounds.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SoundPlayer(
                              soundID: savedUserSounds.elementAt(index),
                            ),
                          ),
                        );
                      },
                      child:
                          SavedCard(soundID: savedUserSounds.elementAt(index)),
                    ),
                  );
                }),
              ),
            );
          },
        ),
      ],
    );
  }
}
