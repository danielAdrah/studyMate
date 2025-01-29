// ignore_for_file: avoid_print, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class StoreController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final profrssorCourse = RxList<QueryDocumentSnapshot>.from([]);
  final allCourse = RxList<QueryDocumentSnapshot>.from([]);
  RxBool courseLoading = false.obs;
  RxBool allcourseLoading = false.obs;

  CollectionReference coursesCollection =
      FirebaseFirestore.instance.collection('courses');

  //========GET ALL THE PROFESSORS
  Stream<List<Map<String, dynamic>>> getProfessorStream() {
    return firestore.collection("users").snapshots().map((snapshot) {
      return snapshot.docs.where((doc) {
        final userData = doc.data();
        return userData['role'] == 'Professor';
      }).map((doc) {
        return doc.data();
      }).toList();
    });
  }

//========GET ALL THE STUDENTS
  Stream<List<Map<String, dynamic>>> getStudentsStream() {
    return firestore.collection("users").snapshots().map((snapshot) {
      return snapshot.docs.where((doc) {
        final userData = doc.data();
        return userData['role'] == 'Student';
      }).map((doc) {
        return doc.data();
      }).toList();
    });
  }

  //========ADD COURSES
  Future<void> addCourse(courseName, courseField) async {
    try {
      DocumentReference response = await coursesCollection.add({
        'courseName': courseName,
        'courseField': courseField,
        'id': FirebaseAuth.instance.currentUser!.uid
      });

      await getProfessorCourse();
    } catch (e) {
      print("loooooooook herreeeee ${e.toString()}");
    }
  }

//=======FETCH THE COURSES FOR EVERY PROFRSSOR
  Future<void> getProfessorCourse() async {
    try {
      courseLoading.value = true;
      QuerySnapshot data = await FirebaseFirestore.instance
          .collection("courses")
          .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      print('Number of courses fetched: ${data.docs.length}');
      profrssorCourse.value = data.docs;
      courseLoading.value = false;
    } catch (e) {
      courseLoading.value = false;
      print("===========${e.toString()}");
    }
  }

//=======FETCH ALL THE COURSES
  Future<void> getAllCourse() async {
    try {
      allcourseLoading.value = true;
      QuerySnapshot data =
          await FirebaseFirestore.instance.collection("courses").get();
      print('Number of all courses fetched: ${data.docs.length}');
      allCourse.value = data.docs;
      allcourseLoading.value = false;
    } catch (e) {
      allcourseLoading.value = false;
      print("===========${e.toString()}");
    }
  }
}
