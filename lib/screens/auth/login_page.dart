import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wheelbase/provider/auth_provider.dart';
import 'package:wheelbase/screens/auth/signup_page.dart';
import 'package:wheelbase/screens/home/home_screen.dart';
import 'package:wheelbase/themes/app-1/buttons.dart';
import 'package:wheelbase/themes/app-1/inputs.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _loading = false;
  String? _errorMessage;

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    final authProvider = context.read<AuthProvider>();

    final error = await authProvider.login(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    if (error == null) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Login successful!")));

      // Navigate to HomePage and remove previous routes
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
        (route) => false,
      );
    } else {
      setState(() {
        _errorMessage = error;
      });
    }

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              AppInputForm(
                controller: _emailController,
                validator: (val) => val == null || !val.contains("@")
                    ? "Enter a valid email"
                    : null,
                hint: 'Email',
              ),
              SizedBox(height: 20),
              AppInputForm(
                controller: _passwordController,
                validator: (val) =>
                    val == null || val.length < 6 ? "Password too short" : null,
                hint: 'Password',
                isPassword: true,
              ),
              const SizedBox(height: 20),
              if (_errorMessage != null)
                Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 20),
if (_errorMessage != null)
  Text(
    _errorMessage!,
    style: const TextStyle(color: Colors.red),
  ),
const SizedBox(height: 20),
AppButton(
  onPressed: _loading ? null : () => _handleLogin(),
  label: 'Login',
),
const SizedBox(height: 20),
Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    const Text("Don't have an account?"),
    TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SignupScreen()),
        );
      },
      child: const Text("Sign Up"),
    ),
  ],
),

            ],
          ),
        ),
      ),
    );
  }
}
