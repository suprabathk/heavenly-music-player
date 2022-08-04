import 'package:auth_buttons/auth_buttons.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'registration_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../miscellaneous/rounded_button.dart';
import '../miscellaneous/constants.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';

  const LoginScreen({Key? key}) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final googleSignIn = GoogleSignIn();
  late GoogleSignInAccount _user;
  GoogleSignInAccount get user => _user;
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  String email = "";
  String password = "";
  String msg = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: SafeArea(
              child: ListView(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 25),
                        child: AutoSizeText(
                          'Welcome onboard!',
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
                          'Listen and chill,',
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
                        padding: EdgeInsets.only(
                          top: 15,
                          bottom: MediaQuery.of(context).size.height * 0.03,
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
                    ],
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
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Enter your email',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  TextField(
                      style: const TextStyle(color: Colors.black),
                      obscureText: true,
                      onChanged: (value) {
                        password = value;
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

                        await FirebaseAuth.instance
                            .signInWithCredential(credential);
                        Navigator.pushNamed(context, 'home');
                      },
                      style: const AuthButtonStyle(
                          iconType: AuthIconType.secondary),
                    ),
                  ),
                  Text(msg),
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Don’t have an account ?',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, RegistrationScreen.id);
                          },
                          child: const Text(
                            'Register',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                  RoundButton(
                    key: const Key('null'),
                    color: Colors.white,
                    text: 'Sign in',
                    onpress: () async {
                      print(email + " " + password);
                      try {
                        setState(() {
                          showSpinner = true;
                        });

                        await _auth.signInWithEmailAndPassword(
                            email: email, password: password);
                        Navigator.pushNamed(context, 'home');
                        setState(() {
                          showSpinner = false;
                        });
                      } catch (e) {
                        setState(() {
                          msg = e.toString();
                        });
                        ;
                        print(e);
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
