import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:heavenly/screens/home_screen.dart';
import 'package:heavenly/screens/splash_screen.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const Heavenly());
}

class Heavenly extends StatelessWidget {
  const Heavenly({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      },
      initialRoute: 'welcome',
    );
  }
}
