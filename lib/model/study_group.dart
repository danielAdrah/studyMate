import 'package:cloud_firestore/cloud_firestore.dart';

class StudyGroup {
  final String id;
  final String name;
  final String courseId;
  final String courseName;
  final List<String> memberIds;
  final String creatorId;
  final Timestamp createdAt;
  final String? description;

  StudyGroup({
    required this.id,
    required this.name,
    required this.courseId,
    required this.courseName,
    required this.memberIds,
    required this.creatorId,
    required this.createdAt,
    this.description,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'courseId': courseId,
      'courseName': courseName,
      'memberIds': memberIds,
      'creatorId': creatorId,
      'createdAt': createdAt,
      'description': description,
    };
  }

  // Create from Firestore document
  factory StudyGroup.fromMap(Map<String, dynamic> map, String documentId) {
    return StudyGroup(
      id: documentId,
      name: map['name'],
      courseId: map['courseId'],
      courseName: map['courseName'],
      memberIds: List<String>.from(map['memberIds']),
      creatorId: map['creatorId'],
      createdAt: map['createdAt'],
      description: map['description'],
    );
  }
}
