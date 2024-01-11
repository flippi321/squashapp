import 'package:flutter/material.dart';
import 'package:squashmate/screens/homepage.dart';
import 'package:squashmate/screens/user_registration/registerpage.dart';
import 'package:squashmate/services/auth_service.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _errorMessage = ''; // To store and display error messages

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_errorMessage.isNotEmpty)
                Column(
                  children: [
                    Text(
                      _errorMessage,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                    ),
                    const SizedBox(height: 16.0),
                  ],
                ),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  // Check if email or password is empty
                  if (hasEmptyCridentials()) {
                    showError('Email and password are required.');
                  } else {
                    // Reset error message
                    showError('');

                    // Login user
                    if (_formKey.currentState!.validate()) {
                      final authService = context.read<AuthService>();
                      final errorMessage = await authService.signInUser(
                          _emailController.text, _passwordController.text);
                      if (errorMessage != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(errorMessage)),
                        );
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                        );
                      }
                    }
                  }
                },
                child: const Text('Login'),
              ),
              const SizedBox(height: 8.0),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegisterPage()),
                  );
                },
                child: const Text("No user? Create one here!"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to set and display error messages
  void showError(String message) {
    setState(() {
      _errorMessage = message;
    });
  }

  bool hasEmptyCridentials() {
    return (_emailController.text.isEmpty || _passwordController.text.isEmpty);
  }
}
