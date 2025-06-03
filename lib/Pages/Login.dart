import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'EditProfilePage.dart';
import '../Widgets/BasePage.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _rememberMe = false;
  bool _obscurePassword = true; // Şifreyi gizle/göster

  final String _testEmail = "testuser@demo.com";
  final String _testPassword = "Test123456!";

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadSavedEmail();
  }

  // SharedPreferences'tan email ve remember me bilgisini yükle
  void _loadSavedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('saved_email');
    final remember = prefs.getBool('remember_me') ?? false;

    if (remember && savedEmail != null) {
      setState(() {
        _emailController.text = savedEmail;
        _rememberMe = remember;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: "Login Page",
      child: Container(
        color: Colors.grey[900], // Daha soft koyu arka plan
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Welcome Back",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildIcon(),
                const SizedBox(height: 50),
                _buildEmailField(),
                const SizedBox(height: 20),
                _buildPasswordField(),
                const SizedBox(height: 30),
                _buildLoginButton(),
                const SizedBox(height: 15),
                _buildGoogleButton(),
                const SizedBox(height: 15), // Daha fazla boşluk
                _buildGitHubButton(),
                const SizedBox(height: 20),
                _buildForgotPassword(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (val) {
                        setState(() {
                          _rememberMe = val ?? false;
                        });
                      },
                      activeColor: Colors.tealAccent,
                      checkColor: Colors.black,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Remember Me",
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ],
                ),
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

  Widget _buildEmailField() => TextField(
    controller: _emailController,
    keyboardType: TextInputType.emailAddress,
    style: const TextStyle(color: Colors.white),
    decoration: InputDecoration(
      hintText: "Email",
      hintStyle: const TextStyle(color: Colors.white54),
      prefixIcon: const Icon(Icons.email, color: Colors.white54),
      enabledBorder: _inputBorder(),
      focusedBorder: _inputBorder(color: Colors.tealAccent),
    ),
  );

  Widget _buildPasswordField() => TextField(
    controller: _passwordController,
    obscureText: _obscurePassword,
    style: const TextStyle(color: Colors.white),
    decoration: InputDecoration(
      hintText: "Password",
      hintStyle: const TextStyle(color: Colors.white54),
      prefixIcon: const Icon(Icons.lock, color: Colors.white54),
      suffixIcon: IconButton(
        icon: Icon(
          _obscurePassword ? Icons.visibility_off : Icons.visibility,
          color: Colors.white54,
        ),
        onPressed: () {
          setState(() {
            _obscurePassword = !_obscurePassword;
          });
        },
      ),
      enabledBorder: _inputBorder(),
      focusedBorder: _inputBorder(color: Colors.tealAccent),
    ),
  );

  OutlineInputBorder _inputBorder({Color color = Colors.white}) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(18),
    borderSide: BorderSide(color: color),
  );

  Widget _buildLoginButton() => ElevatedButton(
    onPressed: _isLoading ? null : _signInWithEmail,
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.black,
      backgroundColor: Colors.tealAccent.shade700,
      shape: const StadiumBorder(),
      padding: const EdgeInsets.symmetric(vertical: 16),
      minimumSize: const Size(double.infinity, 50),
      elevation: 6,
    ),
    child: _isLoading
        ? const SizedBox(
      width: 24,
      height: 24,
      child: CircularProgressIndicator(color: Colors.black, strokeWidth: 3),
    )
        : const Text("Sign In", style: TextStyle(fontSize: 20)),
  );

  Widget _buildGoogleButton() => ElevatedButton.icon(
    onPressed: _isLoading ? null : () => _signInWithGoogle(context),
    icon: const Icon(Icons.login, color: Colors.white), // Google ikonu yok, default login kullandım
    label: const Text("Sign in with Google", style: TextStyle(color: Colors.white)),
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.redAccent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      padding: const EdgeInsets.symmetric(vertical: 14),
      minimumSize: const Size(double.infinity, 50),
      elevation: 4,
    ),
  );

  Widget _buildGitHubButton() => ElevatedButton.icon(
    onPressed: _isLoading ? null : _signInWithGitHub,
    icon: const Icon(Icons.code, color: Colors.white), // GitHub için kod ikonu
    label: const Text("Sign in with GitHub", style: TextStyle(color: Colors.white)),
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.black87,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      padding: const EdgeInsets.symmetric(vertical: 14),
      minimumSize: const Size(double.infinity, 50),
      elevation: 4,
    ),
  );

  Widget _buildForgotPassword() => TextButton(
    onPressed: _isLoading ? null : _resetPassword,
    child: const Text("Forgot password?", style: TextStyle(color: Colors.white54)),
  );

  Future<void> _signInWithEmail() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showError("Please enter both email and password");
      return;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      _showError("Please enter a valid email address");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        final prefs = await SharedPreferences.getInstance();
        if (_rememberMe) {
          await prefs.setString('saved_email', email);
          await prefs.setBool('remember_me', true);
        } else {
          await prefs.remove('saved_email');
          await prefs.setBool('remember_me', false);
        }
        _navigateToProfile();
      } else {
        _showError("Authentication failed");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password' || e.code == 'user-not-found') {
        _showError("Incorrect email or password");
      } else if (e.code == 'invalid-email') {
        _showError("Invalid email format");
      } else if (e.code == 'user-disabled') {
        _showError("This account has been disabled");
      } else {
        _showError("Login failed: ${e.message}");
      }
    } catch (e) {
      _showError("An unexpected error occurred");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    setState(() => _isLoading = true);

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        // Kullanıcı iptal etti, loading kapat
        if (mounted) setState(() => _isLoading = false);
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.user != null) {
        _navigateToProfile();
      }
    } catch (e) {
      _showError("Google sign in failed: ${e.toString()}");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithGitHub() async {
    setState(() => _isLoading = true);

    try {
      final AuthProvider githubProvider = GithubAuthProvider();

      UserCredential userCredential;
      if (kIsWeb) {
        userCredential = await FirebaseAuth.instance.signInWithPopup(githubProvider);
      } else {
        userCredential = await FirebaseAuth.instance.signInWithProvider(githubProvider);
      }

      if (userCredential.user != null) {
        _navigateToProfile();
      }
    } on FirebaseAuthException catch (e) {
      _showError("GitHub login failed: ${e.message ?? 'Unknown error'}");
    } catch (e) {
      _showError("Failed to sign in with GitHub");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  void _navigateToProfile() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const EditProfilePage()),
    );
  }

  // Şifre sıfırlama fonksiyonu geliştirilmiş hali
  void _resetPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      _showError("Please enter your email to reset password.");
      return;
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password reset email sent."),
          backgroundColor: Colors.green,
        ),
      );
    } on FirebaseAuthException catch (e) {
      _showError("Failed to send reset email: ${e.message}");
    }
  }
}
