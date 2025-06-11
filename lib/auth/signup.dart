import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kopiradar/auth/login.dart';
import 'package:kopiradar/pages/home_page.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  bool _isLoading = false;

  void signUp() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (password != confirmPassword) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
        'phone': phone,
        'createdAt': Timestamp.now(),
      });

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
      );
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Registration failed')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        setState(() => _isLoading = false);
        return; // User canceled
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        final userDoc = await _firestore
            .collection('users')
            .doc(user.uid)
            .get();
        if (!userDoc.exists) {
          await _firestore.collection('users').doc(user.uid).set({
            'name': user.displayName ?? '',
            'email': user.email ?? '',
            'phone': user.phoneNumber ?? '',
            'createdAt': Timestamp.now(),
          });
        }

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } catch (e) {
      debugPrint('Google Sign-In failed: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Google Sign-In failed')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo.png', width: 120),
              const SizedBox(height: 20),
              const Text(
                'Sign Up',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 24),

              TextField(
                controller: _nameController,
                decoration: _inputDecoration('Name'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                decoration: _inputDecoration('Email'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: _inputDecoration(
                  'Phone Number',
                ).copyWith(prefixText: '+62  '),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: _inputDecoration('Password'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: _inputDecoration('Confirm Password'),
              ),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : signUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB85C38),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Sign Up',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                ),
              ),
              const SizedBox(height: 16),

              const Text('Or sign up with'),
              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  icon: Image.asset(
                    'assets/images/google_logo.png',
                    width: 24,
                    height: 24,
                  ),
                  label: const Text(
                    'Continue with Google',
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Colors.grey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _isLoading ? null : _signInWithGoogle,
                ),
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? "),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const Login()),
                      );
                    },
                    child: const Text(
                      'Sign In',
                      style: TextStyle(color: Color(0xFFB85C38)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}
