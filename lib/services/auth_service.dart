import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:squashmate/queries/user_queries.dart';
import 'package:squashmate/models/user_model.dart';

class AuthService extends ChangeNotifier {
  UserModel? currentUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserQueries _query = UserQueries();

  // Create a stream for the auth state
  Stream<User?> get user => _auth.authStateChanges();

  Future<String?> registerUser(String username, String password, UserModel user) async {
    try {
      // Try to create a user with the email and password
      await _auth.createUserWithEmailAndPassword(
        email: username.trim().toLowerCase(),
        password: password.trim(),
      );

      // Try to save user data on FlutterFire database
      await _query.createUser(user, _auth.currentUser!.uid);

      // Fetch and store user data
      await fetchAndStoreUserData(_auth.currentUser);

      // Return null (success)
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String?> signInUser(
      String username, String password) async {
    try {
      // Yeah I know this is a shit solution, bo wamp
      await _auth.signInWithEmailAndPassword(
        email: username.trim().toLowerCase(),
        password: password.trim(),
      );

      // Fetch and store user data
      await fetchAndStoreUserData(_auth.currentUser);

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> fetchAndStoreUserData(User? user) async {
    if (user != null && user.email != null) {
      currentUser = await _query.getUser(user.uid);
    } else {
      currentUser = null;
    }
    notifyListeners();
  }

  Future<void> signOut() async {
    await _auth.signOut();
    currentUser = null;
    notifyListeners();
  }

  String getUserId() {
    return _auth.currentUser!.uid;
  }
}