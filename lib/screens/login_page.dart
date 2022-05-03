import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sloter/screens/profile_page.dart';
import 'package:sloter/screens/register_page.dart';
import 'package:sloter/services/fire_auth.dart';
import 'package:sloter/utils/validator.dart';
import '../firebase_options.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {


  Future<Type> _initializeFirebase() async {
    // Initialisation firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => ProfilePage(
          user: user
        ))
      );
    }

    return FirebaseApp;
  }

  @override
  Widget build(BuildContext context) {

    final _formKey = GlobalKey<FormState>();

    final _emailTextController = TextEditingController();
    final _passwordTextController = TextEditingController();

    final _focusEmail = FocusNode();
    final _focusPassword = FocusNode();

    bool _isProcessing = false;

    return GestureDetector(
      onTap: () {
        _focusEmail.unfocus();
        _focusPassword.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: FutureBuilder(
          future: _initializeFirebase(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {

              return Form(
                key: _formKey,

                child: Column(
                  children: <Widget>[
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

                    const SizedBox(height: 8.0),

                    TextFormField(
                      controller: _passwordTextController,
                      focusNode: _focusPassword,
                      obscureText: true,
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

                    const SizedBox(height: 24.0),

                    _isProcessing
                    ? const CircularProgressIndicator()
                    : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              _focusEmail.unfocus();
                              _focusPassword.unfocus();

                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  _isProcessing = true;
                                });


                                User? user = await FireAuth.signIn(
                                    email: _emailTextController.text,
                                    password: _passwordTextController.text,
                                );

                                setState(() {
                                  _isProcessing = false;
                                });

                                if (user != null) {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => ProfilePage(user: user)
                                    )
                                  );
                                }

                              }
                            },
                            child: const Text('Sign In', style: TextStyle(color: Colors.white)),
                          )
                        ),

                        const SizedBox(width: 24.0),

                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (context) => const RegisterPage())
                              );
                            },
                            child: const Text('Register', style: TextStyle(color: Colors.white)),
                          )
                        )

                      ],
                    )
                  ],
                )

              );

            }

            return const Center(
              child: CircularProgressIndicator()
            );
          },
        ),
      )
    );

  }



}

