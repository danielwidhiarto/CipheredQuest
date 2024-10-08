import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ciphered_quest/pages/login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String _errorMessage = ''; // Error message state

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  }

  void _registerUser() async {
    final email = _emailController.text.trim();
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (email.isEmpty || username.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      setState(() {
        _errorMessage = "Please fill in all fields.";
      });
      return;
    }

    if (password != confirmPassword) {
      setState(() {
        _errorMessage = "Passwords do not match. Please try again.";
      });
      return;
    }

    try {
      // Check if email or username already exists
      final userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        setState(() {
          _errorMessage = "Email already exists. Please try a different one.";
        });
        return;
      }

      final usernameSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: username)
          .get();

      if (usernameSnapshot.docs.isNotEmpty) {
        setState(() {
          _errorMessage = "Username already exists. Please try a different one.";
        });
        return;
      }

      // Register user with Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Add user to Firestore database
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'username': username,
        'createdAt': Timestamp.now(),
      });

      // Send email verification link
      await userCredential.user!.sendEmailVerification();

      // Show success dialog
      _showSuccessDialog("Registration successful! Please check your email to verify your account.");
    } catch (e) {
      String errorMessage;
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'email-already-in-use':
            errorMessage = 'This email is already in use. Please use a different one.';
            break;
          case 'weak-password':
            errorMessage = 'Your password is too weak. Please choose a stronger one.';
            break;
          case 'invalid-email':
            errorMessage = 'Invalid email format. Please enter a valid email.';
            break;
          default:
            errorMessage = 'Registration failed. Please try again later.';
        }
      } else {
        errorMessage = 'An unknown error occurred. Please try again.';
      }

      setState(() {
        _errorMessage = errorMessage; // Display user-friendly error message
      });
    }
  }

  // Helper function to show success dialog
  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Registration Successful'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
      textStyle: const TextStyle(fontSize: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );

    return Scaffold(
        backgroundColor: const Color(0xFFB0A695),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/logo/png/logo-no-background.png',
            height: 250,
            width: 250,
          ),
          const SizedBox(height: 8),

          TextField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 16),

          TextField(
            controller: _usernameController,
            decoration: const InputDecoration(
              labelText: 'Username',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 16),

          TextField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              labelText: 'Password',
              border: const OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: _togglePasswordVisibility,
              ),
            ),
          ),
          const SizedBox(height: 16),

          TextField(
            controller: _confirmPasswordController,
            obscureText: _obscureConfirmPassword,
            decoration: InputDecoration(
              labelText: 'Confirm Password',
              border: const OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: _toggleConfirmPasswordVisibility,
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Display error message if exists
          if (_errorMessage.isNotEmpty)
            Text(
              _errorMessage,
              style: const TextStyle(color: Colors.red, fontSize: 14),
            ),
          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: _registerUser,
            style: buttonStyle.copyWith(
              backgroundColor: MaterialStateProperty.all(const Color(0xFF776B5D)),
            ),
            child: const Text(
              'Register',
              style: TextStyle(
                color: Color(0xFFF3EEEA),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 24),

          ElevatedButton.icon(
            icon: const Icon(Icons.g_mobiledata, size: 24, color: Color(0xFFF3EEEA)),
            label: const Text(
              'Sign Up with Google',
              style: TextStyle(
                color: Color(0xFFF3EEEA),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: buttonStyle.copyWith(
              backgroundColor: MaterialStateProperty.all(const Color(0xFF776B5D)),
            ),
            onPressed: () {
              // Implement Google sign up logic here
            },
          ),
          const SizedBox(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                "Already have an account? ",
                style: TextStyle(
                  color: Color(0xFFF3EEEA),
                  fontSize: 16,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                child: const Text(
                  "Login Here!",
                  style: TextStyle(
                    color: Color(0xFFF3EEEA),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
    );
  }
}

