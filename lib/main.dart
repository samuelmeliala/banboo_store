import 'package:banboo_store/views/page/home/home_page.dart';
import 'package:banboo_store/views/page/profile/profile_page.dart';
import 'package:banboo_store/views/screens/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Banboo Store',
      routes: {
        'home': (context) => const HomePage(),
        'profile': (context) => const ProfilePage()
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}
