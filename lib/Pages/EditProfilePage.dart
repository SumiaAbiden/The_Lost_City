import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import 'Game.dart';
import '../Widgets/BasePage.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _birthplaceController = TextEditingController();
  final _dateController = TextEditingController();
  final _cityController = TextEditingController();
  bool _isLoading = false;

  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _loadLocalProfile(); // Sayfa yüklenirken yerel profili getir
  }

  // SharedPreferences kullanarak yerel kayıtlı kullanıcı bilgilerini al
  Future<void> _loadLocalProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('name') ?? '';
      _surnameController.text = prefs.getString('surname') ?? '';
      _birthplaceController.text = prefs.getString('birthplace') ?? '';
      _dateController.text = prefs.getString('birthDate') ?? '';
      _cityController.text = prefs.getString('city') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: 'Edit Profile',
      child: _isLoading
          ? Center(
        child: SizedBox(
          width: 60,
          height: 60,
          child: CircularProgressIndicator(
            strokeWidth: 6,
            color: Theme.of(context).primaryColor,
          ),
        ),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: Colors.grey.shade100,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Profile Data',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  _buildTextFormField(
                    controller: _nameController,
                    label: 'Name',
                    validator: (value) =>
                    value!.isEmpty ? 'Name cannot be null' : null,
                  ),
                  const SizedBox(height: 18),
                  _buildTextFormField(
                    controller: _surnameController,
                    label: 'Surname',
                    validator: (value) =>
                    value!.isEmpty ? 'Surname cannot be null' : null,
                  ),
                  const SizedBox(height: 18),
                  _buildTextFormField(
                    controller: _birthplaceController,
                    label: 'Birth City',
                    validator: (value) => value!.isEmpty
                        ? 'Birth City cannot be null'
                        : null,
                  ),
                  const SizedBox(height: 18),
                  _buildTextFormField(
                    controller: _dateController,
                    label: 'Birth Date',
                    readOnly: true,
                    onTap: () => _selectDate(context),
                    suffixIcon:
                    const Icon(Icons.calendar_today_outlined),
                  ),
                  const SizedBox(height: 18),
                  _buildTextFormField(
                    controller: _cityController,
                    label: 'Current City',
                  ),
                  const SizedBox(height: 28),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) return;
                      await _saveProfile(context);
                      if (!mounted) return;
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Game()),
                      );
                    },
                    child: const Text('Save Profile'),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Ortak stil için yeniden kullanılabilir text input widget'ı
  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    FormFieldValidator<String>? validator,
    TextInputType? keyboardType,
    bool readOnly = false,
    GestureTapCallback? onTap,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
          BorderSide(color: Theme.of(context).primaryColor, width: 2),
        ),
        suffixIcon: suffixIcon,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
      validator: validator,
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap: onTap,
    );
  }

  // Takvimden doğum tarihi seçme işlemi
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  // Firebase Firestore'a kullanıcı profilini kaydet
  Future<void> saveProfileToFirestore({
    required String name,
    required String surname,
    String? birthplace,
    String? birthDate,
    String? city,
  }) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) throw Exception('No login data');

    await FirebaseFirestore.instance.collection('profiles').doc(userId).set({
      'name': name,
      'surname': surname,
      'birthplace': birthplace,
      'birth_date': birthDate,
      'city': city,
      'updated_at': DateTime.now().toIso8601String(),
    }, SetOptions(merge: true));
  }

  // Supabase tablosuna kullanıcı bilgilerini güncelle ya da ekle
  Future<void> saveProfileToSupabase({
    required String name,
    required String surname,
    String? birthplace,
    String? birthDate,
    String? city,
  }) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) throw Exception('Firebase login is missing');

    final response = await _supabase.from('profiles').upsert({
      'id': firebaseUser.uid,
      'name': name,
      'surname': surname,
      'birthplace': birthplace,
      'birth_date': birthDate,
      'city': city,
      'updated_at': DateTime.now().toIso8601String(),
    }).execute();

    if (response.status != 200 && response.status != 201) {
      throw Exception('Supabase error: ${response.status} - ${response.data}');
    }
  }

  // SharedPreferences ile verileri cihazda yerel olarak sakla
  Future<void> saveProfileToLocal({
    required String name,
    required String surname,
    String? birthplace,
    String? birthDate,
    String? city,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name);
    await prefs.setString('surname', surname);
    if (birthplace != null) await prefs.setString('birthplace', birthplace);
    if (birthDate != null) await prefs.setString('birthDate', birthDate);
    if (city != null) await prefs.setString('city', city);
  }

  // Formu kontrol edip verileri üç platforma (Firestore, Supabase, local) kaydet
  Future<void> _saveProfile(BuildContext context) async {
    setState(() => _isLoading = true);

    try {
      final name = _nameController.text;
      final surname = _surnameController.text;
      final birthplace = _birthplaceController.text;
      final birthDate =
      _dateController.text.isNotEmpty ? _dateController.text : null;
      final city = _cityController.text;

      // Tüm kayıt işlemlerini aynı anda çalıştır
      await Future.wait([
        saveProfileToFirestore(
          name: name,
          surname: surname,
          birthDate: birthDate,
          birthplace: birthplace,
          city: city,
        ),
        saveProfileToSupabase(
          name: name,
          surname: surname,
          birthDate: birthDate,
          birthplace: birthplace,
          city: city,
        ),
        saveProfileToLocal(
          name: name,
          surname: surname,
          birthDate: birthDate,
          birthplace: birthplace,
          city: city,
        ),
      ]);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile Saved Successfully!')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _birthplaceController.dispose();
    _dateController.dispose();
    _cityController.dispose();
    super.dispose();
  }
}
