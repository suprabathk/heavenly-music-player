import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heavenly/components/page_header.dart';
import 'package:heavenly/components/private_collection.dart';
import 'package:heavenly/screens/pages/saved_page.dart';
import 'package:lottie/lottie.dart';

final firestore = FirebaseFirestore.instance;
final storageRef = FirebaseStorage.instance.ref();

class AddSoundCollection extends StatefulWidget {
  const AddSoundCollection({Key? key}) : super(key: key);

  @override
  State<AddSoundCollection> createState() => _AddSoundCollectionState();
}

class _AddSoundCollectionState extends State<AddSoundCollection> {
  late PlatformFile imageFile;
  late PlatformFile soundFile;
  late UploadTask uploadTask;
  bool showLoading = false;

  Future<void> uploadFile(String storagePath, PlatformFile storageFile) async {
    setState(() {
      showLoading = true;
    });
    final file = File(storageFile.path!);
    uploadTask = storageRef.child(storagePath).putFile(file);
    await uploadTask.whenComplete(() {});
  }

  Future<void> pickImageFile() async {
    FilePickerResult? pickedImageFile =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (pickedImageFile != null) {
      setState(() {
        imageFile = pickedImageFile.files.first;
        selectedImageName = imageFile.name;
      });
    }
  }

  Future<void> pickSoundFile() async {
    FilePickerResult? pickedSoundFile =
        await FilePicker.platform.pickFiles(type: FileType.audio);
    if (pickedSoundFile != null) {
      setState(() {
        soundFile = pickedSoundFile.files.first;
        selectedSoundName = soundFile.name;
      });
    }
  }

  void pushData() {
    firestore.collection('Sounds').add({
      'title': selectedName,
      'description': selectedDescription,
      'image': '${loggedIn.uid}/${imageFile.name}',
      'file_name': '${loggedIn.uid}/${soundFile.name}',
    }).then((doc) {
      privateCollection.add(doc.id);
      firestore.collection('saved').doc(loggedIn.uid).set({
        'private_collection': privateCollection,
        'saved_sounds': savedUserSounds
      });
    });
  }

  String selectedName = '';
  String selectedDescription = '';
  String selectedImageName = '';
  String selectedSoundName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: ListView(
                children: [
                  SizedBox(width: MediaQuery.of(context).size.width),
                  const Center(
                    child: PageHeader(
                      title: 'Add to your collection',
                      requireUserDetails: false,
                    ),
                  ),
                  Text(
                    'Sounds added to your collection can be viewed and played only by you',
                    style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Sound name',
                    style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 30,
                      ),
                    ),
                  ),
                  SizedBox(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Enter sound name',
                        labelText: 'Name',
                        labelStyle: TextStyle(color: Colors.teal.shade700),
                        border: const OutlineInputBorder(),
                        focusedBorder: const OutlineInputBorder(),
                      ),
                      onChanged: (String sound) {
                        setState(() {
                          selectedName = sound;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Sound description',
                    style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 30,
                      ),
                    ),
                  ),
                  SizedBox(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Enter sound description',
                        labelText: 'Description',
                        labelStyle: TextStyle(color: Colors.teal.shade700),
                        border: const OutlineInputBorder(),
                        focusedBorder: const OutlineInputBorder(),
                      ),
                      onChanged: (String sound) {
                        setState(() {
                          selectedDescription = sound;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Sound image',
                    style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 30,
                      ),
                    ),
                  ),
                  Text(selectedImageName),
                  OutlinedButton(
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.teal)),
                    onPressed: () async {
                      await pickImageFile();
                    },
                    child: const Text('Select a cover image'),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Sound source',
                    style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 30,
                      ),
                    ),
                  ),
                  Text(selectedSoundName),
                  OutlinedButton(
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.teal)),
                    onPressed: () async {
                      await pickSoundFile();
                    },
                    child: const Text('Select the sound file'),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
          showLoading
              ? Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Colors.white,
                  child: Center(
                      child: Lottie.asset('assets/animations/loading.json')),
                )
              : Container(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () async {
          pushData();
          await uploadFile(
              'Images/${loggedIn.uid}/${imageFile.name}', imageFile);
          await uploadFile(
              'Music/${loggedIn.uid}/${soundFile.name}', soundFile);
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
        },
        child: const Icon(Icons.done_outline_rounded),
      ),
    );
  }
}
