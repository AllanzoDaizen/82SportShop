import 'package:flutter/material.dart';
import 'package:sportshop/home.dart';

class FingerprintAuthScreen extends StatefulWidget {
  final String userId;
  const FingerprintAuthScreen({super.key, required this.userId});
  @override
  _FingerprintAuthScreenState createState() => _FingerprintAuthScreenState();
}

class _FingerprintAuthScreenState extends State<FingerprintAuthScreen> {
  bool isScanning = false;
  bool isScanComplete = false;
  bool isError = false;
  String statusMessage = "Place your finger on the scanner to continue.";

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
              Image.asset('assets/images/logo82.png', height: 60), // Logo
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Image.asset('assets/images/multisport.png',
                    height: 150), // Illustration
              ),
              Text(
                "Fingerprint Authentication",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isError ? Colors.red : Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                statusMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: isError ? Colors.red : Colors.grey,
                ),
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () => _startScanning(),
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isScanning
                        ? Colors.green
                        : isError
                            ? Colors.red[100]
                            : Colors.grey[300],
                  ),
                  child: Icon(
                    Icons.fingerprint,
                    size: 60,
                    color: isError ? Colors.red : Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isScanComplete
                    ? () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Homepage(userId: widget.userId)));
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isScanComplete ? Colors.black : Colors.grey,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "CONFIRM",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              if (isError)
                TextButton(
                  onPressed: _retryScan,
                  child: const Text(
                    "Try Again",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _startScanning() async {
    if (isScanning) return;

    setState(() {
      isScanning = true;
      isScanComplete = false;
      isError = false;
      statusMessage = "Scanning your fingerprint...";
    });

    // Simulate fingerprint scanning process
    await Future.delayed(const Duration(seconds: 2));

    // Randomly simulate success or failure for demo purposes
    final isSuccess =
        true; // In real app, this would come from actual scan result

    setState(() {
      isScanning = false;
      if (isSuccess) {
        isScanComplete = true;
        statusMessage = "Fingerprint verified successfully!";
      }
    });
  }

  void _retryScan() {
    setState(() {
      isError = false;
      statusMessage = "Place your finger on the scanner to continue.";
    });
  }
}
