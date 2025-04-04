import 'package:flutter/material.dart';

class PinCodeScreen extends StatefulWidget {
  final String userId;
  const PinCodeScreen({super.key, required this.userId});
  @override
  _PinCodeScreenState createState() => _PinCodeScreenState();
}

class _PinCodeScreenState extends State<PinCodeScreen> {
  String pin = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context), // Go back to the 2FA screen
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
            Image.asset('assets/images/logo82.png', height: 60), // Logo
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Image.asset('assets/images/multisport.png',
                  height: 150), // Illustration
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
                // Pin circle
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  width: pin.length > index
                      ? 20
                      : 12, // Small circle when empty, bigger when filled
                  height: pin.length > index ? 20 : 12,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: pin.length > index
                        ? Colors.black
                        : Colors.grey, // Black when filled, grey when empty
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PinCodeScreen(userId: widget.userId)));
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

  // Number Pad widget
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

  // Each Button in the Number Pad
  Widget _buildNumberButton(String digit) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (digit == "⌫" && pin.isNotEmpty) {
            pin = pin.substring(0, pin.length - 1); // Backspace
          } else if (digit != "⌫" && pin.length < 4) {
            pin += digit; // Add digit to PIN
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
