import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heavenly/miscellaneous/loading_image.dart';

final storageRef = FirebaseStorage.instance.ref();

class DisplayCard extends StatefulWidget {
  const DisplayCard({
    Key? key,
    required this.cardImage,
    required this.cardTitle,
    required this.cardSubTitle,
  }) : super(key: key);

  final String cardImage;
  final String cardTitle;
  final String cardSubTitle;

  @override
  State<DisplayCard> createState() => _DisplayCardState();
}

class _DisplayCardState extends State<DisplayCard> {
  String imageURL = loadingImage;

  @override
  void initState() {
    storageRef.child(widget.cardImage).getDownloadURL().then((value) {
      setState(() {
        imageURL = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              widget.cardTitle,
              style: GoogleFonts.montserrat(
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Text(
              widget.cardSubTitle,
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
