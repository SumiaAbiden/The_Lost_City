import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String> fetchLogoUrl() async {
  final response = await http.get(
    Uri.parse('https://67f0187d2a80b06b8896e4aa.mockapi.io/settings/1'),
  );

  if (response.statusCode == 200) {
    return json.decode(response.body)['logoUrl']; // API'den gelen logo
  } else {
    throw Exception('Image not loaded!'); // Hata durumu
  }
}


class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Color.fromRGBO(69, 119, 117, 100),
        child: Column(
          children: [
            // DrawerHeader (Logo ve yazı)
            DrawerHeader(
              child: Row(
                children: [
                  ClipOval(
                    child: FutureBuilder<String>(
                      future: fetchLogoUrl(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator(); // Yükleniyor
                        } else if (snapshot.hasError) {
                          return Icon(Icons.error); // Hata
                        } else {
                          return Image.network(
                            snapshot.data!, // API'den gelen logo URL'si
                            width: 75,
                            height: 75,
                            fit: BoxFit.cover,
                          );
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Text(
                    'The Lost City',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            // Menü öğeleri
            ListTile(
              leading: Icon(Icons.home),
              title: const Text('Home Page'),
              onTap: () {
                Navigator.pushNamed(context, '/');
              },
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: const Text('Saved Cities'),
              onTap: () {
                Navigator.pushNamed(context, '/saved');
              },
            ),
            // Spacer kullanarak butonları aşağıya çekiyoruz
            Spacer(), // Butonları alt kısma çeker
            const Divider(color: Colors.black),
            ListTile(
              leading: Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: const Text('Log Out'),
              onTap: () {
                Navigator.pushNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
    );
  }
}