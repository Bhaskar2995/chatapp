import 'dart:io';

import 'package:chat_application/screens/chatScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import './auth.dart';
import '../widgets/image_picker_widget.dart';

class Login extends StatefulWidget {
  Login({super.key});

  @override
  State<Login> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _firebase = FirebaseAuth.instance;

  var _enteredEmail = '';
  var _enteredPassword = '';
  var _enteredConfirmPassword = '';
  File? _selectedimage;
  var isAuthenticating = false;

  void _submit() async {
    final isValid = _formKey.currentState!.validate();

    print(isValid);

    if (_enteredPassword != _enteredConfirmPassword) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('password and confirm password must be same'),
        ),
      );
      return;
    }

    if (!isValid || _selectedimage == null) return;

    _formKey.currentState!.save();
    print(_enteredEmail);
    print(_enteredPassword);

    try {
      setState(() {
        isAuthenticating = true;
      });
      final userCredentials = await _firebase.createUserWithEmailAndPassword(
          email: _enteredEmail, password: _enteredPassword);

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_images')
          .child('${userCredentials.user!.uid}.jpg');

      await storageRef.putFile(_selectedimage!);
      final imageUrl = await storageRef.getDownloadURL();
      print(imageUrl);

      Navigator.pop(
        context,
        MaterialPageRoute(builder: (context) => ChatScreen()),
      );
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message ?? 'Authentication failed')));
    }

    setState(() {
      isAuthenticating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 30,
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
                width: 200,
                child: Image.asset('assets/images/chat.png'),
              ),
              Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        UserImagePicker(onPickimage: (pickedImage) {
                          _selectedimage = pickedImage;
                        }),
                        TextFormField(
                          decoration:
                              const InputDecoration(labelText: "email address"),
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                !value.contains('@')) {
                              return "Please enter a valid email address";
                            }
                          },
                          onSaved: (value) {
                            _enteredEmail = value!;
                          },
                        ),
                        TextFormField(
                          decoration:
                              const InputDecoration(labelText: "Password"),
                          style: const TextStyle(fontSize: 18),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.trim().length < 5) {
                              return "Password should be atleast 5 characters long";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _enteredPassword = value!;
                          },
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                              labelText: "Confirm Password"),
                          style: const TextStyle(fontSize: 18),
                          obscureText: true,
                          onSaved: (value) {
                            _enteredConfirmPassword = value!;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        if (isAuthenticating == false)
                          ElevatedButton(
                            onPressed: _submit,
                            child: const Text('Sign up'),
                          ),
                        if (isAuthenticating == false)
                          InkWell(
                            onTap: () {
                              Navigator.pop(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AuthScreen()),
                              );
                            },
                            child: const Text(
                                'Already have an account ? Login here'),
                          ),
                        if (isAuthenticating == true)
                          CircularProgressIndicator()
                      ]),
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
