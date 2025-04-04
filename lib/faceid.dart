import 'package:flutter/material.dart';
import 'dart:async';

import 'package:sportshop/home.dart';

class FaceIDAuthScreen extends StatefulWidget {
    final String userId;
  const FaceIDAuthScreen({super.key, required this.userId});
  @override
  _FaceIDAuthScreenState createState() => _FaceIDAuthScreenState();
}

class _FaceIDAuthScreenState extends State<FaceIDAuthScreen> {
  bool isScanning = false;
  bool isScanComplete = false;

  void startFaceIDScan() {
    if (isScanning || isScanComplete) return;

    setState(() {
      isScanning = true;
      isScanComplete = false;
    });

    // Simulate a 3-second scan before verifying
    Timer(const Duration(seconds: 3), () {
      setState(() {
        isScanning = false;
        isScanComplete = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              // "82" Sports Logo
              Image.asset('assets/images/logo82.png', height: 50),

              // Sports Illustration
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Image.asset('assets/images/multisport.png', height: 150),
              ),

              const Text(
                "Set Up FaceID",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Look directly at your device to enable FaceID authentication.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 30),

              // Face ID Scanner
              GestureDetector(
                onTap: startFaceIDScan,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isScanning
                        ? Colors.green
                        : Colors.grey[300], // Turns green during scanning
                  ),
                  child: isScanComplete
                      ? const Icon(
                    Icons.check_circle_rounded,
                    size: 60,
                    color: Colors.green,
                  ) // ✅ Checkmark after scan
                      : Image.asset(
                    'assets/facial.webp',
                    height: 60,
                    width: 60,
                  ), // 🏞️ Custom FaceID image before scan
                ),
              ),

              const SizedBox(height: 20),

              // Submit Button
              ElevatedButton(
                onPressed: isScanComplete
                    ? () {
                  // Proceed to the next screen after successful FaceID scan
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Homepage(userId: widget.userId)));
                }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text(
                  "CONFIRM",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),

              const SizedBox(height: 24),

              // Security Message
              const Text(
                'FaceID is stored in the security module of this phone\n'
                    'and cannot be obtained by the system or apps.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
