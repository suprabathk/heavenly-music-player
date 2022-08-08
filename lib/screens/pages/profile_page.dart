import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../add_sound.dart';

late User loggedIn;
final _auth = FirebaseAuth.instance;

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool creatorMode = false;

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedIn = user;
      }
    } catch (e) {
      // const Text('Error occurred, reload the app!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(loggedIn.photoURL ??
                "https://img.freepik.com/free-psd/3d-illustration-person-with-sunglasses_23-2149436188.jpg?w=826&t=st=1659595648~exp=1659596248~hmac=fb9c6aa3fc01d50840555a50d31a1b099a8469c24b0c01eb1326d1ff8503b8a8"),
            backgroundColor: Colors.black12,
          ),
          const SizedBox(height: 20),
          Text(
            loggedIn.displayName ?? loggedIn.email!,
            style: GoogleFonts.montserrat(
              textStyle:
                  const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 15),
          GestureDetector(
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, 'login_screen');
            },
            child: Text(
              'Sign out',
              style: GoogleFonts.josefinSans(
                textStyle: const TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Divider(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.teal,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddSound()));
        },
        label: const Text('Add your own sounds'),
        icon: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
