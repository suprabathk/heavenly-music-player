import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:heavenly/components/saved_card.dart';
import '../../components/page_header.dart';

final firestore = FirebaseFirestore.instance;
List savedUserSounds = [];

class SavedPage extends StatefulWidget {
  const SavedPage({Key? key}) : super(key: key);

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  Future<void> getSavedSounds() async {
    await firestore.collection('saved').doc(loggedIn.uid).get().then((value) {
      savedUserSounds = value.get('saved_sounds');
    });
    return;
  }

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
        FutureBuilder(
          future: getSavedSounds(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            return Expanded(
              child: ListView(
                children: List.generate(savedUserSounds.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SavedCard(soundID: savedUserSounds.elementAt(index)),
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
