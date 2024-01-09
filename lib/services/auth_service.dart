import 'dart:convert';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'dart:developer' as developer;

class AuthService extends ChangeNotifier {
  UserModel? currentUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserQueries _query = UserQueries();

  // Create a stream for the auth state
  Stream<User?> get user => _auth.authStateChanges();

  Future<String?> registerWithEmailAndPassword(String email, String password,
      String confirmPassword, UserModel user) async {
    try {
      // Try to create a user with the email and password
      await _auth.createUserWithEmailAndPassword(
        email: email.trim().toLowerCase(),
        password: password.trim(),
      );

      // Try to save user data on FlutterFire database
      await _query.createUser(user, _auth.currentUser!.uid);

      // Fetch and store user data
      // TODO Check for redundancy
      await fetchAndStoreUserData(_auth.currentUser);

      // Save the user locally
      saveUserLocally(currentUser!);

      // Return null (success)
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim().toLowerCase(),
        password: password.trim(),
      );

      // Fetch and store user data
      await fetchAndStoreUserData(_auth.currentUser);

      // Save the user locally
      saveUserLocally(currentUser!);

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  /// Getter for all users
  ///
  /// ADMIN TOOLS
  Future<List<UserModel>?> getAllUsers() async {
    try {
      UserModel? user = await _query.getUser(_auth.currentUser!.uid);
      if (user!.roles!.contains("admin")) {
        return _query.getAllUsers();
      } else {
        return null;
      }
    } catch (e) {
      return [];
    }
  }

  Stream<List<UserModel>?> getAllUsersStream() {
    try {
      return _query.getAllUsersStream();
    } catch (e) {
      rethrow;
    }
  }

  /// DELETE SPECIFIC USER
  ///
  /// ADMIN TOOLS
  Future<HttpsCallableResult> deleteUser(String uid) async {
    try {
      final result = await FirebaseFunctions.instanceFor(region: 'europe-west1')
          .httpsCallable('deleteUser')
          .call(
        {
          "uid": uid,
        },
      );
      return result;
    } on FirebaseFunctionsException catch (error) {
      developer.log(error.code);
      developer.log(error.message.toString());
      rethrow;
    }
  }

  /// MAKE USER HEAD INSTRUCTOR
  ///
  /// ADMIN TOOLS
  Future<HttpsCallableResult> addHeadInstructor(String uid) async {
    try {
      final result = await FirebaseFunctions.instanceFor(region: 'europe-west1')
          .httpsCallable('addHeadInstructor')
          .call(
        {
          "uid": uid,
        },
      );
      return result;
    } on FirebaseFunctionsException catch (error) {
      developer.log(error.code);
      developer.log(error.message.toString());
      rethrow;
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

  Future<void> saveUserLocally(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('user', jsonEncode(user.toJson()));
  }

  Future<UserModel?> getLocalUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? userString = prefs.getString('user');

    if (userString != null) {
      try {
        Map userMap = jsonDecode(userString);
        return UserModel.fromJson(userMap);
      } catch (e) {
        developer.log('error parsing json: $e');
      }
      notifyListeners();
    }
    return null;
  }

  Future<void> updateUser(UserModel user) async {
    try {
      await _query.updateUser(user);
    } catch (e) {
      developer.log(e.toString());
    }
  }

  String getUserId() {
    return _auth.currentUser!.uid;
  }

  Stream<UserModel?> getUserStream(String uid) {
    return _query.getUserSnapshot(uid);
  }

  String getHighestRole(UserModel user) {
  if (user.roles!.contains("admin")) {
    return "Admin";
  } 
  else if (user.roles!.contains("headInstructor")) {
    return "Hovedinstruktør";
  } else if (user.roles!.contains("instructor")) {
    return "Instruktør";
  } else {
    return "Ingen";
  }
}
}