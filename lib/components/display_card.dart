import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final storageRef = FirebaseStorage.instance.ref();
final firestore = FirebaseFirestore.instance;

class DisplayCard extends StatefulWidget {
  const DisplayCard({
    Key? key,
    required this.soundID,
  }) : super(key: key);

  final String soundID;

  @override
  State<DisplayCard> createState() => _DisplayCardState();
}

class _DisplayCardState extends State<DisplayCard> {
  String imageURL = '';
  String imageFile = '';
  String soundTitle = '';
  String soundDescription = '';

  Future<void> getSoundData() async {
    await firestore
        .collection('Sounds')
        .doc(widget.soundID)
        .get()
        .then((value) {
      imageFile = value.data()!['image'];
      soundTitle = value.data()!['title'];
      soundDescription = value.data()!['description'];
    });
    await storageRef.child('Images/$imageFile').getDownloadURL().then((value) {
      imageURL = value;
    });
    setState(() {});
    return;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getSoundData(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (imageURL != '') {
          return CachedNetworkImage(
            imageUrl: imageURL,
            imageBuilder: (context, imageProvider) => Container(
              width: 130,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(30),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    soundTitle,
                    style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Text(
                    soundDescription,
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            placeholder: (context, url) => Container(
              width: 130,
              padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 80),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          );
        } else {
          return Container(
            width: 130,
            padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 80),
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(30),
            ),
          );
        }
      },
    );
  }
}
