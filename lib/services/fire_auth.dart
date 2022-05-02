import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:sloter/utils/Error.dart';

class FireAuth {

  static Future<User?> register({ required String name, required String email, required String password }) async {

    FirebaseAuth auth = FirebaseAuth.instance;

    User? user;

    try {

      UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: email, password: password);

      user = userCredential.user;

      await user!.updateDisplayName(name);
      await user.reload();
      user = auth.currentUser;

    } on FirebaseAuthException catch(e) {
      Error.handleRegister(e);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    return user;

  }

  static Future<User?> signIn({ required String email, required String password }) async {

    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {

      UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
      user = userCredential.user;

    } on FirebaseAuthException catch (e) {
      Error.handleSignIn(e);
    }

    return user;

  }

  static signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  static Future<User?> refreshUser(User user) async {

    FirebaseAuth auth = FirebaseAuth.instance;

    await user.reload();
    User? refreshedUser = auth.currentUser;

    return refreshedUser;

  }

}