import 'package:auth_buttons/auth_buttons.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'login_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../miscellaneous/rounded_button.dart';

import '../miscellaneous/constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = 'registration_screen';

  const RegistrationScreen({Key? key}) : super(key: key);
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final googleSignIn = GoogleSignIn();
  late GoogleSignInAccount _user;
  GoogleSignInAccount get user => _user;
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  String email = '';
  late String password;
  String displayName = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: ListView(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: AutoSizeText(
                      'Register',
                      maxLines: 1,
                      style: GoogleFonts.josefinSans(
                        textStyle: TextStyle(
                          color: Colors.teal.shade700,
                          fontSize: 45,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 15,
                    ),
                    child: AutoSizeText(
                      'Let the journey begin!',
                      textAlign: TextAlign.left,
                      style: GoogleFonts.barlow(
                        textStyle: TextStyle(
                          fontSize: 40,
                          color: Colors.teal.shade700,
                        ),
                      ),
                      maxLines: 2,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 15,
                    ),
                    child: AutoSizeText(
                      email,
                      textAlign: TextAlign.left,
                      style: GoogleFonts.barlow(
                        textStyle: const TextStyle(
                          fontSize: 40,
                          color: Colors.black,
                        ),
                      ),
                      maxLines: 2,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextField(
                      style: const TextStyle(color: Colors.black),
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        setState(() {
                          email = value;
                        });
                      },
                      decoration:
                          kTextFieldDecoration.copyWith(hintText: 'Email'),
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: TextField(
                      style: const TextStyle(color: Colors.black),
                      onChanged: (value) {
                        password = value;
                      },
                      decoration:
                          kTextFieldDecoration.copyWith(hintText: 'Username'),
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  TextField(
                      style: const TextStyle(color: Colors.black),
                      obscureText: true,
                      onChanged: (value) {
                        displayName = value;
                      },
                      decoration:
                          kTextFieldDecoration.copyWith(hintText: 'Password')),
                  const SizedBox(
                    height: 24.0,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Divider(
                      color: Colors.grey,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: GoogleAuthButton(
                      themeMode: ThemeMode.light,
                      onPressed: () async {
                        final googleUser = await googleSignIn.signIn();
                        if (googleUser == null) return;
                        _user = googleUser;

                        final googleAuth = await googleUser.authentication;

                        final credential = GoogleAuthProvider.credential(
                          accessToken: googleAuth.accessToken,
                          idToken: googleAuth.idToken,
                        );

                        final exUser = await FirebaseAuth.instance
                            .signInWithCredential(credential);
                        if (exUser != null) {
                          Navigator.pushNamed(context, 'home');
                        }
                      },
                      style: const AuthButtonStyle(
                          iconType: AuthIconType.secondary),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account?',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, LoginScreen.id);
                          },
                          child: const Text(
                            'Login',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                  RoundButton(
                    key: Key('null'),
                    color: Colors.white,
                    text: 'Register',
                    onpress: () async {
                      try {
                        setState(() {
                          showSpinner = true;
                        });

                        final newUser =
                            await _auth.createUserWithEmailAndPassword(
                                email: email, password: password);

                        if (newUser != null) {
                          Navigator.pushNamed(context, 'home');
                          setState(() {
                            showSpinner = false;
                          });
                        }
                      } catch (e) {
                        //print(e);
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
