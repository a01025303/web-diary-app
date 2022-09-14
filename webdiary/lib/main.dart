// Imports

import 'package:webdiary/screens/login_page.dart';
import 'screens/main_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// App run
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}
// Future<void> main() async {
//   await Firebase.initializeApp();
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(const MyApp());
// }

// Stateless Widget to create app
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Root of application
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Delete banner from app
      debugShowCheckedModeBanner: false,
      // Set title
      title: 'Diary Book',
      // Set theme
      theme: ThemeData(
        // Set primary color
        primarySwatch: Colors.purple,
        // Set visual density
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // Call main app
      home: const MyLoginPage(),
    );
  }
}
