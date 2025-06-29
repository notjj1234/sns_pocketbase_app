// lib/pages/login/login_page.dart
import 'package:flutter/material.dart';
import 'package:sns_pocketbase_app/pages/feed/feed_page.dart';
import 'package:sns_pocketbase_app/pages/login/sign_up_page.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sns_pocketbase_app/config/app_config.dart';

class LoginPage extends StatefulWidget {
  final String? email;
  final String? password;

  const LoginPage({super.key, this.email, this.password});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _rememberMe = false;
  bool _isLoggingIn = false;
  bool _showPassword = false;
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.email?.trim() ?? "demo@example.com");
    _passwordController = TextEditingController(text: widget.password?.trim() ?? "demo123");
    _loadRememberedCredentials();
  }

  Future<void> _loadRememberedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberedEmail = prefs.getString('email');
    final rememberedPassword = prefs.getString('password');
    final rememberMe = prefs.getBool('rememberMe') ?? false;

    if (rememberMe && rememberedEmail != null && rememberedPassword != null) {
      if (mounted) {
        setState(() {
          _emailController.text = rememberedEmail;
          _passwordController.text = rememberedPassword;
          _rememberMe = rememberMe;
        });
      }
      // Automatically attempt to log in the user if "Remember Me" is selected
      await _autoLogin(rememberedEmail, rememberedPassword);
    }
  }

  Future<void> _autoLogin(String email, String password) async {
    if (!mounted) return;
    await _login(email, password);
  }

  Future<void> _login(String email, String password) async {
    if (_isLoggingIn) return;

    setState(() {
      _isLoggingIn = true;
    });

    try {
      // In demo mode, accept any valid-looking email and password
      if (AppConfig.isDemoMode && email.contains('@') && password.length >= 6) {
        final prefs = await SharedPreferences.getInstance();
        if (_rememberMe) {
          await prefs.setString('email', email);
          await prefs.setString('password', password);
          await prefs.setBool('rememberMe', true);
          await prefs.setString('userId', '1'); // Demo user ID
        } else {
          await prefs.remove('email');
          await prefs.remove('password');
          await prefs.setBool('rememberMe', false);
        }

        if (mounted) {
          _btnController.success();
          await Future.delayed(const Duration(seconds: 1));
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => FeedPage(
                userId: '1',
                email: email,
                onLogout: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.clear();
                  if (mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  }
                },
              ),
            ),
          );
        }
      } else {
        throw Exception('Invalid email or password');
      }
    } catch (e) {
      if (mounted) {
        _btnController.error();
        await Future.delayed(const Duration(seconds: 1));
        _btnController.reset();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoggingIn = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const FlutterLogo(size: 100),
              const SizedBox(height: 48),
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
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _showPassword ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _showPassword = !_showPassword;
                      });
                    },
                  ),
                ),
                obscureText: !_showPassword,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (bool? value) {
                      setState(() {
                        _rememberMe = value ?? false;
                      });
                    },
                  ),
                  const Text('Remember me'),
                ],
              ),
              const SizedBox(height: 24),
              RoundedLoadingButton(
                controller: _btnController,
                onPressed: () => _login(_emailController.text, _passwordController.text),
                child: const Text('Login', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUpPage()),
                  );
                },
                child: const Text('Create Account'),
              ),
              if (AppConfig.isDemoMode) ...[
                const SizedBox(height: 24),
                const Text(
                  'Demo Mode: Use any valid email and password (6+ chars)',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
