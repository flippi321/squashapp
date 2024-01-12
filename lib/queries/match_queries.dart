import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:squashmate/models/match_model.dart';
import 'dart:developer' as developer;

class MatchQueries extends GetxController {
  static MatchQueries get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  createMatch(MatchModel match, String uid) async {
    await _db
        .collection("Matches")
        .doc(uid) // use user's Firebase Auth ID
        .set(match.toJson())
        .then((value) => developer.log("Complete"))
        .catchError(
      (error, StackTrace stack) {
        return (error);
      },
    );
  }
}
