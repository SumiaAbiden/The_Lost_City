import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Widgets/BasePage.dart';
import 'Login.dart';

// Logo URL'sini API'den çeken fonksiyon
Future<String> fetchLogoUrl() async {
  final response = await http.get(
    Uri.parse('https://67f0187d2a80b06b8896e4aa.mockapi.io/settings/1'),
  );

  if (response.statusCode == 200) {
    return json.decode(response.body)['logoUrl'];
  } else {
    throw Exception('Failed to load logo image from API.');
  }
}

// StatefulWidget yaparak Future'ı initState'de başlatıyoruz
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<String> _logoFuture;

  @override
  void initState() {
    super.initState();
    // Logo URL'sini çekme işlemini başlatıyoruz, böylece rebuild'lerde tekrar çağrılmaz
    _logoFuture = fetchLogoUrl();
  }

  // Hata durumunda çağrılacak fonksiyon, retry için Future'ı yeniden başlatıyoruz
  void _retryFetch() {
    setState(() {
      _logoFuture = fetchLogoUrl();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: "Home Page",
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color.fromRGBO(32, 77, 82, 1),
              Color.fromRGBO(107, 119, 123, 1),
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "The Lost City",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'RetroGaming',
                    color: Colors.white,
                    fontSize: 42,
                    fontWeight: FontWeight.w900,
                    shadows: [
                      Shadow(
                        offset: Offset(2, 2),
                        blurRadius: 5,
                        color: Colors.black54,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                ClipOval(
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                      shape: BoxShape.circle,
                    ),
                    child: FutureBuilder<String>(
                      future: _logoFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return SizedBox(
                            width: 90,
                            height: 90,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return SizedBox(
                            width: 90,
                            height: 120,  // Retry butonu için yüksekliği artırdık
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 90,
                                  height: 90,
                                  color: Colors.grey[300],
                                  child: Icon(Icons.error, color: Colors.red, size: 40),
                                ),
                                const SizedBox(height: 8),
                                ElevatedButton(
                                  onPressed: _retryFetch,
                                  child: Text('Retry'),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Image.network(
                            snapshot.data!,
                            width: 90,
                            height: 90,
                            fit: BoxFit.cover,
                          );
                        }
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                Text(
                  "Login Now, and Start Playing!!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'RetroGaming',
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    shadows: [
                      Shadow(
                        offset: Offset(1, 1),
                        blurRadius: 4,
                        color: Colors.black45,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(0, 150, 136, 1),
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 6,
                      shadowColor: Colors.black45,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Login()),
                      );
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
