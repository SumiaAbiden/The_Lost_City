import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../Widgets/BasePage.dart';
import 'SavedWords.dart';

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

List<String> letters = [
  'A', 'B', 'C', 'D', 'E',
  'F', 'G', 'H', 'I', 'J',
  'K', 'L', 'M', 'N', 'O',
  'P', 'Q', 'R', 'S', 'T',
  'U', 'V', 'W', 'X', 'Y',
  'Z'
];


class _GameState extends State<Game> {
  String word = "LOADING"; // Başlangıç değeri
  String description = "Loading city data..."; // Başlangıç değeri
  List<String> guessedletters = [];
  List<String> wrongletters = [];
  int points = 0;
  int status = 0;
  bool _soundOn = true;
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Supabase kaynakları
  Map<String, String> soundUrls = {};
  List<String> imageUrls = List.filled(7, '');
  bool _isLoading = true;

  Map<String, String> word_dict = {};
  bool _isLoadingWords = true;

  @override
  void initState() {
    super.initState();
    _fetchResources();
    _fetchCities(); // Şehirleri çek
  }


  //Şehir isimlerinin supabaseden alınması
  Future<void> _fetchCities() async {
    final supabase = Supabase.instance.client;
    try {
      final response = await supabase
          .from('cities')
          .select('name, description');

      for (final record in response) {
        word_dict[record['name'] as String] = record['description'] as String;
      }
    } catch (e) {
      print("Şehir verileri yükleme hatası: $e");
    } finally {
      setState(() {
        _isLoadingWords = false;
        _selectRandomWord();
      });
    }
  }


  //Şehirler veritabanından random şehir ismi seçimi
  void _selectRandomWord() {
    if (word_dict.isNotEmpty) {
      final wordList = word_dict.keys.toList();
      word = wordList[Random().nextInt(wordList.length)];
      description = word_dict[word]!;
    }
  }


