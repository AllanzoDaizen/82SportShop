import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sportshop/forget.dart';
import 'package:sportshop/signup.dart';
import 'otp.dart';
import 'package:http/http.dart' as http;

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SportShop',
      theme: ThemeData(
        fontFamily: 'Poppins',
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,
      home: SignInScreen(),
    );
  }
}

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  List<dynamic> user = [];
  bool _obscurePassword = true; // To toggle password visibility
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _emailError; // Error message for invalid email
  bool _isLoading = false; // To show loading state

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
          user = json.decode(response.body);
        });
      } else {
        debugPrint("Failed to load data");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to connect to server"),
          ),
        );
      }
    } catch (e) {
      debugPrint("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("An error occurred"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),

              // Main Photo
              Center(
                child: Image.asset(
                  'assets/images/main_photo.png', // Main photo asset
                  height: 150, // Adjust the height as needed
                  width: 300, // Adjust the width as needed
                  errorBuilder: (context, error, stackTrace) {
                    return const Text(
                        'Error loading main photo'); // Debugging placeholder
                  },
                ),
              ),
              const SizedBox(height: 30),

              // Welcome Text
              const Text(
                "Welcome Back!",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              const Text(
                "Sign In to continue",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 20),

              // Email / Phone Input
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  errorText: _emailError, // Display error message if invalid
                ),
                onChanged: (value) {
                  setState(() {
                    // Validate email ends with @gmail.com
                    if (value.isNotEmpty && !value.endsWith('@gmail.com')) {
                      _emailError = "Email must end with @gmail.com";
                    } else {
                      _emailError = null; // Clear error if valid
                    }
                  });
                },
              ),
              const SizedBox(height: 15),

              // Password Input
              TextField(
                obscureText: _obscurePassword,
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgotPasswordScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Sign In Button
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
                  onPressed: _isLoading
                      ? null
                      : () async {
                          // Check if email and password match with API data
                          final email = _emailController.text.trim();
                          final password = _passwordController.text.trim();

                          if (email.isEmpty || password.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Please enter both email and password",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            );
                            return;
                          }

                          if (_emailError != null) {
                            return;
                          }

                          setState(() {
                            _isLoading = true;
                          });

                          try {
                            final matchedUser = user.firstWhere(
                              (u) =>
                                  u['email'] == email &&
                                  u['password'] == password,
                              orElse: () => null,
                            );

                            if (matchedUser != null) {
                              // Navigate to the OTP screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OTPVerificationScreen(
                                      userId: matchedUser['id']),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Invalid email or password",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              );
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Error: $e",
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ),
                            );
                          } finally {
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        },
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "SIGN IN",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                ),
              ),
              const SizedBox(height: 20),

              // OR Sign In with
              const Text("or login with"),
              const SizedBox(height: 10),

              // Social Media Sign-In Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey[300],
                    child: IconButton(
                      icon: const Icon(Icons.facebook, color: Colors.black),
                      onPressed: () {
                        // Handle Facebook login
                      },
                    ),
                  ),
                  const SizedBox(width: 20),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey[300],
                    child: IconButton(
                      icon: const Icon(Icons.g_mobiledata, color: Colors.black),
                      onPressed: () {
                        // Handle Google login
                      },
                    ),
                  ),
                  const SizedBox(width: 20),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey[300],
                    child: IconButton(
                      icon: const Icon(Icons.apple, color: Colors.black),
                      onPressed: () {
                        // Handle Apple login
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Sign Up Option
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUpPage(),
                        ),
                      );
                    },
                    child: const Text(
                      "SIGN UP",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
