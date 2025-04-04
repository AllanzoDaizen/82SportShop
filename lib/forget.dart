import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;
  bool _emailVerified = false;
  bool _otpVerified = false;
  String? _userId;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _generatedOtp;
  int? _otpExpiryTime;
  List<dynamic> users = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http
          .get(Uri.parse('https://67ee47bdc11d5ff4bf790013.mockapi.io/info'));

      if (response.statusCode == 200) {
        setState(() {
          users = json.decode(response.body);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forgot Password"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!_emailVerified) ...[
              _buildEmailVerificationUI(),
            ] else if (!_otpVerified) ...[
              _buildOtpVerificationUI(),
            ] else ...[
              _buildPasswordResetUI(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmailVerificationUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Enter your registered email address to reset your password",
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: "Email",
            hintText: "yourname@gmail.com",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            errorText: _errorMessage,
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: _isLoading ? null : _verifyEmail,
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
                    "VERIFY EMAIL",
                    style: TextStyle(color: Colors.white),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildOtpVerificationUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "We've sent a 6-digit OTP to ${_emailController.text}",
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 10),
        const Text(
          "Please enter the OTP to verify your identity",
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _otpController,
          decoration: InputDecoration(
            labelText: "OTP",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            errorText: _errorMessage,
          ),
          keyboardType: TextInputType.number,
          maxLength: 6,
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: _isLoading ? null : _verifyOtp,
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
                    "VERIFY OTP",
                    style: TextStyle(color: Colors.white),
                  ),
          ),
        ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: _resendOtp,
          child: const Text("Didn't receive OTP? Resend"),
        ),
      ],
    );
  }

  Widget _buildPasswordResetUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Set your new password",
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
            labelText: "New Password",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
          ),
          obscureText: _obscurePassword,
        ),
        const SizedBox(height: 15),
        TextField(
          controller: _confirmPasswordController,
          decoration: InputDecoration(
            labelText: "Confirm New Password",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            errorText: _errorMessage,
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirmPassword
                    ? Icons.visibility_off
                    : Icons.visibility,
              ),
              onPressed: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },
            ),
          ),
          obscureText: _obscureConfirmPassword,
        ),
        if (_successMessage != null) ...[
          const SizedBox(height: 20),
          Text(
            _successMessage!,
            style: const TextStyle(color: Colors.green),
          ),
        ],
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: _isLoading ? null : _updatePassword,
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
                    "UPDATE PASSWORD",
                    style: TextStyle(color: Colors.white),
                  ),
          ),
        ),
      ],
    );
  }

  Future<void> _verifyEmail() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      setState(() {
        _errorMessage = "Please enter your email address";
      });
      return;
    }

    if (!email.endsWith('@gmail.com')) {
      setState(() {
        _errorMessage = "Please enter a valid Gmail address";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      // Check if email exists in our API data
      final user = users.firstWhere(
        (u) => u['email'] == email,
        orElse: () => null,
      );

      if (user != null) {
        // Generate a 6-digit OTP
        _generatedOtp = _generateOtp();
        _otpExpiryTime = DateTime.now()
            .add(const Duration(minutes: 5))
            .millisecondsSinceEpoch;
        _userId = user['id']; // Store user ID for password update

        // In a real app, you would send this OTP to the user's email
        debugPrint('OTP for $email: $_generatedOtp'); // For testing purposes

        setState(() {
          _emailVerified = true;
          _errorMessage = null;
        });

        // Show a snackbar with the OTP (for testing only)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('OTP sent (for testing): $_generatedOtp'),
            duration: const Duration(seconds: 5),
          ),
        );
      } else {
        setState(() {
          _errorMessage = "Email not found. Please check and try again.";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "An error occurred. Please try again.";
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String _generateOtp() {
    final random = Random();
    return (100000 + random.nextInt(900000)).toString();
  }

  Future<void> _verifyOtp() async {
    final enteredOtp = _otpController.text.trim();

    if (enteredOtp.isEmpty) {
      setState(() {
        _errorMessage = "Please enter the OTP";
      });
      return;
    }

    if (enteredOtp.length != 6) {
      setState(() {
        _errorMessage = "OTP must be 6 digits";
      });
      return;
    }

    final currentTime = DateTime.now().millisecondsSinceEpoch;
    if (_otpExpiryTime == null || currentTime > _otpExpiryTime!) {
      setState(() {
        _errorMessage = "OTP has expired. Please request a new one.";
      });
      return;
    }

    if (enteredOtp != _generatedOtp) {
      setState(() {
        _errorMessage = "Invalid OTP. Please try again.";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        _otpVerified = true;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Verification failed. Please try again.";
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _resendOtp() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _otpController.clear();
    });

    try {
      // Generate a new OTP
      _generatedOtp = _generateOtp();
      _otpExpiryTime =
          DateTime.now().add(const Duration(minutes: 5)).millisecondsSinceEpoch;

      // In a real app, you would send this OTP to the user's email
      debugPrint('New OTP: $_generatedOtp'); // For testing purposes

      // Show a snackbar with the new OTP (for testing only)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('New OTP sent (for testing): $_generatedOtp'),
          duration: const Duration(seconds: 5),
        ),
      );
    } catch (e) {
      setState(() {
        _errorMessage = "Failed to resend OTP. Please try again.";
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updatePassword() async {
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (password.isEmpty || confirmPassword.isEmpty) {
      setState(() {
        _errorMessage = "Please enter and confirm your new password";
      });
      return;
    }

    if (password != confirmPassword) {
      setState(() {
        _errorMessage = "Passwords do not match";
      });
      return;
    }

    // Strong password validation
    if (password.length < 8) {
      setState(() {
        _errorMessage = 'Password must be at least 8 characters';
      });
      return;
    }
    if (!password.contains(RegExp(r'[A-Z]'))) {
      setState(() {
        _errorMessage = 'Password must contain at least one uppercase letter';
      });
      return;
    }
    if (!password.contains(RegExp(r'[a-z]'))) {
      setState(() {
        _errorMessage = 'Password must contain at least one lowercase letter';
      });
      return;
    }
    if (!password.contains(RegExp(r'[0-9]'))) {
      setState(() {
        _errorMessage = 'Password must contain at least one number';
      });
      return;
    }
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      setState(() {
        _errorMessage = 'Password must contain at least one special character';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Update password in the API
      final response = await http.put(
        Uri.parse('https://67ee47bdc11d5ff4bf790013.mockapi.io/info/$_userId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'password': password}),
      );

      if (response.statusCode == 200) {
        setState(() {
          _successMessage = "Password updated successfully!";
        });

        _passwordController.clear();
        _confirmPasswordController.clear();

        // Return to login after 2 seconds
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.pop(context);
          }
        });
      } else {
        setState(() {
          _errorMessage = "Failed to update password. Please try again.";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Failed to connect to server. Please try again.";
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
