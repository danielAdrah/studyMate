import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class StoreController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

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
}
