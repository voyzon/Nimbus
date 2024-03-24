import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:voyzon/firebase_options.dart';
import 'package:voyzon/models/user.dart';
import 'package:voyzon/redux/appReducers.dart';
import 'package:voyzon/redux/appState.dart';
import 'package:voyzon/redux/tasks/tasksAction.dart';
import 'package:voyzon/screens/createTaskPage.dart';
import 'package:voyzon/screens/landingPage.dart';

import 'common/routeNames.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  store = Store<AppState>(
    reducer,
    initialState: AppState.initial(),
    middleware: [thunkMiddleware],
  );
  runApp(MyApp());
}

late final Store<AppState> store;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: 'Your App',
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.orange[700],
        ),
        initialRoute: "/",
        onGenerateRoute: (settings) {
          final args = settings.arguments;
          switch (settings.name) {
            case RouteNames.HOME_PAGE:
              return MaterialPageRoute(builder: (_) => LandingPage());
            case RouteNames.CREATE_TASK:
              if (args is User) {
                return MaterialPageRoute(
                    builder: (_) => CreateTaskPage(user: args));
              }
            // default:
            //   return _errorRoute
          }
        },
      ),
    );
  }
}
