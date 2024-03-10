import 'package:flutter/material.dart';
import 'package:voyzon/authentication/authService.dart';
import '../models/user.dart';

class HomePage extends StatelessWidget {
  final User? user;
  final AuthService _authService = AuthService();
  HomePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              await _authService.signOut(context);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome, ${user?.username ?? 'Guest'}!',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Main Action'),
            ),
          ],
        ),
      ),
    );
  }
}
