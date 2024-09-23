import 'package:firebasebookingapp/helper/helper_function.dart';
import 'package:firebasebookingapp/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import './pages/home_page.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:provider/provider.dart';
import './Provider/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
  );
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(), 
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isSignIn = false;

  @override
  void initState() {
    super.initState();
    getUserLoggedInStatus();
  }

  void getUserLoggedInStatus() async {
    await HelperFunctions.getUserLoggedInStatus().then((value) {
      if (value != null) {
        setState(() {
          isSignIn = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Beauty Booking',
      themeMode: themeProvider.themeMode,
      home: isSignIn ? const HomePage() : const LoginPage(),
    );
  }
}
