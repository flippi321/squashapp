import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:squashmate/models/match_model.dart';
import 'package:squashmate/queries/match_queries.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final MatchQueries _query = MatchQueries();

  // Create a stream for the auth state
  Stream<User?> get user => _auth.authStateChanges();

  Future<String?> createMatch(MatchModel match) async {
    try {
      // Try to save user data on FlutterFire database
      await _query.createMatch(match, _auth.currentUser!.uid);

      // Return null (success)
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}