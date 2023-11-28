import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:users_chat_flutter/services/auth_service.dart';
import 'package:users_chat_flutter/widgets/user_image_picker.dart';

class AuthScreens extends StatefulWidget {
  const AuthScreens({super.key});

  @override
  State<AuthScreens> createState() => _AuthScreensState();
}

class _AuthScreensState extends State<AuthScreens> {
  final auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  File? _selectedImage;
  var _isLogin = true;
  var _isAuthenticating = false;

  @override
  Widget build(BuildContext context) {
    final emailFormField = TextFormField(
      decoration: const InputDecoration(
        labelText: 'Email',
      ),
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      textCapitalization: TextCapitalization.none,
      controller: _emailController,
      validator: (value) {
        if (value == null || value.trim().isEmpty || !value.contains('@')) {
          return 'Please enter a valid email address';
        }
        return null;
      },
    );

    final usernameFormField = TextFormField(
      decoration: const InputDecoration(
        labelText: 'Username',
      ),
      enableSuggestions: false,
      controller: _usernameController,
      validator: (value) {
        if (value == null || value.trim().length < 4) {
          return 'Please enter a valid username';
        }
        return null;
      },
    );

    final passwordFormField = TextFormField(
      decoration: const InputDecoration(
        labelText: 'Password',
      ),
      obscureText: true,
      controller: _passwordController,
      validator: (value) {
        if (value == null || value.trim().length < 6) {
          return 'Password must be at least 6 characters long';
        }
        return null;
      },
    );

    final signInCreateEmailPassword = ElevatedButton(
      onPressed: () async {
        try {
          setState(() {
            _isAuthenticating = true;
          });
          if (_formKey.currentState!.validate()) {
            _isLogin
                ? await auth.signInEmailPassword(
                    email: _emailController.text,
                    password: _passwordController.text,
                  )
                : await auth.createEmailPassword(
                    email: _emailController.text,
                    username: _usernameController.text,
                    password: _passwordController.text,
                    image: _selectedImage,
                  );
          }
        } on FirebaseAuthException catch (e) {
          setState(() => _isAuthenticating = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.message!),
            ),
          );
        } catch (e) {
          setState(() => _isAuthenticating = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Authentication failed'),
            ),
          );
        }
      },
      child: _isLogin ? const Text('Login') : const Text('Register'),
    );

    final toggleButton = TextButton(
      onPressed: () {
        setState(() {
          _isLogin = !_isLogin;
        });
      },
      child: Text(
        _isLogin ? 'Create an account' : 'I have an account',
      ),
    );

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(25),
                width: 200,
                child: Image.asset('assets/images/chat.png'),
              ),
              Card(
                margin: const EdgeInsets.all(25),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(25),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!_isLogin)
                            UserImagePicker(
                              onPickImage: (pickedImage) {
                                _selectedImage = pickedImage;
                              },
                            ),
                          emailFormField,
                          if (!_isLogin) usernameFormField,
                          passwordFormField,
                          const SizedBox(height: 12),
                          if (_isAuthenticating)
                            const CircularProgressIndicator(),
                          if (!_isAuthenticating) signInCreateEmailPassword,
                          if (!_isAuthenticating) toggleButton
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
