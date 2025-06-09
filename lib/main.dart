import 'package:flutter/material.dart';
import 'package:kopiradar/auth/login.dart';
import 'package:kopiradar/auth/signup.dart';
import 'package:kopiradar/pages/home_page.dart';
import 'package:kopiradar/pages/splashscreen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const Splashscreen(),
        '/login': (context) => const Login(),
        '/signup': (context) => const Signup(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}
