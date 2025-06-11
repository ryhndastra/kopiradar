import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kopiradar/auth/login.dart';
import 'package:kopiradar/pages/home_page.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    final user = _auth.currentUser;

    if (user != null) {
      // User sudah login, arahkan ke homepage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      // User belum login, arahkan ke login page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/splash.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Image.asset('assets/images/logo.png', width: 150, height: 150),
        ),
      ),
    );
  }
}
