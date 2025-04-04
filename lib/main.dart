import 'package:flutter/material.dart';
import 'package:sportshop/admin/users_screen.dart';
import 'package:sportshop/home.dart';
import 'package:sportshop/setting.dart';
import 'package:sportshop/signin.dart';

void main() {
  runApp(const SignIn());
  ThemeData(
    fontFamily: 'Poppins',
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
  );
}
