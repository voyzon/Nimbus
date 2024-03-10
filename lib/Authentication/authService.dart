import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import '../models/user.dart' as Model;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
  final logger = Logger();

  Future<Model.User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential authResult = await _auth.signInWithCredential(credential);
      final User? user = authResult.user;

      final Model.User modelUser = Model.User(
        createdAt: DateTime.now(),
        email: user!.email!,
        dailyLimit: 10,
        uid: user.uid,
        username: user.displayName!,
      );
      await addUser(modelUser);
      return modelUser;
    } catch (e) {
      logger.e("Error signing in with Google: $e");
      return null;
    }
  }

  Future<Model.User?> getCurrentUser() async {
    final User? user = _auth.currentUser;
    // Add user to firestore if not exists
    final firestoreUser = await users.doc(user!.uid).get();
    if (!firestoreUser.exists) {
      final Model.User modelUser = Model.User(
        createdAt: DateTime.now(),
        email: user.email!,
        dailyLimit: 10,
        uid: user.uid,
        username: user.displayName!,
      );
      await addUser(modelUser);
      return modelUser;
    }
    return Model.User.fromJson(firestoreUser.data()! as Map<String, dynamic>);
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      await GoogleSignIn().signOut();
      Navigator.of(context).pushReplacementNamed('/');
    } catch (e) {
      logger.e("Error singing out: $e");
    }
  }

  Future<void> addUser(Model.User user) {
    try {
      return users.doc(user.uid).set(user.toJson());
    } catch (error) {
      logger.e("Failed to add user: $error");
      return Future.error(error);
    }
    // .catchError((error) => logger.e("Failed to add user: $error"));
  }
}
