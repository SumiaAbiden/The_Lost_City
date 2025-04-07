import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart'; 

import 'AppDrawer.dart';
import 'dart:math';
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
  'P', 'R', 'S', 'T', 'U',
  'V', 'Y', 'Z'
];


var word_dict = {
  // ORTA DOĞU & ASYA
  "JERUSALEM": "The holy city for 3 religions. (Israel/Palestine)",
  "MECCA": "The holiest city in Islam. (Saudi Arabia)",
  "DUBAI": "Home to the world's tallest building. (UAE)",
  "RIYADH": "One of the richest cities per capita. (Saudi Arabia)",
  "BAGHDAD": "The legendary 'City of Peace'. (Iraq)",
  "TEHRAN": "World's most expensive caviar (€25,000/kg). (Iran)",
  "DAMASCUS": "Oldest continuously inhabited city. (Syria)",
  "ANKARA": "Often confused with Istanbul. (Turkey)",
  "ABU DHABI": "Built on a grid plan. (UAE)",
  "DOHA": "Hosted the 2022 FIFA World Cup. (Qatar)",
  "AMMAN": "Built on seven hills like Rome. (Jordan)",
  "BEIRUT": "Known as the 'Paris of the Middle East'. (Lebanon)",
  "MUSCAT": "Famous for frankincense trade. (Oman)",
  "MANAMA": "Home to the Bahrain Grand Prix. (Bahrain)",
  "KUWAIT CITY": "Towers shaped like Islamic minarets. (Kuwait)",

  // AVRUPA
  "LONDON": "Metro with 270+ stations. (UK)",
  "PARIS": "Eiffel Tower was temporary. (France)",
  "BERLIN": "East Side Gallery: 1.3km art wall. (Germany)",
  "ROME": "Built on seven hills. (Italy)",
  "MADRID": "Highest capital in Europe. (Spain)",
  "BARCELONA": "Home to Sagrada Familia. (Spain)",
  "AMSTERDAM": "Built on wooden piles. (Netherlands)",
  "BRUSSELS": "EU headquarters. (Belgium)",
  "VIENNA": "World capital of classical music. (Austria)",
  "PRAGUE": "Astronomical clock since 1410. (Czech Republic)",
  "BUDAPEST": "Divided by the Danube. (Hungary)",
  "WARSAW": "Phoenix city (rebuilt after WWII). (Poland)",
  "LISBON": "Oldest city in Western Europe. (Portugal)",
  "STOCKHOLM": "Venice of the North. (Sweden)",
  "OSLO": "70% live near nature. (Norway)",
  "HELSINKI": "Made of 330 islands. (Finland)",
  "COPENHAGEN": "Bike-friendly capital. (Denmark)",
  "ATHENS": "Oldest European capital. (Greece)",
  "DUBLIN": "Home of Guinness. (Ireland)",

  // ASYA-PASİFİK
  "TOKYO": "Most populous city. (Japan)",
  "BEIJING": "Forbidden City: 9,000+ rooms. (China)",
  "SHANGHAI": "World's busiest port. (China)",
  "HONG KONG": "Skyscrapers meet mountains. (China)",
  "SEOUL": "Free Wi-Fi everywhere. (South Korea)",
  "BANGKOK": "World's longest city name. (Thailand)",
  "SINGAPORE": "Fines for chewing gum. (Singapore)",
  "KUALA LUMPUR": "Petronas Twin Towers. (Malaysia)",
  "JAKARTA": "Sinking due to groundwater. (Indonesia)",
  "MANILA": "Traffic jams last 10+ hours. (Philippines)",
  "DELHI": "Most polluted capital. (India)",
  "MUMBAI": "Home to Bollywood. (India)",
  "BANGALORE": "India's Silicon Valley. (India)",
  "COLOMBO": "Famous for cinnamon. (Sri Lanka)",
  "KATHMANDU": "Near Mount Everest. (Nepal)",
  "DHAKA": "World's most crowded city. (Bangladesh)",
  "HANOI": "Old Quarter: 1,000+ years. (Vietnam)",
  "HO CHI MINH CITY": "Formerly Saigon. (Vietnam)",
  "PHNOM PENH": "Killing Fields memorial. (Cambodia)",
  "ULAANBAATAR": "Coldest capital. (Mongolia)",
  "SYDNEY": "Iconic Opera House. (Australia)",
  "MELBOURNE": "World's most livable city. (Australia)",
  "AUCKLAND": "City of sails. (New Zealand)",

  // AFRİKA
  "CAIRO": "Pyramids of Giza nearby. (Egypt)",
  "CAPE TOWN": "Table Mountain landmark. (South Africa)",
  "JOHANNESBURG": "Gold rush history. (South Africa)",
  "NAIROBI": "National park within city. (Kenya)",
  "ADDIS ABABA": "African Union HQ. (Ethiopia)",
  "CASABLANCA": "Famous film namesake. (Morocco)",
  "TUNIS": "Near ancient Carthage. (Tunisia)",
  "ALGIERS": "Whitewashed buildings. (Algeria)",
  "LAGOS": "Africa's largest city. (Nigeria)",
  "ACCRA": "Center of Ghana's economy. (Ghana)",
  "DAR ES SALAAM": "Swahili coast hub. (Tanzania)",
  "KAMPALA": "Built on seven hills. (Uganda)",
  "KIGALI": "Africa's cleanest city. (Rwanda)",

  // KUZEY AMERİKA
  "NEW YORK": "Statue of Liberty gift. (USA)",
  "LOS ANGELES": "Hollywood sign. (USA)",
  "CHICAGO": "Windy City nickname. (USA)",
  "TORONTO": "CN Tower landmark. (Canada)",
  "MONTREAL": "Largest French-speaking city (after Paris). (Canada)",
  "VANCOUVER": "Mountains meet ocean. (Canada)",
  "MEXICO CITY": "Built on Aztec ruins. (Mexico)",
  "HAVANA": "Classic cars everywhere. (Cuba)",
  "SAN JUAN": "Colorful colonial streets. (Puerto Rico)",

  // GÜNEY AMERİKA
  "RIO DE JANEIRO": "Christ the Redeemer statue. (Brazil)",
  "SAO PAULO": "Largest city in Americas. (Brazil)",
  "BUENOS AIRES": "Birthplace of tango. (Argentina)",
  "LIMA": "One of the driest capitals. (Peru)",
  "BOGOTA": "2,600m above sea level. (Colombia)",
  "SANTIAGO": "Andes Mountains backdrop. (Chile)",
  "CARACAS": "Highest waterfall nearby. (Venezuela)",
  "QUITO": "World's highest capital. (Ecuador)",
  "MONTEVIDEO": "Most liberal capital. (Uruguay)"
};



