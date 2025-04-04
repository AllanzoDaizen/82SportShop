import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:sportshop/home.dart';

class TwoFactorAuthScreen extends StatefulWidget {
  final String userId;
  const TwoFactorAuthScreen({required this.userId});
  @override
  _TwoFactorAuthScreenState createState() => _TwoFactorAuthScreenState();
}

class _TwoFactorAuthScreenState extends State<TwoFactorAuthScreen> {
  String? selectedMethod;

  // Initialize all values to 0 (not selected)
  final _isfinger = TextEditingController(text: '0');
  final _isfaceid = TextEditingController(text: '0');
  final _ispin = TextEditingController(text: '0');

  Future<void> _sendData() async {
    try {
      final response = await http.put(
        // Using PUT to update existing user
        Uri.parse(
            'https://67ee47bdc11d5ff4bf790013.mockapi.io/info/${widget.userId}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'isfinger': _isfinger.text,
          'isfaceid': _isfaceid.text,
          'ispin': _ispin.text
        }),
      );
      print('Data sent successfully');
    } catch (e) {
      print("Error sending data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo82.png', height: 60),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Image.asset('assets/images/multisport.png', height: 150),
            ),
            Text(
              "Set Up 2-Factor Authentication",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Secure your account with Two-Factor Authentication.\nChoose a method below.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            SizedBox(height: 30),
            _buildOption(context, "PIN", Icons.pin, "Set Up PIN Code",
                PinScreen(
              onConfirmed: () {
                setState(() {
                  _ispin.text = '1'; // Set PIN to 1 when confirmed
                  _isfaceid.text = '0';
                  _isfinger.text = '0';
                });
                _sendData();
              },
            )),
            _buildOption(context, "FaceID", Icons.face, "Set Up FaceID",
                FaceIDScreen(
              onConfirmed: () {
                setState(() {
                  _isfaceid.text = '1'; // Set FaceID to 1 when confirmed
                  _ispin.text = '0';
                  _isfinger.text = '0';
                });
                _sendData();
              },
            )),
            _buildOption(
                context, "Fingerprint", Icons.fingerprint, "Set Up Fingerprint",
                FingerprintScreen(
              onConfirmed: () {
                setState(() {
                  _isfinger.text = '1'; // Set Fingerprint to 1 when confirmed
                  _ispin.text = '0';
                  _isfaceid.text = '0';
                });
                _sendData();
              },
            )),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Homepage(userId: widget.userId)));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: Text("CONTINUE",
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(BuildContext context, String method, IconData icon,
      String text, Widget screen) {
    bool isSelected = selectedMethod == method;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMethod = method;
        });
        Future.delayed(Duration(milliseconds: 100), () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(10),
          color: isSelected ? Colors.black.withOpacity(0.1) : Colors.white,
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.black),
            SizedBox(width: 10),
            Expanded(
              child: Text(text,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            ),
            if (isSelected) Icon(Icons.check, color: Colors.black),
          ],
        ),
      ),
    );
  }
}

class PinScreen extends StatefulWidget {
  final VoidCallback onConfirmed;

  const PinScreen({required this.onConfirmed});

  @override
  _PinScreenState createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  String pin = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Image.asset('assets/images/multisport.png', height: 100),
            ),
            Text(
              "Set Your 4-Digit PIN",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Please enter your 4-digit PIN to continue.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  width: pin.length > index ? 20 : 12,
                  height: pin.length > index ? 20 : 12,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: pin.length > index ? Colors.black : Colors.grey,
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),
            SizedBox(height: 20),
            _buildNumberPad(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: pin.length == 4
                  ? () {
                      widget.onConfirmed(); // Call the confirmation callback
                      Navigator.pop(context); // Return to previous screen
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: Text("CONFIRM",
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberPad() {
    return Column(
      children: [
        for (var row in [
          ["1", "2", "3"],
          ["4", "5", "6"],
          ["7", "8", "9"],
          ["", "0", "⌫"]
        ])
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: row.map((digit) {
              return _buildNumberButton(digit);
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildNumberButton(String digit) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (digit == "⌫" && pin.isNotEmpty) {
            pin = pin.substring(0, pin.length - 1);
          } else if (digit != "⌫" && digit != "" && pin.length < 4) {
            pin += digit;
          }
        });
      },
      child: Container(
        margin: EdgeInsets.all(8),
        width: 70,
        height: 70,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black, width: 1),
        ),
        child: Text(
          digit,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class FaceIDScreen extends StatefulWidget {
  final VoidCallback onConfirmed;

  const FaceIDScreen({required this.onConfirmed});

  @override
  _FaceIDScreenState createState() => _FaceIDScreenState();
}

class _FaceIDScreenState extends State<FaceIDScreen> {
  bool isScanning = false;
  bool isScanComplete = false;

  void startFaceIDScan() {
    if (isScanning || isScanComplete) return;

    setState(() {
      isScanning = true;
      isScanComplete = false;
    });

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
              Image.asset('assets/images/logo82.png', height: 50),
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
              GestureDetector(
                onTap: startFaceIDScan,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isScanning ? Colors.green : Colors.grey[300],
                  ),
                  child: isScanComplete
                      ? const Icon(
                          Icons.check_circle_rounded,
                          size: 60,
                          color: Colors.green,
                        )
                      : Image.network(
                          'https://cdn-icons-png.flaticon.com/128/5371/5371797.png',
                          height: 60,
                          width: 60,
                        ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isScanComplete
                    ? () {
                        widget.onConfirmed(); // First call the callback
                        Future.delayed(Duration.zero, () {
                          Navigator.pop(
                              context); // Then pop after the callback is complete
                        });
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text(
                  "CONFIRM",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              const SizedBox(height: 24),
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

class FingerprintScreen extends StatefulWidget {
  final VoidCallback onConfirmed;

  const FingerprintScreen({required this.onConfirmed});

  @override
  _FingerprintScreenState createState() => _FingerprintScreenState();
}

class _FingerprintScreenState extends State<FingerprintScreen> {
  bool isScanning = false;
  bool isScanComplete = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
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
              SizedBox(height: 40),
              Image.asset('assets/images/logo82.png', height: 60),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Image.asset('assets/images/multisport.png', height: 150),
              ),
              Text(
                "Fingerprint Authentication",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "Place your finger on the scanner to continue.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isScanning = true;
                    isScanComplete = false;
                  });
                  Future.delayed(Duration(seconds: 3), () {
                    setState(() {
                      isScanning = false;
                      isScanComplete = true;
                    });
                  });
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isScanning ? Colors.green : Colors.grey[300],
                  ),
                  child: Icon(
                    Icons.fingerprint,
                    size: 60,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: isScanComplete
                    ? () {
                        widget.onConfirmed(); // Call the confirmation callback
                        Navigator.pop(context); // Return to previous screen
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: Text("CONFIRM",
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
