import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:voyzon/screens/signInPage.dart';

import '../Authentication/authService.dart';
import '../models/user.dart';
import 'homePage.dart';


class LandingPage extends StatefulWidget {
  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  late Future<User?> _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = AuthService().getCurrentUser();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: _currentUser,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _progressIndicator();
        } else if (snapshot.hasError) {
          //TODO: Think how to handel this?
          return Scaffold(
            body: Center(
              child: Text("Error: ${snapshot.error}"),
            ),
          );
        } else {
          User? user = snapshot.data;
          if (user != null) {
            return HomePage(user: user);
          } else {
            return SignInPage();
          }
        }
      },
    );
  }

  Widget _progressIndicator() {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
