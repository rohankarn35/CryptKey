import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Qrscreen extends StatefulWidget {
  const Qrscreen({super.key});

  @override
  State<Qrscreen> createState() => _QrscreenState();
}

class _QrscreenState extends State<Qrscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: QrImageView(
      data: 'This is a simple code',
      version: QrVersions.auto,
      size: 320,
      gapless: false,
    )));
  }
}