List images = [
  "assets/0.png",
  "assets/1.png",
  "assets/2.png",
  "assets/3.png",
  "assets/4.png",
  "assets/5.png",
  "assets/6.png"
];

class _GameState extends State<Game> {
  late String word;
  late String description;
  List<String> guessedletters = []; //Kullanıcının tahmin ettiği harfler listesi
  List<String> wrongletters = []; //yanlış harf listesi
  int points = 0;
  int status = 0;

  final AudioPlayer _audioPlayer = AudioPlayer(); 
  bool _soundOn = true; //Sesin durumu

  @override
  void initState() {
    super.initState();
    final wordList = word_dict.keys.toList();
    word = wordList[Random().nextInt(wordList.length)];
    description = word_dict[word]!;
  }

  Future<void> _playSound(String soundName) async {
    if (_soundOn) {
      await _audioPlayer.play(AssetSource("sounds/$soundName.mp3"));
    }
  }

  descpopup() {
    /*Şehir ile ilgili bilgieri içeren popup*/
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            width: MediaQuery.of(context).size.width / 2,
            height: 200,
            decoration: BoxDecoration(color: Colors.white),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(description,
                    style: TextStyle(
                        fontFamily: 'RetroGaming',
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    SavedWords.addWord(word, description);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('City Saved!')),
                    );
                  },
                  child: Text("Save City",
                      style: TextStyle(
                          fontFamily: 'RetroGaming',
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold)),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  openpopup(String title) {
    /*Kullanıcının toplam puanını ve kazanma durumunu gösteren pop up*/
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            width: MediaQuery.of(context).size.width / 2,
            height: 180,
            decoration: BoxDecoration(
                color: Color.fromRGBO(37, 156, 142, 1.0)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title,
                    style: TextStyle(
                        fontFamily: 'RetroGaming',
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
                SizedBox(height: 5),
                Text("City: $word", //Oyunda gizli olan kelime
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w700)),
                SizedBox(height: 5),
                Text("Total points: $points", //Kullanıcının toplam puanı
                    style: TextStyle(
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
                      child: Text("Play Again!",
                          style: TextStyle(
                              fontFamily: 'RetroGaming',
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton( // Şehir hakkında bilgi edinme butonu
                      onPressed: () {
                        descpopup();
                      },
                      child: Text("About the City",
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

  checkletter(String letter) {
    /*Kullanıcının girdiği harf kontrol edilir ve ona göre uygun listeye eklenir, puan eklemesin de bu fonksiyon ile yapılır*/
    if (word.contains(letter)) {
      setState(() {
        guessedletters.add(letter);
        points += 5;
      });
      _playSound("correct"); //
    } else {
      setState(() {
        wrongletters.add(letter);
        status += 1;
      });
      _playSound("wrong"); //
    }

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
      _playSound("lose"); // Звук поражения
      openpopup("GAME OVER!");
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromRGBO(69, 119, 117, 1),
        title: Text("The Lost City",
            style: TextStyle(
                fontFamily: 'Raleway',
                fontStyle: FontStyle.italic,
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.w700)),
        actions: [
          IconButton(
            iconSize: 25,
            icon: Icon(_soundOn ? Icons.volume_up_sharp : Icons.volume_off), //ses ikonu kontrolü
            color: Colors.black,
            onPressed: () {
              setState(() {
                _soundOn = !_soundOn;
              });
            },
          )
        ],
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 20),
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width / 3.5,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(69, 119, 117, 1),
                ),
                height: 30,
                child: Center(
                  child: Text("$points points", //Kullanıcının topladığı puanlar
                      style: TextStyle(
                          fontFamily: 'RetroGaming',
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w700)),
                ),
              ),
              SizedBox(height: 20),
              Image(
                  width: 155,
                  height: 155,
                  image: AssetImage(images[status]),
                  fit: BoxFit.cover),
              SizedBox(height: 15),
              Text("${6 - status} tries left", //Kalan deneme hakkı
                  style: TextStyle(
                      fontFamily: 'RetroGaming',
                      color: Colors.grey,
                      fontSize: 18,
                      fontWeight: FontWeight.w700)),
              SizedBox(height: 30),
              Text(handletext(),
                  style: TextStyle(
                      fontFamily: 'RetroGaming',
                      color: Colors.white,
                      fontSize: 35,
                      fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center),
              SizedBox(height: 20),
              GridView.count(
                crossAxisCount: 6,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.all(10),
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                childAspectRatio: 1.3,
                children: letters.map((letter) {
                  bool isGuessed = guessedletters.contains(letter);
                  bool isWrong = wrongletters.contains(letter);

                  //Doğru veya yanlış tahmine göre harflerin renk değiştirmesi
                  Color letterColor = Colors.white;
                  if (isGuessed) {
                    letterColor = Colors.green;
                  } else if (isWrong) {
                    letterColor = Colors.red;
                  }

                  return InkWell( //Klavye bölümü
                    onTap: () => checkletter(letter),
                    child: Center(
                      child: Text(
                        letter,
                        style: TextStyle(
                          color: letterColor,
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
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
