import 'package:flutter/material.dart';

import 'package:chat_app/views/login.dart';
import 'package:chat_app/views/signup.dart';

class Landing extends StatefulWidget {
  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  bool showLoginPage = true;

  void togglePage() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(togglePage);
    } else {
      return SignupPage(togglePage);
    }
  }
}