// ignore_for_file: avoid_print, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class StoreController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final profrssorCourse = RxList<QueryDocumentSnapshot>.from([]);
  final RxList allCourse = [].obs;
  RxBool courseLoading = false.obs;
  RxBool allcourseLoading = false.obs;
  RxBool addCourseLoading = false.obs;
  RxDouble courseRate = RxDouble(0.0);

  CollectionReference coursesCollection =
      FirebaseFirestore.instance.collection('courses');

  CollectionReference bookedCoursesCollection =
      FirebaseFirestore.instance.collection('bookedcourses');

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
      addCourseLoading.value = false;
      DocumentReference response = await coursesCollection.add({
        'courseName': courseName,
        'courseField': courseField,
        'id': FirebaseAuth.instance.currentUser!.uid
      });

      await getProfessorCourse();
      getProfessorCourse();
      addCourseLoading.value = true;
    } catch (e) {
      addCourseLoading.value = true;
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

//=====GET ALL COURSES
  Stream<List<Map<String, dynamic>>> fetchCoursesStream() {
    return firestore.collection("courses").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();
        return user;
      }).toList();
    });
  }

//======GET COURSES FOR  EVERY PROFESSOR
  Stream<List<Map<String, dynamic>>> fetchProfessorCourseStream() {
    return firestore.collection("courses").snapshots().map((snapshot) {
      return snapshot.docs.where((doc) {
        final proCourse = doc.data();
        return proCourse['id'] == FirebaseAuth.instance.currentUser!.uid;
      }).map((doc) {
        return doc.data();
      }).toList();
    });
  }

//======RESERVE A COURSE
  Future<void> reserveCourse(
      String courseName, courseField, professor, date, time, courseID) async {
    try {
      DocumentReference response = await bookedCoursesCollection.add({
        'professor': professor,
        'courseDate': date,
        'courseTime': time,
        'courseName': courseName,
        'courseField': courseField,
        'userID': FirebaseAuth.instance.currentUser!.uid,
        'id': courseID,
      });
      print("======= done adding");
    } catch (e) {
      print("=======booked ${e.toString()}");
    }
  }

//======GET BOOKED COURSES
  Stream<List<Map<String, dynamic>>> fetchBookedCoursesStream() {
    return firestore.collection("bookedcourses").snapshots().map((snapshot) {
      return snapshot.docs.where((doc) {
        final bookedCourse = doc.data();
        return bookedCourse['userID'] == FirebaseAuth.instance.currentUser!.uid;
      }).map((doc) {
        return doc.data();
      }).toList();
    });
  }

//=====SEND FEEDBACK
  sendFeedBack(String courseID, comment, rate) async {
    try {
      CollectionReference feedback = FirebaseFirestore.instance
          .collection('courses')
          .doc(courseID)
          .collection('feedback');
      await feedback.add({
        'comment': comment,
        'rate': rate,
        'userID': FirebaseAuth.instance.currentUser!.uid,
      });
      print("======done feedbackkkk");
    } catch (e) {
      print("===error feedback ${e.toString()}");
    }
  }

  //========DELETE COURSE
  deleteCourse(String courseID) async {
    try {
      coursesCollection.doc(courseID).delete();
      print("======done deleteing");
      await getProfessorCourse();
      await getAllCourse();
    } catch (e) {
      print(e.toString());
    }
  }

  //========UPDATE A COURSE
  updateCourse(String courseID, newName, newField) async {
    try {
      coursesCollection
          .doc(courseID)
          .update({'courseName': newName, 'courseField': newField});
      print("======done updating");
      await getProfessorCourse();
      await getAllCourse();
    } catch (e) {
      print(e.toString());
    }
  }
}
