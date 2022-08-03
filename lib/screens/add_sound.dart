import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heavenly/components/page_header.dart';

final firestore = FirebaseFirestore.instance;

class AddSound extends StatefulWidget {
  const AddSound({Key? key}) : super(key: key);

  @override
  State<AddSound> createState() => _AddSoundState();
}

class _AddSoundState extends State<AddSound> {
  List<String> categoryNamesList = [];

  void pushData(int index) {
    firestore.collection('$index').add({
      'title': selectedName,
      'description': selectedDescription,
      'image': selectedImage,
      'file_name': selectedSound,
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
  String selectedImage = '';
  String selectedSound = '';

  @override
  void initState() {
    getTabData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                        textStyle:
                            const TextStyle(color: Colors.black, fontSize: 20)),
                    borderRadius: BorderRadius.circular(15),
                    underline: Container(),
                    value:
                        selectedCategory.isNotEmpty ? selectedCategory : null,
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
                  decoration: const InputDecoration(
                    hintText: 'Enter sound name',
                    labelText: 'Name',
                    border: OutlineInputBorder(),
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
                  decoration: const InputDecoration(
                    hintText: 'Enter sound description',
                    labelText: 'Description',
                    border: OutlineInputBorder(),
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
              SizedBox(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Enter image URL',
                    labelText: 'Image',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (String sound) {
                    setState(() {
                      selectedImage = sound;
                    });
                  },
                ),
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
              SizedBox(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Enter sound URL',
                    labelText: 'Source',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (String sound) {
                    setState(() {
                      selectedSound = sound;
                    });
                  },
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () {
          pushData(categoryNamesList.indexOf(selectedCategory));
          Navigator.pop(context);
        },
        child: const Icon(Icons.done_outline_rounded),
      ),
    );
  }
}
