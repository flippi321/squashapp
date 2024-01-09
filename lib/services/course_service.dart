import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nls_app/models/course_info_model.dart';
import 'package:nls_app/models/course_model.dart';
import 'package:nls_app/models/course_type_model.dart';
import 'package:nls_app/models/lifesaving_competence_model.dart';
import 'package:nls_app/models/seminar_model.dart';
import 'package:nls_app/queries/course_queries.dart';
import 'dart:developer' as developer;

class CourseService extends ChangeNotifier {
  final _query = CourseQueries();
  final _auth = FirebaseAuth.instance;

  /// Method for registering and creating a course
  Future<String?> registerAndCreateCourse(CourseModel course) async {
    try {
      if (!(await checkCourseCode(course.courseCode))) {
        await _query.saveCourseModelToFirestore(course);

        /// Save the course model to Firestore
        return null;
      }
      return "Kurskode i bruk";

      /// Return null if successful (no error)
    } catch (e) {
      return e.toString();

      /// Return the error message as a string if an exception occurs
    }
  }

  /// Method for saving a Seminar
  Future<String?> registerAndCreateSeminar(SeminarModel seminar) async {
    try {
      if (!(await checkCourseCode(seminar.seminarCode))) {
        await _query.saveSeminarToFirestore(seminar);

        return null;
      }
      return "Kurskode i bruk";
    } catch (e) {
      return e.toString();
    }
  }

  /// Adds lifesaving competence to user for specific course
  ///
  /// Example:
  /// await CourseService.addUserToLifesavingCourse("EYRPB", CourseService.getConfirmationsForCourse("EYRPB")[0].attendantId, competence);
  Future<bool> addUserToLifesavingCourse(String courseCode, String uid,
      LifesavingCompetenceModel competence) async {
    try {
      await _query.addLifesavingCompetence(courseCode, uid, competence);
      await _query.addUserToCourse(uid, courseCode);
      return true;
    } catch (e) {
      developer.log(e.toString());
    }
    return false;
  }

  /// Method for retrieving lifesaving competence of current user
  ///
  /// Example:
  /// _service.getUserCompetence("EYRPB");
  Future<LifesavingCompetenceModel?> getUserCompetence(
      String courseCode) async {
    try {
      return await _query.getLifesavingCompetence(
          courseCode, _auth.currentUser!.uid);
    } catch (e) {
      developer.log(e.toString());
    }
    return null;
  }

  Future<bool> getIsOutside(String courseCode) async {
    try {
      return await _query.getIsOutside(courseCode);
    } catch (e) {
      rethrow;
    }
  }

  /// Method for retrieving course information
  Future<CourseInfo> getCourseInfo(String infoCode) async {
    try {
      return _query.getCourseInfo(infoCode);
    } catch (e) {
      CourseInfo wrongInfo = const CourseInfo(
          description:
              "Fant ikke beskrivelse av dette kurset, prøv å åpne siden på nytt eller oppdater appen.",
          headline: "",
          imageLink:
              "https://firebasestorage.googleapis.com/v0/b/nls-app-course-images/o/e66b67_816239b0c3124b4281f32bb1ba740a1f~mv2.webp?alt=media&token=372fe3b8-8058-4089-8a78-4e9cfacba1f4",
          subDescription: "");
      return wrongInfo;
    }
  }

  /// Method for retrieving user courses
  Stream<List<CourseModel>> getUserCourses() {
    try {
      return _query.getCoursesFromFireStore(_auth.currentUser!.uid);
    } catch (e) {
      rethrow;
    }
  }

  /// Get all course confirmation requests for current user
  ///
  /// Example:
  /// _courseService.getRequests();
  Stream<List<Map<String, dynamic>>> getRequests() {
    try {
      return _query.getAllConfirmationsByCreator(_auth.currentUser!.uid);
    } catch (e) {
      rethrow;
    }
  }

  /// Retrieves all courses made by currentUser
  ///
  /// Example:
  /// List<CourseModel> = await getInstructorCourses();
  Future<List<CourseModel>> getInstructorCourses() async {
    try {
      return await _query.getInstructorCourses(_auth.currentUser!.uid);
    } catch (e) {
      rethrow;
    }
  }

  /// Returns all available course types
  ///
  /// E.g "Generell førstehjelp", "Livreddende førstehjelp"
  Future<List<CourseType>> getCourseTypes() async {
    try {
      List<CourseType> courseTypes =
          await _query.getCourseTypes(_auth.currentUser!.uid);
      return courseTypes;
    } catch (e) {
      rethrow;
    }
  }

  /// Gets list of all confirmations for given course
  Future<List<Map<String, dynamic>>?> getConfirmationsForCourse(
      String courseCode) async {
    try {
      return await _query.getAllConfirmationsInCourse(courseCode);
    } catch (e) {
      rethrow;
    }
  }

  /// Method for generating a new course code
  Future<String> generateAndCheckCourseCode() async {
    String code = generateNewCourseCode();
    if (await _query.checkCourseCode(code)) {
      generateAndCheckCourseCode();
    }
    return code;
  }

  Future<bool> checkCourseCode(String code) async {
    return _query.checkCourseCode(code);
  }

  String generateNewCourseCode() {
    const randomChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    const codeLength = 6;
    final rand = Random();
    return List.generate(codeLength, (_) {
      return randomChars[rand.nextInt(randomChars.length)];
    }).join();
  }

  /// Adds user to course confirmation collection using course code
  ///
  /// Example:
  /// await _service.courseConfirmation("EYGPOI");
  /// where EYGPOI is swapped out with course code for generated course
  Future<bool> courseConfirmation(String courseCode) async {
    return await _query.addUserToCourseConfirmationCollection(
        _auth.currentUser!.uid, courseCode, _auth.currentUser!.email);
  }

  /// Adds course document reference to user course array
  ///
  /// This is only to be used after user instructor accepts course confirmation, i.e courseConfirmation() (essentially confirming user was at course)
  ///
  /// Example:
  /// await _service.addUserToCourse("asdfgdf3453tdfg", "EYGPOI");
  Future<void> addUserToCourse(String uid, String courseCode) async {
    await _query.addUserToCourse(uid, courseCode);
  }
}
