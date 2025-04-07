import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:proje2/AppDrawer.dart';

import 'Game.dart';
import 'Login.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromRGBO(49, 112, 117, 100),
        title: Text("Home Page"),
        iconTheme: IconThemeData(color: Colors.white),
      ),

      drawer: AppDrawer(),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Color.fromRGBO(49, 112, 117, 100), Colors.grey],
          ),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("The Lost City",
            style: TextStyle(
                fontFamily: 'RetroGaming',
                color: Colors.black,
                fontSize: 40,
                fontWeight: FontWeight.w700
            )),

            // Yuvarlak Resim
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/img.png'), //logo resmi bu kısımda kaydedilen dosyalardan alınmıştır
              backgroundColor: Colors.white,
            ),
            SizedBox(height: 40),

            // Buton 1
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: ElevatedButton( //Oyun başlatma butonu
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(49, 112, 117, 100),
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Game()),
                  );
                },
                child: Text(
                  "Start Game",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),

            // Buton 2
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: ElevatedButton( //Login sayfasına yönlendirme
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(49, 112, 117, 100),
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Login()),
                  );
                },
                child: Text(
                  "Login",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
