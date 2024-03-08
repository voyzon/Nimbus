import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'authService.dart';
import '../Home/homePage.dart';

class SignInPage extends StatefulWidget {
  
  final AuthService authService;

  const SignInPage({super.key, required this.authService});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign In"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            User? user = await widget.authService.signInWithGoogle();

            if (user != null) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => HomePage(user: user),
                ),
              );
            } else {
              // Handle unsuccessful sign-in
            }
          },
          child: const Text('Sign in with Google'),
        ),
      ),
    );
  }
}