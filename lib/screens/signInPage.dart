import 'package:flutter/material.dart';

import '../Authentication/authService.dart';
import '../models/user.dart';
import 'homePage.dart';


class SignInPage extends StatelessWidget {
  final authService = AuthService();

  _signInUser(BuildContext context) async {
    User? user = await authService.signInWithGoogle();

    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomePage(user: user),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Unable to sign in user."))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign In"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _signInUser(context),
          child: const Text('Sign in with Google'),
        ),
      ),
    );
  }
}
