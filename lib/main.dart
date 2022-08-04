import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:heavenly/screens/add_sound.dart';
import 'package:heavenly/screens/home_screen.dart';
import 'package:heavenly/screens/login_screen.dart';
import 'package:heavenly/screens/registration_screen.dart';
import 'package:heavenly/screens/splash_screen.dart';

import 'firebase_options.dart';

bool isSignedIn = false;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user != null) {
      isSignedIn = true;
    }
  });

  runApp(const Heavenly());
}

class Heavenly extends StatelessWidget {
  const Heavenly({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: Colors.transparent),
      child: MaterialApp(
        theme: ThemeData.light().copyWith(
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarIconBrightness: Brightness.dark,
                statusBarColor: Colors.transparent),
          ),
          scaffoldBackgroundColor: Colors.white,
        ),
        routes: {
          'welcome': (context) => const WelcomeScreen(),
          'home': (context) => const HomePage(),
          'add_sound': (context) => const AddSound(),
          'login_screen': (context) => const LoginScreen(),
          RegistrationScreen.id: (context) => const RegistrationScreen()
        },
        initialRoute: 'welcome',
      ),
    );
  }
}
