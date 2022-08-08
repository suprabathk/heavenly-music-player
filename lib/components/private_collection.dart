import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heavenly/components/private_card.dart';
import '../../components/page_header.dart';
import '../screens/sound_player.dart';

final firestore = FirebaseFirestore.instance;
List privateCollection = [];

class PrivateCollection extends StatefulWidget {
  const PrivateCollection({Key? key, required this.showDel}) : super(key: key);
  final bool showDel;

  @override
  State<PrivateCollection> createState() => _PrivateCollectionState();
}

class _PrivateCollectionState extends State<PrivateCollection> {
  @override
  void initState() {
    super.initState();
    getPrivateData();
  }

  Future<void> getPrivateData() async {
    final savedDoc =
        await firestore.collection('saved').doc(loggedIn.uid).get();
    setState(() {
      privateCollection = savedDoc.get('private_collection');
    });
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: double.infinity),
        Text(
          'Your collection',
          style: GoogleFonts.montserrat(
            textStyle:
                const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10),
        StreamBuilder(
          stream: firestore.collection('saved').doc(loggedIn.uid).snapshots(),
          builder: (context, snapshot) {
            return Expanded(
              child: ListView(
                children: List.generate(privateCollection.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SoundPlayer(
                              soundID: privateCollection.elementAt(index),
                            ),
                          ),
                        );
                      },
                      child: PrivateCard(
                          soundID: privateCollection.elementAt(index),
                          showDel: widget.showDel),
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