  //Resim ve ses dosyalarının supabase veritabanından alınması
  Future<void> _fetchResources() async {
    final supabase = Supabase.instance.client;
    try {
      // Sesleri yükle
      final soundResponse = await supabase
          .from('hangman_stages')
          .select()
          .in_('stage_number', [101, 102, 201, 202]);

      for (final record in soundResponse) {
        switch (record['stage_number']) {
          case 101:
            soundUrls['correct'] = record['image_url'];
            break;
          case 102:
            soundUrls['wrong'] = record['image_url'];
            break;
          case 201:
            soundUrls['win'] = record['image_url'];
            break;
          case 202:
            soundUrls['lose'] = record['image_url'];
            break;
        }
      }

      // Resimleri yükle
      final imageResponse = await supabase
          .from('hangman_stages')
          .select()
          .in_('stage_number', [0, 1, 2, 3, 4, 5, 6]);

      for (final record in imageResponse) {
        final stage = record['stage_number'] as int;
        if (stage >= 0 && stage <= 6) {
          imageUrls[stage] = record['image_url'];
        }
      }
    } catch (e) {
      print("Kaynak yükleme hatası: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _playSound(String soundName) async {
    if (_soundOn && soundUrls.containsKey(soundName)) {
      await _audioPlayer.play(UrlSource(soundUrls[soundName]!));
    }
  }

  void descpopup() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: Colors.grey[50],
          child: Container(
            constraints: BoxConstraints(
              maxWidth: 400,
              minWidth: MediaQuery.of(context).size.width * 0.4,
            ),
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  description,
                  style: const TextStyle(
                    fontFamily: 'RetroGaming',
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(69, 119, 117, 1),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                    ),
                    onPressed: () {
                      SavedWords.addWord(word, description);
                      saveCityToSupabase(word, points);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('City Saved!')),
                      );
                    },
                    child: const Text(
                      "Save City",
                      style: TextStyle(
                        fontFamily: 'RetroGaming',
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  //Kazanma Durumu popup
  void openpopup(String title) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            width: MediaQuery.of(context).size.width / 2,
            height: 180,
            decoration: const BoxDecoration(
                color: Color.fromRGBO(37, 156, 142, 1.0)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontFamily: 'RetroGaming',
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
                const SizedBox(height: 5),
                Text("City: $word", //Doğru şehir adı
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 5),
                Text("Total points: $points", //Kullacının kazandığı puan
                    style: const TextStyle(
                        fontFamily: 'RetroGaming',
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton( //Tekrar oynama butonu
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const Game()),
                        );
                      },
                      child: const Text("Play Again!",
                          style: TextStyle(
                              fontFamily: 'RetroGaming',
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton( //Şehir hakkında bilgi butonu
                      onPressed: descpopup,
                      child: const Text("About the City",
                          style: TextStyle(
                              fontFamily: 'RetroGaming',
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String handletext() {
    String displayword = "";
    for (int i = 0; i < word.length; i++) {
      String character = word[i];
      if (guessedletters.contains(character)) {
        displayword += character + " ";
      } else if (character == " ") {
        displayword += " ";
      } else {
        displayword += "?";
      }
    }
    return displayword;
  }

  //Girilen Harf Kontrolü
  void checkletter(String letter) {
    if (word.contains(letter)) {
      setState(() {
        guessedletters.add(letter);
        points += 5;
      });
      _playSound("correct");
    } else {
      setState(() {
        wrongletters.add(letter);
        status += 1;
      });
      _playSound("wrong");
    }

    // Kazanma Durumu kontrolü
    bool isWon = true;
    for (int i = 0; i < word.length; i++) {
      String character = word[i];
      if (character != " " && !guessedletters.contains(character)) {
        isWon = false;
        break;
      }
    }

    if (isWon) {
      _playSound("win");
      openpopup("YOU WON!");
      return;
    }

    if (status >= 6) {
      _playSound("lose");
      openpopup("GAME OVER!");
    }
  }

  Future<void> saveCityToSupabase(String cityName, int score) async {
    try {
      final supabase = Supabase.instance.client;
      final firebaseUser = FirebaseAuth.instance.currentUser;

      if (firebaseUser == null) {
        print('HATA: Kullanıcı Firebase\'e giriş yapmamış!');
        return;
      }

      final userEmail = firebaseUser.email;

      await supabase.from('saved_cities').insert({
        'user_email': userEmail,
        'city_name': cityName,
        'score': score,
      });

      print('BAŞARILI: Kayıt eklendi');
    } catch (e) {
      print('CRITICAL HATA: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: "Game Page",
      child: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Container(
          color: Colors.black,
          alignment: Alignment.center,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20),
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width / 3.5,
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(69, 119, 117, 1),
                ),
                height: 30,
                child: Center(
                  child: Text("$points points",
                      style: const TextStyle(
                          fontFamily: 'RetroGaming',
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : imageUrls[status].isEmpty
                  ? const Icon(Icons.broken_image, size: 155)
                  : Image(
                width: 155,
                height: 155,
                image: NetworkImage(imageUrls[status]),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.broken_image),
              ),
              const SizedBox(height: 15),
              Text("${6 - status} tries left",
                  style: const TextStyle(
                      fontFamily: 'RetroGaming',
                      color: Colors.grey,
                      fontSize: 18,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 30),
              Text(handletext(),
                  style: const TextStyle(
                      fontFamily: 'RetroGaming',
                      color: Colors.white,
                      fontSize: 35,
                      fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center),
              const SizedBox(height: 20),
              GridView.count(
                crossAxisCount: 5,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(10),
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                childAspectRatio: 2,
                children: letters.map((letter) {
                  bool isGuessed = guessedletters.contains(letter) ||
                      wrongletters.contains(letter);
                  return ElevatedButton(
                    onPressed: isGuessed ? null : () => checkletter(letter),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: guessedletters.contains(letter)
                          ? Colors.green
                          : wrongletters.contains(letter)
                          ? Colors.red
                          : const Color.fromRGBO(69, 119, 117, 1),
                    ),
                    child: Text(letter,
                        style: const TextStyle(
                            fontFamily: 'RetroGaming',
                            color: Colors.black,
                            fontWeight: FontWeight.bold)),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}