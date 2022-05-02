

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class Error {

  static void handle(Map<String, String> tab, FirebaseAuthException e) {

    if (tab.containsKey(e.code)) {
      if (kDebugMode) {
        print(tab[e.code]);
      }

      return;
    }

    if (kDebugMode) {
      print("[!] Unhandled error : [" + e.code + "]" + e.message.toString());
    }

  }

  static void handleRegister(FirebaseAuthException e) {

    final errors = <String, String>{
      'weak-password' : 'Password too weak',
      'email-alread-in-use' : 'Email already used',
    };

    handle(errors, e);

  }

  static void handleSignIn(FirebaseAuthException e) {

    final errors = <String, String>{
      'user-not-found' : 'No user found',
      'wrong-password' : 'Incorrect password',
    };

    handle(errors, e);

  }

}