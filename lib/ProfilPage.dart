import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'BasePage.dart';
import 'EditProfilePage.dart'; // Düzenleme sayfası

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  String _name = '';
  String _surname = '';
  String _birthplace = '';
  String _birthDate = '';
  String _city = '';

  @override
  void initState() {
    super.initState();
    _loadProfileFromLocal();
  }

  Future<void> _loadProfileFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('name') ?? '';
      _surname = prefs.getString('surname') ?? '';
      _birthplace = prefs.getString('birthplace') ?? '';
      _birthDate = prefs.getString('birthDate') ?? '';
      _city = prefs.getString('city') ?? '';
    });
  }

  Widget _buildProfileItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.grey.shade800,
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? '-' : value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: 'My Profile',
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _name.isEmpty && _surname.isEmpty
            ? Center(
          child: Text(
            'No profile data.',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
        )
            : Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                _buildProfileItem('Name', _name),
                _buildProfileItem('Surname', _surname),
                _buildProfileItem('Birth City', _birthplace),
                _buildProfileItem('Birth Date', _birthDate),
                _buildProfileItem('City', _city),
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit Profile'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditProfilePage(),
                      ),
                    ).then((_) {
                      // Düzenleme sonrası profil güncellenir
                      _loadProfileFromLocal();
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
