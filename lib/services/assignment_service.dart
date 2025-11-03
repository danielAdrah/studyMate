import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../model/assignment.dart';
import '../model/submission.dart';
import '../model/grade.dart';

class AssignmentService extends GetxService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Collections
  String get _assignmentsCollection => 'assignments';
  String get _submissionsCollection => 'submissions';
  String get _gradesCollection => 'grades';

  // ASSIGNMENT OPERATIONS

  /// Create a new assignment
  Future<String> createAssignment(Assignment assignment) async {
    try {
      // Use set() with the assignment ID instead of add()
      await _firestore
          .collection(_assignmentsCollection)
          .doc(assignment.id)
          .set(assignment.toMap());
      return assignment.id;
    } catch (e) {
      throw Exception('Failed to create assignment: $e');
    }
  }

  /// Update an existing assignment
  Future<void> updateAssignment(Assignment assignment) async {
    try {
      await _firestore
          .collection(_assignmentsCollection)
          .doc(assignment.id)
          .update(assignment.toMap());
    } catch (e) {
      throw Exception('Failed to update assignment: $e');
    }
  }

  /// Delete an assignment
  Future<void> deleteAssignment(String assignmentId) async {
    try {
      // Delete assignment
      await _firestore
          .collection(_assignmentsCollection)
          .doc(assignmentId)
          .delete();

      // Delete related submissions
      final submissions = await _firestore
          .collection(_submissionsCollection)
          .where('assignmentId', isEqualTo: assignmentId)
          .get();

      final batch = _firestore.batch();
      for (var doc in submissions.docs) {
        batch.delete(doc.reference);
      }

      // Delete related grades
      final grades = await _firestore
          .collection(_gradesCollection)
          .where('assignmentId', isEqualTo: assignmentId)
          .get();

      for (var doc in grades.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to delete assignment: $e');
    }
  }

  /// Get assignment by ID
  Future<Assignment?> getAssignment(String assignmentId) async {
    try {
      final doc = await _firestore
          .collection(_assignmentsCollection)
          .doc(assignmentId)
          .get();

      if (doc.exists) {
        return Assignment.fromMap({...doc.data()!, 'id': doc.id});
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get assignment: $e');
    }
  }

  /// Get assignments for a professor
  Stream<List<Assignment>> getProfessorAssignments(String professorId) {
    return _firestore
        .collection(_assignmentsCollection)
        .where('professorId', isEqualTo: professorId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Assignment.fromMap({...doc.data(), 'id': doc.id}))
            .toList());
  }

  /// Get assignments for a course
  Stream<List<Assignment>> getCourseAssignments(String courseId) {
    return _firestore
        .collection(_assignmentsCollection)
        .where('courseId', isEqualTo: courseId)
        .where('status', isEqualTo: AssignmentStatus.published.toString())
        .orderBy('dueDate', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Assignment.fromMap({...doc.data(), 'id': doc.id}))
            .toList());
  }

  /// Get assignments for a student based on their booked courses
  Stream<List<Assignment>> getStudentAssignments(String studentId) {
    // First, get the courses that the student has booked
    return _firestore
        .collection('bookedcourses')
        .where('userID', isEqualTo: studentId)
        .snapshots()
        .asyncMap((snapshot) async {
      // Extract course IDs from booked courses
      final courseIds =
          snapshot.docs.map((doc) => doc.data()['id'] as String).toList();

      if (courseIds.isEmpty) {
        return <Assignment>[];
      }

      // Get assignments for all these courses
      final assignments = <Assignment>[];
      for (final courseId in courseIds) {
        final courseAssignments = await _firestore
            .collection(_assignmentsCollection)
            .where('courseId', isEqualTo: courseId)
            .where('status', isEqualTo: AssignmentStatus.published.toString())
            .orderBy('dueDate', descending: false)
            .get();

        assignments.addAll(courseAssignments.docs
            .map((doc) => Assignment.fromMap({...doc.data(), 'id': doc.id}))
            .toList());
      }

      // Sort by due date
      assignments.sort((a, b) => a.dueDate.compareTo(b.dueDate));
      return assignments;
    });
  }

  /// Publish an assignment
  Future<void> publishAssignment(String assignmentId) async {
    try {
      await _firestore
          .collection(_assignmentsCollection)
          .doc(assignmentId)
          .update({
        'status': AssignmentStatus.published.toString(),
        'publishedAt': Timestamp.now(),
      });
    } catch (e) {
      throw Exception('Failed to publish assignment: $e');
    }
  }

  /// Close an assignment
  Future<void> closeAssignment(String assignmentId) async {
    try {
      await _firestore
          .collection(_assignmentsCollection)
          .doc(assignmentId)
          .update({
        'status': AssignmentStatus.closed.toString(),
      });
    } catch (e) {
      throw Exception('Failed to close assignment: $e');
    }
  }

  // SUBMISSION OPERATIONS

  /// Get submissions for an assignment
  Stream<List<Submission>> getAssignmentSubmissions(String assignmentId) {
    return _firestore
        .collection(_submissionsCollection)
        .where('assignmentId', isEqualTo: assignmentId)
        .orderBy('submittedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Submission.fromMap({...doc.data(), 'id': doc.id}))
            .toList());
  }

  /// Get submission by ID
  Future<Submission?> getSubmission(String submissionId) async {
    try {
      final doc = await _firestore
          .collection(_submissionsCollection)
          .doc(submissionId)
          .get();

      if (doc.exists) {
        return Submission.fromMap({...doc.data()!, 'id': doc.id});
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get submission: $e');
    }
  }

  /// Create a new submission
  Future<String> createSubmission(Submission submission) async {
    try {
      await _firestore
          .collection(_submissionsCollection)
          .doc(submission.id)
          .set(submission.toMap());

      // Update submission count for the assignment
      await updateSubmissionCount(submission.assignmentId);

      return submission.id;
    } catch (e) {
      throw Exception('Failed to create submission: $e');
    }
  }

  /// Update submission count for assignment
  Future<void> updateSubmissionCount(String assignmentId) async {
    try {
      final submissions = await _firestore
          .collection(_submissionsCollection)
          .where('assignmentId', isEqualTo: assignmentId)
          .where('status', isEqualTo: SubmissionStatus.submitted.toString())
          .get();

      await _firestore
          .collection(_assignmentsCollection)
          .doc(assignmentId)
          .update({'submissionCount': submissions.size});
    } catch (e) {
      throw Exception('Failed to update submission count: $e');
    }
  }

  /// Check if a student has submitted an assignment
  Future<bool> hasStudentSubmittedAssignment(
      String assignmentId, String studentId) async {
    try {
      final submissions = await _firestore
          .collection(_submissionsCollection)
          .where('assignmentId', isEqualTo: assignmentId)
          .where('studentId', isEqualTo: studentId)
          .where('status', isEqualTo: SubmissionStatus.submitted.toString())
          .get();

      return submissions.size > 0;
    } catch (e) {
      throw Exception('Failed to check submission status: $e');
    }
  }

  /// Get student's submission for an assignment
  Future<Submission?> getStudentSubmission(
      String assignmentId, String studentId) async {
    try {
      final submissions = await _firestore
          .collection(_submissionsCollection)
          .where('assignmentId', isEqualTo: assignmentId)
          .where('studentId', isEqualTo: studentId)
          .get();

      if (submissions.docs.isNotEmpty) {
        return Submission.fromMap({
          ...submissions.docs.first.data(),
          'id': submissions.docs.first.id
        });
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get student submission: $e');
    }
  }

  // GRADING OPERATIONS

  /// Create a grade for a submission
  Future<String> createGrade(Grade grade) async {
    try {
      final docRef =
          await _firestore.collection(_gradesCollection).add(grade.toMap());

      // Update submission with grade
      await _firestore
          .collection(_submissionsCollection)
          .doc(grade.submissionId)
          .update({
        'status': SubmissionStatus.graded.toString(),
        'totalScore': grade.totalScore,
        'maxScore': grade.maxScore,
        'feedback': grade.overallFeedback,
        'gradedAt': Timestamp.fromDate(grade.gradedAt),
      });

      // Update graded count for assignment
      await updateGradedCount(grade.assignmentId);

      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create grade: $e');
    }
  }

  /// Update a grade
  Future<void> updateGrade(Grade grade) async {
    try {
      await _firestore
          .collection(_gradesCollection)
          .doc(grade.id)
          .update(grade.toMap());

      // Update submission with new grade
      await _firestore
          .collection(_submissionsCollection)
          .doc(grade.submissionId)
          .update({
        'totalScore': grade.totalScore,
        'maxScore': grade.maxScore,
        'feedback': grade.overallFeedback,
        'gradedAt': Timestamp.fromDate(grade.gradedAt),
      });
    } catch (e) {
      throw Exception('Failed to update grade: $e');
    }
  }

  /// Get grade for a submission
  Future<Grade?> getGradeForSubmission(String submissionId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_gradesCollection)
          .where('submissionId', isEqualTo: submissionId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        return Grade.fromMap({...doc.data(), 'id': doc.id});
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get grade: $e');
    }
  }

  /// Get grades for an assignment
  Stream<List<Grade>> getAssignmentGrades(String assignmentId) {
    return _firestore
        .collection(_gradesCollection)
        .where('assignmentId', isEqualTo: assignmentId)
        .orderBy('gradedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Grade.fromMap({...doc.data(), 'id': doc.id}))
            .toList());
  }

  /// Update graded count for assignment
  Future<void> updateGradedCount(String assignmentId) async {
    try {
      final grades = await _firestore
          .collection(_gradesCollection)
          .where('assignmentId', isEqualTo: assignmentId)
          .get();

      await _firestore
          .collection(_assignmentsCollection)
          .doc(assignmentId)
          .update({'gradedCount': grades.size});
    } catch (e) {
      throw Exception('Failed to update graded count: $e');
    }
  }

  /// Return graded assignment to student
  Future<void> returnGrade(String gradeId) async {
    try {
      await _firestore.collection(_gradesCollection).doc(gradeId).update({
        'isReturned': true,
        'returnedAt': Timestamp.now(),
      });
    } catch (e) {
      throw Exception('Failed to return grade: $e');
    }
  }

  // ANALYTICS OPERATIONS

  /// Get assignment statistics
  Future<Map<String, dynamic>> getAssignmentStats(String assignmentId) async {
    try {
      final submissions = await _firestore
          .collection(_submissionsCollection)
          .where('assignmentId', isEqualTo: assignmentId)
          .where('status', isEqualTo: SubmissionStatus.submitted.toString())
          .get();

      final grades = await _firestore
          .collection(_gradesCollection)
          .where('assignmentId', isEqualTo: assignmentId)
          .get();

      final scores =
          grades.docs.map((doc) => doc.data()['totalScore'] as double).toList();

      double average = 0.0;
      double highest = 0.0;
      double lowest = 0.0;

      if (scores.isNotEmpty) {
        scores.sort();
        average = scores.reduce((a, b) => a + b) / scores.length;
        highest = scores.last;
        lowest = scores.first;
      }

      return {
        'totalSubmissions': submissions.size,
        'totalGraded': grades.size,
        'averageScore': average,
        'highestScore': highest,
        'lowestScore': lowest,
        'gradingProgress':
            submissions.size > 0 ? grades.size / submissions.size : 0.0,
      };
    } catch (e) {
      throw Exception('Failed to get assignment stats: $e');
    }
  }

  /// Get professor's overall statistics
  Future<Map<String, dynamic>> getProfessorStats(String professorId) async {
    try {
      final assignments = await _firestore
          .collection(_assignmentsCollection)
          .where('professorId', isEqualTo: professorId)
          .get();

      final submissions = await _firestore
          .collection(_submissionsCollection)
          .where('assignmentId',
              whereIn: assignments.docs.map((doc) => doc.id).toList())
          .get();

      final grades = await _firestore
          .collection(_gradesCollection)
          .where('professorId', isEqualTo: professorId)
          .get();

      return {
        'totalAssignments': assignments.size,
        'publishedAssignments': assignments.docs
            .where((doc) =>
                doc.data()['status'] == AssignmentStatus.published.toString())
            .length,
        'totalSubmissions': submissions.size,
        'totalGraded': grades.size,
        'pendingGrading': submissions.size - grades.size,
      };
    } catch (e) {
      throw Exception('Failed to get professor stats: $e');
    }
  }
}
