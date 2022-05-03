import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sloter/screens/login_page.dart';
import 'package:sloter/services/fire_auth.dart';

class ProfilePage extends StatefulWidget {
  final User user;

  const ProfilePage({ required this.user });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  bool _isSendingVerification = false;
  bool _isSigningOut = false;

  late User _currentUser;

  @override
  void initState() {
    _currentUser = widget.user;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'NAME: ${_currentUser.displayName}',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          const SizedBox(height: 16.0),
          Text(
            'EMAIL: ${_currentUser.email}',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          const SizedBox(height: 16.0),

          _currentUser.emailVerified
          ? Text(
            'Email verified',
            style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.green)
          )
          : Text(
            'Email not verified',
            style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.red),
          ),

          const SizedBox(height: 16.0),

          if (!_currentUser.emailVerified) (_isSendingVerification
              ? const CircularProgressIndicator()
              : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      _isSendingVerification = true;
                    });

                    await _currentUser.sendEmailVerification();

                    setState(() {
                      _isSendingVerification = false;
                    });
                  },
                  child: const Text('Verify email')
              ),
              const SizedBox(width: 8.0),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () async {
                  User? user = await FireAuth.refreshUser(_currentUser);

                  if (user != null) {
                    setState(() {
                      _currentUser = user;
                    });
                  }
                },
              )
            ],
          )),

          const SizedBox(height: 16.0),

          _isSigningOut
          ? const CircularProgressIndicator()
          : ElevatedButton(
            onPressed: () async {
              setState(() {
                _isSigningOut = true;
              });

              await FireAuth.signOut();

              setState(() {
                _isSigningOut = false;
              });

              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const LoginPage())
              );
            },
            child: const Text('Sign out'),
            style: ElevatedButton.styleFrom(
              primary: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              )
            )
          )
        ],
      )
    );
  }
}
