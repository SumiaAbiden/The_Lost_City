import 'package:flutter/material.dart';
import 'package:proje2/AppDrawer.dart';

import 'Home.dart';
import 'Game.dart';
import 'Login.dart';
import 'package:proje2/SavedWords.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // "Debug" yazısını kaldırır
      initialRoute: '/',
      routes: {
        '/': (context) => Home(),
        '/login': (context) => Login(),
        '/game': (context) => Game(),
        '/saved': (context) => SavedWords(),

      },
    );

  }
}
