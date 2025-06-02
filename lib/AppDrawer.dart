import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'SavedWords.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String name = '';
  String surname = '';
  String email = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile(); // Kullanıcı profil bilgilerini yükle
  }

  // Firestore'dan kullanıcı profil bilgilerini çekiyoruz
  Future<void> _loadUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      email = user.email ?? '';
      final doc = await FirebaseFirestore.instance.collection('profiles').doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data();
        setState(() { //Kullanici adi ve saoyadi drawera yazdirma
          name = data?['name'] ?? '';
          surname = data?['surname'] ?? '';
          isLoading = false;
        });
      }
    }
  }

  // Drawer'dan başka bir sayfaya yönlendirme fonksiyonu
  void _navigate(BuildContext context, String route) {
    Navigator.pop(context); // Drawer'ı kapat
    if (ModalRoute.of(context)?.settings.name != route) {
      Navigator.pushReplacementNamed(context, route); // Yeni sayfaya geç
    }
  }

  // Kullanıcıyı oturumdan çıkar ve tüm yerel verileri temizle
  Future<void> _logout(BuildContext context) async {
    SavedWords.savedWords.clear(); // Kaydedilmiş kelimeleri temizle
    SavedWords.savedDescriptions.clear();
    await FirebaseAuth.instance.signOut(); // Firebase çıkış

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // SharedPreferences temizliği

    // Kullanıcıya emin olup olmadığını soran uyarı
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Log Out'),
          content: const Text('Are you sure?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                FirebaseAuth.instance.signOut(); // Güvenli çıkış
                Navigator.of(context).pop();
                Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Log Out Successful')),
                );
              },
            ),
          ],
        );
      },
    );
  }

  // Drawer arayüzünü oluşturuyoruz
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: const Color.fromRGBO(49, 112, 117, 1),
        child: Column(
          children: <Widget>[
            // Kullanıcı bilgilerini gösteren üst bölüm
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromRGBO(49, 112, 117, 1),
              ),
              accountName: Text(isLoading ? 'No account' : 'Name: $name $surname'),
              accountEmail: Text(email),
              currentAccountPicture: const CircleAvatar(
                backgroundImage: AssetImage('assets/img.png'), // Profil resmi
              ),
            ),
            // Profil sayfasına git
            ListTile(
              leading: const Icon(Icons.person, color: Colors.white),
              title: const Text('Profile Page', style: TextStyle(color: Colors.white)),
              onTap: () => _navigate(context, '/profile'),
            ),
            // Ana sayfaya dön
            ListTile(
              leading: const Icon(Icons.home, color: Colors.white),
              title: const Text('Home Page', style: TextStyle(color: Colors.white)),
              onTap: () => _navigate(context, '/'),
            ),
            // Kaydedilen şehirleri göster
            ListTile(
              leading: const Icon(Icons.list, color: Colors.white),
              title: const Text('Saved Cities', style: TextStyle(color: Colors.white)),
              onTap: () => _navigate(context, '/saved'),
            ),
            const Divider(),
            // Ayarlar sayfası
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.white),
              title: const Text('Settings', style: TextStyle(color: Colors.white)),
              onTap: () => _navigate(context, '/settings'),
            ),
            // Oturumu kapat
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.white),
              title: const Text('Log Out', style: TextStyle(color: Colors.white)),
              onTap: () => _logout(context),
            ),
          ],
        ),
      ),
    );
  }
}
