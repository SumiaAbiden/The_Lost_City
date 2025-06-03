import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:proje2/Pages/EditProfilePage.dart';
import 'package:proje2/Pages/SettingsPage.dart';
import 'package:proje2/Providers/profile_provider.dart';
import 'package:proje2/Providers/settings_provider.dart';
import 'package:provider/provider.dart';
import 'Pages/Home.dart';
import 'Pages/Login.dart';
import 'Pages/ProfilPage.dart';
import 'Pages/SavedWords.dart';
import 'firebase_options.dart';

import 'package:supabase_flutter/supabase_flutter.dart';  // Supabase importu

import 'Pages/Game.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Supabase.initialize(
    url: 'https://niqwdvuieqhmiovuenyf.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5pcXdkdnVpZXFobWlvdnVlbnlmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDg2OTYwNTIsImV4cCI6MjA2NDI3MjA1Mn0.JB5pQNdAJ4E_Z7pT5SFOdMnqSvh0ZFWtKaU8Qr-kZVY',
  );

  await Firebase.initializeApp();

  runApp(
    MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => SettingsProvider()),
          ChangeNotifierProvider(create: (_) => UserProfileProvider()), // ✅ buraya eklendi
        ],
        child: const MyApp(),
      ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        return MaterialApp(
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          routes: {
            '/': (context) => Home(),
            '/login': (context) => Login(),
            '/game': (context) => Game(),
            '/saved': (context) => SavedWords(),
            '/profile': (context) => ProfilPage(),
            '/editprofile': (context) => EditProfilePage(),
            '/settings': (context) => SettingsPage(),
          },
        );
      },
    );
  }
}



