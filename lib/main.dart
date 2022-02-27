import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'core/injectionContainer.dart' as di;
import 'package:dentalApp/core/navigationService.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dental App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorKey: di.serviceLocator<NavigationService>().navigatorKey,
      initialRoute: NavigationService.homepage,
      onGenerateRoute: AppNavigationService.generateRoute,
    );
  }
}
