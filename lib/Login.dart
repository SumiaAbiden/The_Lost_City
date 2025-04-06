import 'package:flutter/material.dart';
import 'package:proje2/AppDrawer.dart';
import 'Game.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

// Tüm kullanıcı bilgilerini tutan Map
final Map<String, String> _userCredentials = {}; //global değişken olarak tanımlandı

class _LoginState extends State<Login> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(69, 119, 117, 100),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: const AppDrawer(),
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Color.fromRGBO(49, 112, 117, 100), Colors.grey],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildIcon(),
                const SizedBox(height: 50),
                _buildInputField("Username", _usernameController),
                const SizedBox(height: 20),
                _buildInputField("Password", _passwordController, isPassword: true),
                const SizedBox(height: 50),
                _buildLoginButton(),
                const SizedBox(height: 20),
                _buildExtraText(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() => Container(
    decoration: BoxDecoration(
      border: Border.all(color: Colors.white, width: 2),
      shape: BoxShape.circle,
    ),
    child: const Icon(Icons.person, color: Colors.white, size: 120),
  );

  Widget _buildInputField(String hintText, TextEditingController controller, {bool isPassword = false}) => TextField(
    style: const TextStyle(color: Colors.white),
    controller: controller,
    decoration: InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.white),
      enabledBorder: _inputBorder(),
      focusedBorder: _inputBorder(),
    ),
    obscureText: isPassword,
  );

  OutlineInputBorder _inputBorder() => OutlineInputBorder(
    borderRadius: BorderRadius.circular(18),
    borderSide: const BorderSide(color: Colors.white),
  );

  Widget _buildLoginButton() => ElevatedButton(
    onPressed: () {
      final username = _usernameController.text.trim();
      final password = _passwordController.text.trim();

      if (username.isEmpty || password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Username and password can not be null!")),
        );
        return;
      }

      // Kullanıcı adı kontrolü
      if (_userCredentials.containsKey(username)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('"$username" Entered username is already used. Please choose another username'),
            duration: const Duration(seconds: 2),
          ),
        );
        return;
      }

      // Yeni kullanıcıyı kaydet
      setState(() {
        _userCredentials[username] = password;
      });

      debugPrint("New user added: $username");
      debugPrint("All users: $_userCredentials");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User: "$username" saved succesfully!'),
          duration: const Duration(seconds: 1),
        ),
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Game()),
      );
    },
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.black,
      backgroundColor: Colors.white,
      shape: const StadiumBorder(),
      padding: const EdgeInsets.symmetric(vertical: 16),
    ),
    child: const SizedBox(
      width: double.infinity,
      child: Text("Sign in", textAlign: TextAlign.center, style: TextStyle(fontSize: 20)),
    ),
  );

  Widget _buildExtraText() => const Text(
    "Forgot the password?",
    textAlign: TextAlign.center,
    style: TextStyle(fontSize: 16, color: Colors.white),
  );
}