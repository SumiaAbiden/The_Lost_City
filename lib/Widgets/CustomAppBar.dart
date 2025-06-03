import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Uygulamanın üst kısmında kullanılacak app bar bileşeni
class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  // AppBar'ın yüksekliğini belirliyoruz
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  String? _logoImageUrl; // Logo URL’si
  bool _isLoading = true; // Yüklenme durumu
  final _supabase = Supabase.instance.client; // Supabase istemcisi

  @override
  void initState() {
    super.initState();
    _fetchProfileImage(); // Sayfa ilk açıldığında logo görselini çekiyoruz
  }

  // Supabase'ten belirli bir aşamaya ait logo görselini alıyoruz
  Future<void> _fetchProfileImage() async {
    try {
      final response = await _supabase
          .from('hangman_stages')
          .select('image_url')
          .eq('stage_number', 7)
          .single(); // Sadece tek bir kayıt bekliyoruz

      setState(() {
        _logoImageUrl = response['image_url'] as String?;
        _isLoading = false;
      });
    } catch (e) {
      print("Profil resmi yükleme hatası: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Logo görselini oluşturan widget
  Widget _buildLogoImage() {
    if (_isLoading) {
      return const CircularProgressIndicator(
        color: Colors.white,
        strokeWidth: 2,
      );
    }

    // Eğer görsel URL’si boşsa varsayılan resmi gösteriyoruz
    if (_logoImageUrl == null || _logoImageUrl!.isEmpty) {
      return ClipOval(
        child: Image.asset(
          'assets/Home.png', // Yedek resim
          height: 40,
          width: 40,
          fit: BoxFit.cover,
        ),
      );
    }

    // Görsel URL’si varsa bu resmi ağdan yükleyip gösteriyoruz
    return ClipOval(
      child: Image.network(
        _logoImageUrl!,
        height: 40,
        width: 40,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: 40,
            height: 40,
            padding: const EdgeInsets.all(8),
            child: const CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          // Görsel yüklenemezse yedek resmi göster
          return ClipOval(
            child: Image.asset(
              'assets/Home.png',
              height: 40,
              width: 40,
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }

  // AppBar arayüzü
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(widget.title),
      backgroundColor: const Color.fromRGBO(49, 112, 117, 1),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/settings'), // Logoya tıklanınca ayarlara git
            child: _buildLogoImage(),
          ),
        ),
      ],
    );
  }
}
