import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sportshop/faceid.dart';
import 'package:sportshop/fingerprint.dart';
import 'package:sportshop/home.dart';
import 'package:http/http.dart' as http;
import 'package:sportshop/pin_code_screen.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String userId;
  const OTPVerificationScreen({super.key, required this.userId});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  int _remainingTime = 60; // 1 minute in seconds
  Timer? _timer;

  // Controllers and focus nodes for the 4 input fields
  final List<TextEditingController> _otpControllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _otpFocusNodes = List.generate(4, (_) => FocusNode());

  bool _isSubmitEnabled = false;
  bool _isInputBlocked = false;
  bool _isLoading = false;
  String _otpMessage = '';
  String _generatedOTP = '';
  bool _isCodeCorrect = false;
  int _incorrectAttempts = 0;
  bool _isMessageUp = false;
  String _submissionMessage = '';
  Color _submissionMessageColor = Colors.transparent;
  List<dynamic> users = [];
  Map<String, dynamic>? currentUser;

  @override
  void initState() {
    super.initState();
    _isMessageUp = false;
    _generateAndSendOTP();
    _startCountdown();
    _addListenersToControllers();
    fetchData();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _otpFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _generateAndSendOTP() {
    _generatedOTP = (1000 +
            (9999 - 1000) *
                (DateTime.now().millisecondsSinceEpoch % 1000) ~/
                1000)
        .toString();
    setState(() {
      _otpMessage =
          'Your OTP code is $_generatedOTP. Please do not share this code with anyone.';
      _incorrectAttempts = 0;
      _isMessageUp = false;
      _submissionMessage = '';
      _submissionMessageColor = Colors.transparent;
    });

    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _isMessageUp = true;
        });
      }
    });
  }

  void _startCountdown() {
    _isInputBlocked = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        setState(() {
          _isInputBlocked = true;
        });
        timer.cancel();
      }
    });
  }

  void _resetCountdown() {
    _timer?.cancel();
    setState(() {
      _remainingTime = 60;
      _isInputBlocked = false;
    });
    _startCountdown();
  }

  void _addListenersToControllers() {
    for (var controller in _otpControllers) {
      controller.addListener(_checkIfAllFieldsAreFilled);
    }
  }

  void _checkIfAllFieldsAreFilled() {
    final allFilled =
        _otpControllers.every((controller) => controller.text.isNotEmpty);
    setState(() {
      _isSubmitEnabled = allFilled && !_isInputBlocked;
    });
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  Future<void> fetchData() async {
    try {
      final response = await http
          .get(Uri.parse('https://67ee47bdc11d5ff4bf790013.mockapi.io/info'));

      if (response.statusCode == 200) {
        setState(() {
          users = json.decode(response.body);
          // Find the current user based on userId
          currentUser = users.firstWhere(
            (user) => user['id'] == widget.userId,
            orElse: () => null,
          );
        });
      } else {
        debugPrint("Failed to load data");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Failed to connect to server"),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint("Error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("An error occurred"),
          ),
        );
      }
    }
  }

  Future<void> _handleSubmit() async {
    if (!_isSubmitEnabled || _isLoading) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    final enteredOTP = _otpControllers.map((c) => c.text).join();
    final isCorrect = enteredOTP == _generatedOTP;

    setState(() {
      _isLoading = false;
      _isCodeCorrect = isCorrect;

      if (isCorrect) {
        _submissionMessage = 'OTP Verified Successfully!';
        _submissionMessageColor = Colors.green;
        _incorrectAttempts = 0;
        _timer?.cancel();

        // Check if fingerprint authentication is enabled for this user
        if (currentUser != null && currentUser!['isfinger'] == "1") {
          // Navigate to fingerprint authentication
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => FingerprintAuthScreen(
                userId: currentUser!['id'],
              ),
            ),
          );
        } else if (currentUser != null && currentUser!['ispin'] == "1") {
          // Navigate to fingerprint authentication
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PinCodeScreen(
                userId: currentUser!['id'],
              ),
            ),
          );
        } else if (currentUser != null && currentUser!['isfaceid'] == "1") {
          // Navigate to fingerprint authentication
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => FaceIDAuthScreen(
                userId: currentUser!['id'],
              ),
            ),
          );
        } else {
          // Navigate directly to home screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Homepage(userId: currentUser!['id']),
            ),
          );
        }
      } else {
        _submissionMessage =
            'Incorrect OTP. ${3 - _incorrectAttempts - 1} attempts remaining';
        _submissionMessageColor = Colors.red;
        _incorrectAttempts++;

        if (_incorrectAttempts >= 3) {
          _isInputBlocked = true;
          _timer?.cancel();
        } else {
          // Clear only the incorrect OTP
          for (var controller in _otpControllers) {
            controller.clear();
          }
          // Move focus back to first field
          if (mounted) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                FocusScope.of(context).requestFocus(_otpFocusNodes[0]);
              }
            });
          }
        }
      }
    });

    if (_incorrectAttempts >= 3) {
      // Show error for max attempts
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('Maximum attempts reached. Please request a new OTP.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Image.asset(
                  'assets/images/main_photo.png',
                  height: 200,
                ),
                const SizedBox(height: 20),
                const Text(
                  'OTP Verification',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'We have sent OTP via SMS or email,\nPlease check your mail or SMS and Complete the OTP code.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(4, (index) {
                    return SizedBox(
                      width: 50,
                      child: TextField(
                        controller: _otpControllers[index],
                        focusNode: _otpFocusNodes[index],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        enabled: !_isInputBlocked && _incorrectAttempts < 3,
                        decoration: InputDecoration(
                          counterText: '',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        onChanged: (value) {
                          if (value.length == 1 && index < 3) {
                            FocusScope.of(context)
                                .requestFocus(_otpFocusNodes[index + 1]);
                          } else if (value.isEmpty && index > 0) {
                            FocusScope.of(context)
                                .requestFocus(_otpFocusNodes[index - 1]);
                          }
                          _checkIfAllFieldsAreFilled();
                        },
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 20),
                Text(
                  _formatTime(_remainingTime),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Didn\'t receive OTP?',
                      style: TextStyle(fontSize: 14),
                    ),
                    TextButton(
                      onPressed:
                          (_remainingTime == 0 || _incorrectAttempts >= 3)
                              ? () {
                                  _resetCountdown();
                                  _generateAndSendOTP();
                                }
                              : null,
                      child: Text(
                        'Resend',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color:
                              (_remainingTime == 0 || _incorrectAttempts >= 3)
                                  ? Colors.blue
                                  : Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Column(
                  children: [
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: _isSubmitEnabled &&
                                  !_isLoading &&
                                  _incorrectAttempts < 3
                              ? _handleSubmit
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isSubmitEnabled
                                ? (_isLoading ? Colors.grey : Colors.green)
                                : Colors.grey,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Text('SUBMIT',
                                  style: TextStyle(color: Colors.white)),
                        ),
                        AnimatedOpacity(
                          opacity: _submissionMessage.isNotEmpty ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 300),
                          child: Text(
                            _submissionMessage,
                            style: TextStyle(
                              color: _submissionMessageColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            top: _isMessageUp ? -100 : 50,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _otpMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      _isMessageUp
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_up,
                      color: Colors.white,
                    ),
                    onPressed: () =>
                        setState(() => _isMessageUp = !_isMessageUp),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
