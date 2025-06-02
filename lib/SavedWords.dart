import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'BasePage.dart';

class SavedWords extends StatefulWidget {
  const SavedWords({super.key});

  static List<String> savedWords = [];
  static List<String> savedDescriptions = [];

  static void addWord(String word, String description) {
    if (!savedWords.contains(word)) {
      savedWords.add(word);
      savedDescriptions.add(description);
    }
  }

  @override
  State<SavedWords> createState() => _SavedWordsState();
}

class _SavedWordsState extends State<SavedWords> {
  final supabase = Supabase.instance.client;
  final firebaseUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    fetchSavedCities();
  }

  Future<void> fetchSavedCities() async {
    if (firebaseUser == null) return;

    final email = firebaseUser!.email;
    if (email == null) return;

    final response = await supabase
        .from('saved_cities')
        .select()
        .eq('user_email', email)
        .order('created_at', ascending: false);

    if (response != null && response is List) {

      for (final item in response) {
        final city = item['city_name']?.toString() ?? '';
        final score = item['score']?.toString() ?? '';
        SavedWords.addWord(city, 'Score: $score');
      }

      setState(() {});
    } else {
      print("Veri çekilemedi ya da boş.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: "Saved Cities",
      child: Container(
        color: Colors.black,
        child: ListView.builder(
          itemCount: SavedWords.savedWords.length,
          itemBuilder: (context, index) => Card(
            color: Colors.grey[900],
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(
                SavedWords.savedWords[index],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              subtitle: Text(
                SavedWords.savedDescriptions[index],
                style: const TextStyle(color: Colors.white70),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
