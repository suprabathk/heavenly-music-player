import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism_widgets/glassmorphism_widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heavenly/components/private_collection.dart';
import 'package:heavenly/screens/pages/saved_page.dart';
import '../../components/page_header.dart';

final storageRef = FirebaseStorage.instance.ref();
final firestore = FirebaseFirestore.instance;

class PrivateCard extends StatefulWidget {
  const PrivateCard({
    Key? key,
    required this.soundID,
    required this.showDel,
  }) : super(key: key);

  final String soundID;
  final bool showDel;

  @override
  State<PrivateCard> createState() => _PrivateCardState();
}

class _PrivateCardState extends State<PrivateCard> {
  String imageURL = '';
  String imageFile = '';
  String soundFile = '';
  String soundTitle = '';
  String soundDescription = '';

  Future<void> getSoundData() async {
    await firestore
        .collection('Sounds')
        .doc(widget.soundID)
        .get()
        .then((value) {
      imageFile = value.data()!['image'];
      soundFile = value.data()!['file_name'];
      soundTitle = value.data()!['title'];
      soundDescription = value.data()!['description'];
    });
    await storageRef.child('Images/$imageFile').getDownloadURL().then((value) {
      imageURL = value;
    });
    setState(() {});
    return;
  }

  void _showToast(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        backgroundColor: Colors.white,
        content: Text(
          message,
          style: const TextStyle(color: Colors.teal),
        ),
        action: SnackBarAction(
          label: 'Hide',
          onPressed: scaffold.hideCurrentSnackBar,
          textColor: Colors.black,
        ),
      ),
    );
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
              height: 100,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(30),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.fitWidth,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                  widget.showDel
                      ? GestureDetector(
                          onTap: () {
                            _showToast(context,
                                'Long press to delete from collection');
                          },
                          onLongPress: () {
                            _showToast(context, 'Removed from collection');
                            if (savedUserSounds.contains(widget.soundID)) {
                              savedUserSounds.remove(widget.soundID);
                            }
                            if (privateCollection.contains(widget.soundID)) {
                              privateCollection.remove(widget.soundID);
                              firestore
                                  .collection('saved')
                                  .doc(loggedIn.uid)
                                  .set({
                                'private_collection': privateCollection,
                                'saved_sounds': savedUserSounds
                              });
                              firestore
                                  .collection('Sounds')
                                  .doc(widget.soundID)
                                  .delete();
                              storageRef.child('Images/$imageFile').delete();
                              storageRef.child('Music/$soundFile').delete();
                              getSoundData();
                            }
                          },
                          child: const GlassContainer(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.delete_forever_rounded,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                        )
                      : const GlassContainer(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                ],
              ),
            ),
            placeholder: (context, url) => Container(
              height: 100,
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
            height: 100,
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
