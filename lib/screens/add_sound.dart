import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heavenly/components/page_header.dart';
import 'package:lottie/lottie.dart';

final firestore = FirebaseFirestore.instance;
final storageRef = FirebaseStorage.instance.ref();

class AddSound extends StatefulWidget {
  const AddSound({Key? key}) : super(key: key);

  @override
  State<AddSound> createState() => _AddSoundState();
}

class _AddSoundState extends State<AddSound> {
  List<String> categoryNamesList = [];
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

  void pushData(int index) {
    firestore.collection('Sounds').add({
      'title': selectedName,
      'description': selectedDescription,
      'image': '${categoryNamesList.elementAt(index)}/${imageFile.name}',
      'file_name': '${categoryNamesList.elementAt(index)}/${soundFile.name}',
    }).then((doc) {
      firestore
          .collection(categoryNamesList.elementAt(index))
          .add({'sound': doc.id});
    });
  }

  void getTabData() async {
    return await firestore
        .collection('category_names')
        .get()
        .then((QuerySnapshot? querySnapshot) {
      for (var doc in querySnapshot!.docs) {
        setState(() {
          categoryNamesList = List<String>.from(doc['category_names']);
        });
      }
    });
  }

  String selectedCategory = '';
  String selectedName = '';
  String selectedDescription = '';
  String selectedImageName = '';
  String selectedSoundName = '';

  @override
  void initState() {
    getTabData();
    super.initState();
  }

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
                      title: 'Add sound',
                      requireUserDetails: false,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Select category',
                        style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      DropdownButton(
                        style: GoogleFonts.lato(
                            textStyle: const TextStyle(
                                color: Colors.black, fontSize: 20)),
                        borderRadius: BorderRadius.circular(15),
                        underline: Container(),
                        value: selectedCategory.isNotEmpty
                            ? selectedCategory
                            : null,
                        items: List.generate(
                          categoryNamesList.length,
                          (index) => DropdownMenuItem(
                            value: categoryNamesList.elementAt(index),
                            child: Text(categoryNamesList.elementAt(index)),
                          ),
                        ),
                        onChanged: (String? cat) {
                          setState(() {
                            selectedCategory = cat!;
                          });
                        },
                      ),
                    ],
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
          pushData(categoryNamesList.indexOf(selectedCategory));
          await uploadFile(
              'Images/$selectedCategory/${imageFile.name}', imageFile);
          await uploadFile(
              'Music/$selectedCategory/${soundFile.name}', soundFile);
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
        },
        child: const Icon(Icons.done_outline_rounded),
      ),
    );
  }
}
