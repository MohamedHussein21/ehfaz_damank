import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String? scannedData;

  @override
  Widget build(BuildContext context) {
    double scanArea = MediaQuery.of(context).size.width < 400 ? 250.0 : 300.0;

    return Scaffold(
      appBar: AppBar(title: Text("مسح QR Code")),
      body: Stack(
        children: [
          QRView(
            key: qrKey,
            cameraFacing: CameraFacing.back,
            overlay: QrScannerOverlayShape(
              borderColor: Colors.red,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: scanArea,
            ),
            onQRViewCreated: _onQRViewCreated,
          ),
          Center(
            child: scannedData != null
                ? Text('تم المسح: $scannedData', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
                : Text('قم بمسح QR Code', style: TextStyle(fontSize: 18)),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (mounted) {
        setState(() => scannedData = scanData.code);
        controller.pauseCamera();
        Navigator.pop(context, scannedData); 
      }
    });
  }
}
