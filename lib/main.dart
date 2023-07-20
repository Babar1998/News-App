import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:news_app/bottom_navigation_bar.dart';
import 'package:news_app/features/home/screens/home_page.dart';
import 'package:news_app/features/home/screens/news_detail.dart';
import 'package:news_app/firebase_options.dart';
import 'package:news_app/splash_screen.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   runApp(const MyApp());
// }
void main() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MaterialApp(
    builder: (context, child) {
      return Directionality(textDirection: TextDirection.ltr, child: child!);
    },
    debugShowCheckedModeBanner: false,
    title: '5Min News',
    theme: ThemeData(
      primaryColor: Colors.white,
    ),
    home: SplashScreen(),
    routes: {'BottomNavigation': (context) => BottomNavigation()},
  ));
}
