import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:kopiradar/main.dart'; // untuk akses navigatorKey

class NoInternetPage extends StatefulWidget {
  const NoInternetPage({super.key});

  @override
  State<NoInternetPage> createState() => _NoInternetPageState();
}

class _NoInternetPageState extends State<NoInternetPage> {
  bool checking = false;

  void _checkAgain() async {
    setState(() => checking = true);
    final result = await Connectivity().checkConnectivity();

    if (result != ConnectivityResult.none) {
      navigatorKey.currentState?.popUntil((route) => route.isFirst);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Masih belum ada koneksi internet")),
      );
    }

    setState(() => checking = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wifi_off, size: 100, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                "Tidak ada koneksi internet",
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: checking ? null : _checkAgain,
                child: checking
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text("Coba Lagi"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
