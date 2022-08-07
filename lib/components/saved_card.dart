import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heavenly/miscellaneous/loading_image.dart';

final storageRef = FirebaseStorage.instance.ref();
final firestore = FirebaseFirestore.instance;

class SavedCard extends StatefulWidget {
  const SavedCard({
    Key? key,
    required this.soundID,
  }) : super(key: key);

  final String soundID;

  @override
  State<SavedCard> createState() => _SavedCardState();
}

class _SavedCardState extends State<SavedCard> {
  String imageURL = loadingImage;
  String imageFile = '';
  String soundTitle = '';
  String soundDescription = '';

  Future<void> getSoundData() async {
    await firestore
        .collection('Sounds')
        .doc(widget.soundID)
        .get()
        .then((value) {
      setState(() {
        imageFile = value.data()!['image'];
        soundTitle = value.data()!['title'];
        soundDescription = value.data()!['description'];
      });
    });
    await storageRef.child('Images/$imageFile').getDownloadURL().then((value) {
      setState(() {
        imageURL = value;
      });
    });
  }

  @override
  void initState() {
    getSoundData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageURL,
      imageBuilder: (context, imageProvider) => Container(
        height: 20,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.fitWidth,
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
      placeholder: (context, url) => const Center(
        child:
            SizedBox(width: 20, height: 20, child: CircularProgressIndicator()),
      ),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}
