// lib/pages/login/sign_up_page.dart
import 'package:flutter/material.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import 'package:sns_pocketbase_app/config/app_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sns_pocketbase_app/pages/feed/feed_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _nameController = TextEditingController();
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();

  Future<void> signUpUser() async {
    if (_emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _usernameController.text.isEmpty ||
        _nameController.text.isEmpty) {
      _btnController.error();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      await Future.delayed(const Duration(seconds: 1));
      _btnController.reset();
      return;
    }

    try {
      // In demo mode, simulate user creation
      await Future.delayed(const Duration(seconds: 1));

      if (AppConfig.isDemoMode) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', _emailController.text);
        await prefs.setString('userId', '2'); // Demo user ID

        _btnController.success();
        await Future.delayed(const Duration(seconds: 1));

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => FeedPage(
                userId: '2',
                email: _emailController.text,
                onLogout: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.clear();
                },
              ),
            ),
          );
        }
      }
    } catch (e) {
      _btnController.error();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
      await Future.delayed(const Duration(seconds: 1));
      _btnController.reset();
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            RoundedLoadingButton(
              controller: _btnController,
              onPressed: signUpUser,
              child: const Text('Sign Up', style: TextStyle(color: Colors.white)),
            ),
            if (AppConfig.isDemoMode) ...[
              const SizedBox(height: 24),
              const Text(
                'Demo Mode: Account will be created locally',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
