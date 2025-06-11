import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:kopiradar/pages/success_page.dart';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({super.key});

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool isScanned = false;

  @override
  void reassemble() {
    super.reassemble();
    controller?.pauseCamera();
    controller?.resumeCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (!isScanned) {
        setState(() => isScanned = true);
        controller.pauseCamera();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
                PaymentSuccessPage(result: scanData.code ?? 'QR tidak terbaca'),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: Colors.green,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 8,
              cutOutSize: MediaQuery.of(context).size.width * 0.7,
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Row(
                    children: const [
                      Icon(Icons.arrow_back, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Scan Qris',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
