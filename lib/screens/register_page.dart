import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sloter/screens/app.dart';
import 'package:sloter/screens/profile_page.dart';
import 'package:sloter/utils/validator.dart';

import '../services/fire_auth.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final _registerFormKey = GlobalKey<FormState>();

  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final _focusName = FocusNode();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusName.unfocus();
        _focusEmail.unfocus();
        _focusPassword.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Register'),
        ),
        body: Form(
          key: _registerFormKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nameTextController,
                focusNode: _focusName,
                validator: (value) => Validator.validateName(name: value),
                decoration: InputDecoration(
                  hintText: "Name",
                  errorBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0),
                    borderSide: const BorderSide(
                      color: Colors.red
                    )
                  )
                ),
              ),

              const SizedBox(height: 16.0),

              TextFormField(
                controller: _emailTextController,
                focusNode: _focusEmail,
                validator: (value) => Validator.validateEmail(email: value),
                decoration: InputDecoration(
                    hintText: "Email",
                    errorBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                        borderSide: const BorderSide(
                            color: Colors.red
                        )
                    )
                ),
              ),

              const SizedBox(height: 16.0),

              TextFormField(
                controller: _passwordTextController,
                focusNode: _focusPassword,
                validator: (value) => Validator.validatePassword(password: value),
                decoration: InputDecoration(
                    hintText: "Password",
                    errorBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                        borderSide: const BorderSide(
                            color: Colors.red
                        )
                    )
                ),
              ),

              const SizedBox(height: 32.0),

              _isProcessing
              ? const CircularProgressIndicator()
              : Row(
                children: [
                    Expanded(child: ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          _isProcessing = true;
                        });

                        if (_registerFormKey.currentState!.validate()) {
                          User? user = await FireAuth.register(
                              name: _nameTextController.text,
                              email: _emailTextController.text,
                              password: _passwordTextController.text
                          );

                          setState(() {
                            _isProcessing = false;
                          });

                          if (user != null) {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => App(user: user)),
                              ModalRoute.withName('/')
                            );
                          }
                        }
                      },
                      child: const Text('Sign up', style: TextStyle(color: Colors.white)),
                    ),
                  ),

                ],
              )

            ],
          )
        ),
      )
    );
  }
}

