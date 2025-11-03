import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:studymate/model/message.dart';

class StudyGroupMessage extends Message {
  final String groupId;

  StudyGroupMessage({
    required this.groupId,
    required String senderID,
    required String senderEmail,
    required String message,
    required Timestamp timestamp,
  }) : super(
          senderID: senderID,
          senderEmail: senderEmail,
          receiverID: groupId, // Using groupId as receiverID for group messages
          message: message,
          timestamp: timestamp,
        );

  // Convert to Map for Firestore
  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'groupId': groupId,
    };
  }

  // Create from Firestore document
  factory StudyGroupMessage.fromMap(Map<String, dynamic> map) {
    return StudyGroupMessage(
      groupId: map['groupId'],
      senderID: map['senderID'],
      senderEmail: map['senderEmail'],
      message: map['message'],
      timestamp: map['timestamp'],
    );
  }
}
