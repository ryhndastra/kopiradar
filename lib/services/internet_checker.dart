import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:kopiradar/pages/no_internet_page.dart';
import 'package:kopiradar/main.dart'; // untuk akses navigatorKey

class InternetChecker extends StatefulWidget {
  final Widget child;

  const InternetChecker({super.key, required this.child});

  @override
  State<InternetChecker> createState() => _InternetCheckerState();
}

class _InternetCheckerState extends State<InternetChecker> {
  late StreamSubscription<ConnectivityResult> _subscription;
  bool isConnected = true;

  @override
  void initState() {
    super.initState();
    _checkInitialConnection();
    _subscription = Connectivity().onConnectivityChanged.listen(_onConnectionChange);
  }

  void _checkInitialConnection() async {
    final result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      _redirectToNoInternet();
    }
  }

  void _onConnectionChange(ConnectivityResult result) {
    final connected = result != ConnectivityResult.none;

    if (!connected && isConnected) {
      _redirectToNoInternet();
    } else if (connected && !isConnected) {
      navigatorKey.currentState?.popUntil((route) => route.isFirst);
    }

    isConnected = connected;
  }

  void _redirectToNoInternet() {
    isConnected = false;
    navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (_) => const NoInternetPage()),
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
