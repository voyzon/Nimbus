import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:voyzon/firebase_options.dart';
import 'package:voyzon/screens/landingPage.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.orange[700],
      ),
      home: LandingPage(),
    );
  }
}

