import 'package:flutter/material.dart';
import 'package:kopiradar/auth/login.dart';
import 'package:kopiradar/auth/signup.dart';
import 'package:kopiradar/pages/home_page.dart';
import 'package:kopiradar/pages/splashscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kopiradar/services/internet_checker.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:kopiradar/providers/user_provider.dart';
import 'package:kopiradar/pages/no_internet_page.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
      child: InternetChecker( 
        child: const MainApp(),
      ),
    ),
  );
}


class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const Splashscreen(),
        '/login': (context) => const Login(),
        '/signup': (context) => const Signup(),
        '/home': (context) => const HomePage(),
        '/no-internet': (context) => const NoInternetPage(),
      },
    );
  }
}
