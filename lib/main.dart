import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:voyzon/firebase_options.dart';
import 'package:voyzon/models/user.dart';
import 'package:voyzon/screens/createTaskPage.dart';
import 'package:voyzon/screens/landingPage.dart';

import 'common/routeNames.dart';


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
      initialRoute: "/",
      onGenerateRoute: (settings) {
        final args = settings.arguments;
        switch(settings.name) {
          case RouteNames.HOME_PAGE:
            return MaterialPageRoute(builder: (_) => LandingPage());
          case RouteNames.CREATE_TASK:
            if(args is User) {
              return MaterialPageRoute(builder: (_)=> CreateTaskPage(user: args));
            }
          // default:
          //   return _errorRoute
        }
      },
    );
  }
}


