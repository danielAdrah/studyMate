import 'package:cloud_firestore/cloud_firestore.dart';

enum SubmissionStatus { draft, submitted, graded, returned }

class Answer {
  final String questionId;
  final String? textAnswer;
  final String? selectedOption;
  final List<String>? multipleSelections;
  final int? rating;
  final DateTime answeredAt;

  Answer({
    required this.questionId,
    this.textAnswer,
    this.selectedOption,
    this.multipleSelections,
    this.rating,
    required this.answeredAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'questionId': questionId,
      'textAnswer': textAnswer,
      'selectedOption': selectedOption,
      'multipleSelections': multipleSelections,
      'rating': rating,
      'answeredAt': Timestamp.fromDate(answeredAt),
    };
  }

  factory Answer.fromMap(Map<String, dynamic> map) {
    return Answer(
      questionId: map['questionId'] ?? '',
      textAnswer: map['textAnswer'],
      selectedOption: map['selectedOption'],
      multipleSelections: map['multipleSelections'] != null
          ? List<String>.from(map['multipleSelections'])
          : null,
      rating: map['rating']?.toInt(),
      answeredAt: (map['answeredAt'] as Timestamp).toDate(),
    );
  }

  bool get hasAnswer {
    return textAnswer != null ||
        selectedOption != null ||
        multipleSelections != null ||
        rating != null;
  }
}

class Submission {
  final String id;
  final String assignmentId;
  final String assignmentTitle;
  final String studentId;
  final String studentName;
  final String studentEmail;
  final List<Answer> answers;
  final DateTime createdAt;
  final DateTime? submittedAt;
  final DateTime? gradedAt;
  final SubmissionStatus status;
  final double? totalScore;
  final double? maxScore;
  final String? feedback;
  final bool isLateSubmission;
  final int timeSpentMinutes;

  Submission({
    required this.id,
    required this.assignmentId,
    required this.assignmentTitle,
    required this.studentId,
    required this.studentName,
    required this.studentEmail,
    required this.answers,
    required this.createdAt,
    this.submittedAt,
    this.gradedAt,
    required this.status,
    this.totalScore,
    this.maxScore,
    this.feedback,
    this.isLateSubmission = false,
    this.timeSpentMinutes = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'assignmentId': assignmentId,
      'assignmentTitle': assignmentTitle,
      'studentId': studentId,
      'studentName': studentName,
      'studentEmail': studentEmail,
      'answers': answers.map((a) => a.toMap()).toList(),
      'createdAt': Timestamp.fromDate(createdAt),
      'submittedAt':
          submittedAt != null ? Timestamp.fromDate(submittedAt!) : null,
      'gradedAt': gradedAt != null ? Timestamp.fromDate(gradedAt!) : null,
      'status': status.toString(),
      'totalScore': totalScore,
      'maxScore': maxScore,
      'feedback': feedback,
      'isLateSubmission': isLateSubmission,
      'timeSpentMinutes': timeSpentMinutes,
    };
  }

  factory Submission.fromMap(Map<String, dynamic> map) {
    return Submission(
      id: map['id'] ?? '',
      assignmentId: map['assignmentId'] ?? '',
      assignmentTitle: map['assignmentTitle'] ?? '',
      studentId: map['studentId'] ?? '',
      studentName: map['studentName'] ?? '',
      studentEmail: map['studentEmail'] ?? '',
      answers: (map['answers'] as List<dynamic>?)
              ?.map((a) => Answer.fromMap(a as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      submittedAt: map['submittedAt'] != null
          ? (map['submittedAt'] as Timestamp).toDate()
          : null,
      gradedAt: map['gradedAt'] != null
          ? (map['gradedAt'] as Timestamp).toDate()
          : null,
      status: SubmissionStatus.values.firstWhere(
        (e) => e.toString() == map['status'],
        orElse: () => SubmissionStatus.draft,
      ),
      totalScore: map['totalScore']?.toDouble(),
      maxScore: map['maxScore']?.toDouble(),
      feedback: map['feedback'],
      isLateSubmission: map['isLateSubmission'] ?? false,
      timeSpentMinutes: map['timeSpentMinutes']?.toInt() ?? 0,
    );
  }

  Submission copyWith({
    String? id,
    String? assignmentId,
    String? assignmentTitle,
    String? studentId,
    String? studentName,
    String? studentEmail,
    List<Answer>? answers,
    DateTime? createdAt,
    DateTime? submittedAt,
    DateTime? gradedAt,
    SubmissionStatus? status,
    double? totalScore,
    double? maxScore,
    String? feedback,
    bool? isLateSubmission,
    int? timeSpentMinutes,
  }) {
    return Submission(
      id: id ?? this.id,
      assignmentId: assignmentId ?? this.assignmentId,
      assignmentTitle: assignmentTitle ?? this.assignmentTitle,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      studentEmail: studentEmail ?? this.studentEmail,
      answers: answers ?? this.answers,
      createdAt: createdAt ?? this.createdAt,
      submittedAt: submittedAt ?? this.submittedAt,
      gradedAt: gradedAt ?? this.gradedAt,
      status: status ?? this.status,
      totalScore: totalScore ?? this.totalScore,
      maxScore: maxScore ?? this.maxScore,
      feedback: feedback ?? this.feedback,
      isLateSubmission: isLateSubmission ?? this.isLateSubmission,
      timeSpentMinutes: timeSpentMinutes ?? this.timeSpentMinutes,
    );
  }

  bool get isDraft => status == SubmissionStatus.draft;
  bool get isSubmitted => status == SubmissionStatus.submitted;
  bool get isGraded => status == SubmissionStatus.graded;
  bool get isReturned => status == SubmissionStatus.returned;

  double? get scorePercentage {
    if (totalScore != null && maxScore != null && maxScore! > 0) {
      return (totalScore! / maxScore!) * 100;
    }
    return null;
  }

  String get statusDisplayText {
    switch (status) {
      case SubmissionStatus.draft:
        return 'Draft';
      case SubmissionStatus.submitted:
        return 'Submitted';
      case SubmissionStatus.graded:
        return 'Graded';
      case SubmissionStatus.returned:
        return 'Returned';
    }
  }

  String get gradeDisplayText {
    if (totalScore != null && maxScore != null) {
      return '${totalScore!.toStringAsFixed(1)}/${maxScore!.toStringAsFixed(0)}';
    }
    return 'Not graded';
  }

  int get answeredQuestions => answers.where((a) => a.hasAnswer).length;

  bool get isComplete =>
      answers.isNotEmpty && answers.every((a) => a.hasAnswer);
}
