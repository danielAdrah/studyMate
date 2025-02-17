// ignore_for_file: avoid_print, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class StoreController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  final profrssorCourse = RxList<QueryDocumentSnapshot>.from([]);
  RxList<QueryDocumentSnapshot> allCourse = <QueryDocumentSnapshot>[].obs;
  RxList<QueryDocumentSnapshot> firstPost = <QueryDocumentSnapshot>[].obs;
  RxList<QueryDocumentSnapshot> secondPost = <QueryDocumentSnapshot>[].obs;
  RxList<QueryDocumentSnapshot> thirdPost = <QueryDocumentSnapshot>[].obs;
  RxList<QueryDocumentSnapshot> fourthPost = <QueryDocumentSnapshot>[].obs;

  RxString userName = "".obs;
  RxString userFullName = "".obs;
  RxString userMail = "".obs;
  RxString userSpecialty = "".obs;
  RxString userToken = "".obs;
  RxBool userActivaty = false.obs;
  //===
  RxBool courseLoading = false.obs;
  RxBool allcourseLoading = false.obs;
  RxBool addCourseLoading = false.obs;
  RxDouble courseRate = RxDouble(0.0);
  RxInt count = RxInt(0);
  RxList<QueryDocumentSnapshot> posts = <QueryDocumentSnapshot>[].obs;

  CollectionReference coursesCollection =
      FirebaseFirestore.instance.collection('courses');

  CollectionReference bookedCoursesCollection =
      FirebaseFirestore.instance.collection('bookedcourses');

  CollectionReference postsCollection =
      FirebaseFirestore.instance.collection('posts');

  Future<String?> getCurrentUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      userName.value = userDoc.data()!['name'];
      return userDoc.data()!['name'];
    }
    return null;
  }

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
        userName.value = userData['name'];
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

//UPDATE USER INFO
  updateUserInfo(String userId, newName, newSpecailty) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'name': newName,
        'specialty': newSpecailty,
      });
      print("done update");
    } catch (e) {
      print(e.toString());
    }
  }

//=======ADD POST
  Future<void> addPost(String postContent, year) async {
    try {
      DocumentReference response = await postsCollection.add({
        'user': FirebaseAuth.instance.currentUser!.email,
        'content': postContent,
        'timestamp': Timestamp.now(),
        'year': year,
      });
      fetchPostStream();
      await getFirstPost();
      await getSecondPost();
      await getThirdPost();
      await getFourthPost();
      print("=======done post");
    } catch (e) {
      print(e.toString());
    }
  }

//======GET ALL POSTS
  Stream<List<Map<String, dynamic>>> fetchPostStream() {
    return firestore
        .collection("posts")
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final post = doc.data();

        return post;
      }).toList();
    });
  }

//  FETCH FIRST YEAR POST
  Future<void> getFirstPost() async {
    try {
      allcourseLoading.value = true;
      QuerySnapshot data = await FirebaseFirestore.instance
          .collection("posts")
          .where('year', isEqualTo: 'firstYear')
          .get();
      print('Number of all posts fetched: ${data.docs.length}');
      firstPost.value = data.docs;
      // allcourseLoading.value = false;
    } catch (e) {
      // allcourseLoading.value = false;
      print("===========${e.toString()}");
    }
  }

  //  FETCH SECOND YEAR POST
  Future<void> getSecondPost() async {
    try {
      allcourseLoading.value = true;
      QuerySnapshot data = await FirebaseFirestore.instance
          .collection("posts")
          .where('year', isEqualTo: 'secondYear')
          .get();
      print('Number of all posts fetched: ${data.docs.length}');
      secondPost.value = data.docs;
      // allcourseLoading.value = false;
    } catch (e) {
      // allcourseLoading.value = false;
      print("===========${e.toString()}");
    }
  }

  //  FETCH THIRD YEAR POST
  Future<void> getThirdPost() async {
    try {
      QuerySnapshot data = await FirebaseFirestore.instance
          .collection("posts")
          .where('year', isEqualTo: 'thirdYear')
          .get();
      print('Number of all posts fetched: ${data.docs.length}');
      thirdPost.value = data.docs;
    } catch (e) {
      print("===========${e.toString()}");
    }
  }

  //  FETCH FOURTH YEAR POST
  Future<void> getFourthPost() async {
    try {
      QuerySnapshot data = await FirebaseFirestore.instance
          .collection("posts")
          .where('year', isEqualTo: 'fourthYear')
          .get();
      print('Number of all posts fetched: ${data.docs.length}');
      fourthPost.value = data.docs;
    } catch (e) {
      print("===========${e.toString()}");
    }
  }

//====GET THE POST OF EACH YEAR
  Stream<List<Map<String, dynamic>>> fetchFirstPostStream(String year) {
    return firestore
        .collection("posts")
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.where((doc) {
        final post = doc.data();

        return post['year'] == year;
      }).map((doc) {
        return doc.data();
      }).toList();
    });
  }

//=====ADD COMMENTS
  addComment(String comment, postID) async {
    try {
      await postsCollection.doc(postID).collection('comments').add({
        'comment': comment,
        'user': FirebaseAuth.instance.currentUser!.email,
        'timestamp': Timestamp.now(),
      });
      fetchPostStream();
      await getFirstPost();
      print("done comment");
    } catch (e) {
      print(e.toString());
    }
  }

//=====FETCH THE COMMENTS
  Stream<List<Map<String, dynamic>>> fetchFirstCommentStream(String postID) {
    return firestore
        .collection("posts")
        .doc(postID)
        .collection('comments')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final comment = doc.data();
        return comment;
      }).toList();
    });
  }

//======
  Future<void> deleteUser(String uid) async {
    try {
      // First, delete the user from Firebase Authentication
      await auth.currentUser?.delete();

      // Then, delete the user's data from Firestore
      await firestore.collection('users').doc(uid).delete();

      print('User deleted successfully');
    } on FirebaseAuthException catch (e) {
      print('Error deleting user: ${e.message}');
      rethrow;
    }
  }

  //=====FETCH USER INFO
  Future<void> fetchUserData() async {
    final user = auth.currentUser;
    if (user != null) {
      final docSnap = await firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      if (docSnap.exists) {
        userFullName.value = docSnap.get('name');
        userMail.value = docSnap.get('email');
        userSpecialty.value = docSnap.get('specialty');
        userActivaty.value = docSnap.get('isActive');
        userToken.value = docSnap.get('token');
      }
    }
  }
}
