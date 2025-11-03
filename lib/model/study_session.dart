import 'package:cloud_firestore/cloud_firestore.dart';

class StudySession {
  final String id;
  final String groupId;
  final String title;
  final Timestamp startTime;
  final Timestamp endTime;
  final String organizerId;
  final List<String> participantIds;
  final String? notes;
  final bool isRecurring;
  final String? recurrenceRule; // e.g., "weekly", "daily"

  StudySession({
    required this.id,
    required this.groupId,
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.organizerId,
    required this.participantIds,
    this.notes,
    this.isRecurring = false,
    this.recurrenceRule,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'groupId': groupId,
      'title': title,
      'startTime': startTime,
      'endTime': endTime,
      'organizerId': organizerId,
      'participantIds': participantIds,
      'notes': notes,
      'isRecurring': isRecurring,
      'recurrenceRule': recurrenceRule,
    };
  }

  // Create from Firestore document
  factory StudySession.fromMap(Map<String, dynamic> map, String documentId) {
    return StudySession(
      id: documentId,
      groupId: map['groupId'],
      title: map['title'],
      startTime: map['startTime'],
      endTime: map['endTime'],
      organizerId: map['organizerId'],
      participantIds: List<String>.from(map['participantIds']),
      notes: map['notes'],
      isRecurring: map['isRecurring'] ?? false,
      recurrenceRule: map['recurrenceRule'],
    );
  }
}
