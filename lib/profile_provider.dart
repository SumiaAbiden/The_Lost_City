import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileProvider extends ChangeNotifier {
  String _name = '';
  String _birthPlace = '';
  String _birthDate = '';

  String get name => _name;
  String get birthPlace => _birthPlace;
  String get birthDate => _birthDate;

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  UserProfileProvider() {
    _loadProfile();
  }

  void _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    _name = prefs.getString('name') ?? '';
    _birthPlace = prefs.getString('birthPlace') ?? '';
    _birthDate = prefs.getString('birthDate') ?? '';
    _isLoaded = true;
    notifyListeners();
  }

  Future<void> updateProfile({required String name, required String birthPlace, required String birthDate}) async {
    _name = name;
    _birthPlace = birthPlace;
    _birthDate = birthDate;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name);
    await prefs.setString('birthPlace', birthPlace);
    await prefs.setString('birthDate', birthDate);
    notifyListeners();
  }
}
