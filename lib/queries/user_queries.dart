import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'dart:developer' as developer;

import '../models/user_model.dart';

class UserQueries extends GetxController {
  static UserQueries get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  createUser(UserModel user, String uid) async {
    await _db
        .collection("Users")
        .doc(uid) // use user's Firebase Auth ID
        .set(user.toJson())
        .then((value) => developer.log("Complete"))
        .catchError(
      (error, StackTrace stack) {
        return (error);
      },
    );
  }

  Future<UserModel?> getUser(String? uid) async {
    if (uid == null) {
      return null;
    }
    final doc = await _db.collection("Users").doc(uid).get();

    if (!doc.exists) {
      return null;
    }

    final data = doc.data();
    if (data == null) {
      return null;
    }

    return UserModel.fromJson(data);
  }

  Future<List<UserModel>> getAllUsers() async {
    final QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('Users').get();

    return querySnapshot.docs.map(
      (doc) {
        return UserModel.fromJson(
          {
            ...doc.data() as Map<String, dynamic>,
            'id': doc.id,
          },
        );
      },
    ).toList();
  }
}
