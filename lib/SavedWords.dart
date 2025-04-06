// SavedWords.dart
import 'package:flutter/material.dart';
import 'package:proje2/AppDrawer.dart';

class SavedWords extends StatefulWidget {
  const SavedWords({super.key});


  // 1. addWord metodunu buraya taşıyın (StatefulWidget'a ekleyin)
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Save Cities'), // Başlık metni
        centerTitle: true, // Başlığı ortala
        backgroundColor: Color.fromRGBO(69, 119, 117, 100), // Sabit renk vermek isterseniz
        iconTheme: IconThemeData(color: Colors.white), // İkon rengi
      ),
      drawer: AppDrawer(),
      body:
      Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Color.fromRGBO(49, 112, 117, 1), Colors.grey],
          ),
        ),

        child: ListView.builder( // Column yerine doğrudan ListView.builder
          itemCount: SavedWords.savedWords.length,
          itemBuilder: (context, index) => Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(
                SavedWords.savedWords[index],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(SavedWords.savedDescriptions[index]),
            ),
          ),
        ),
      ),
    );
  }
}