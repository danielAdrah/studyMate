import 'package:cloud_firestore/cloud_firestore.dart';

enum GradeType { automatic, manual, partial }

class QuestionGrade {
  final String questionId;
  final double pointsEarned;
  final double maxPoints;
  final String? feedback;
  final GradeType gradeType;
  final DateTime gradedAt;

  QuestionGrade({
    required this.questionId,
    required this.pointsEarned,
    required this.maxPoints,
    this.feedback,
    required this.gradeType,
    required this.gradedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'questionId': questionId,
      'pointsEarned': pointsEarned,
      'maxPoints': maxPoints,
      'feedback': feedback,
      'gradeType': gradeType.toString(),
      'gradedAt': Timestamp.fromDate(gradedAt),
    };
  }

  factory QuestionGrade.fromMap(Map<String, dynamic> map) {
    return QuestionGrade(
      questionId: map['questionId'] ?? '',
      pointsEarned: map['pointsEarned']?.toDouble() ?? 0.0,
      maxPoints: map['maxPoints']?.toDouble() ?? 0.0,
      feedback: map['feedback'],
      gradeType: GradeType.values.firstWhere(
        (e) => e.toString() == map['gradeType'],
        orElse: () => GradeType.manual,
      ),
      gradedAt: (map['gradedAt'] as Timestamp).toDate(),
    );
  }

  double get percentage =>
      maxPoints > 0 ? (pointsEarned / maxPoints) * 100 : 0.0;

  bool get isFullCredit => pointsEarned == maxPoints;
  bool get isPartialCredit => pointsEarned > 0 && pointsEarned < maxPoints;
  bool get isNoCredit => pointsEarned == 0;
}

class Grade {
  final String id;
  final String submissionId;
  final String assignmentId;
  final String studentId;
  final String studentName;
  final String professorId;
  final String professorName;
  final List<QuestionGrade> questionGrades;
  final double totalScore;
  final double maxScore;
  final String? overallFeedback;
  final DateTime gradedAt;
  final DateTime? returnedAt;
  final bool isReturned;
  final Map<String, dynamic>? rubricScores;

  Grade({
    required this.id,
    required this.submissionId,
    required this.assignmentId,
    required this.studentId,
    required this.studentName,
    required this.professorId,
    required this.professorName,
    required this.questionGrades,
    required this.totalScore,
    required this.maxScore,
    this.overallFeedback,
    required this.gradedAt,
    this.returnedAt,
    this.isReturned = false,
    this.rubricScores,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'submissionId': submissionId,
      'assignmentId': assignmentId,
      'studentId': studentId,
      'studentName': studentName,
      'professorId': professorId,
      'professorName': professorName,
      'questionGrades': questionGrades.map((qg) => qg.toMap()).toList(),
      'totalScore': totalScore,
      'maxScore': maxScore,
      'overallFeedback': overallFeedback,
      'gradedAt': Timestamp.fromDate(gradedAt),
      'returnedAt': returnedAt != null ? Timestamp.fromDate(returnedAt!) : null,
      'isReturned': isReturned,
      'rubricScores': rubricScores,
    };
  }

  factory Grade.fromMap(Map<String, dynamic> map) {
    return Grade(
      id: map['id'] ?? '',
      submissionId: map['submissionId'] ?? '',
      assignmentId: map['assignmentId'] ?? '',
      studentId: map['studentId'] ?? '',
      studentName: map['studentName'] ?? '',
      professorId: map['professorId'] ?? '',
      professorName: map['professorName'] ?? '',
      questionGrades: (map['questionGrades'] as List<dynamic>?)
              ?.map((qg) => QuestionGrade.fromMap(qg as Map<String, dynamic>))
              .toList() ??
          [],
      totalScore: map['totalScore']?.toDouble() ?? 0.0,
      maxScore: map['maxScore']?.toDouble() ?? 0.0,
      overallFeedback: map['overallFeedback'],
      gradedAt: (map['gradedAt'] as Timestamp).toDate(),
      returnedAt: map['returnedAt'] != null
          ? (map['returnedAt'] as Timestamp).toDate()
          : null,
      isReturned: map['isReturned'] ?? false,
      rubricScores: map['rubricScores'] != null
          ? Map<String, dynamic>.from(map['rubricScores'])
          : null,
    );
  }

  Grade copyWith({
    String? id,
    String? submissionId,
    String? assignmentId,
    String? studentId,
    String? studentName,
    String? professorId,
    String? professorName,
    List<QuestionGrade>? questionGrades,
    double? totalScore,
    double? maxScore,
    String? overallFeedback,
    DateTime? gradedAt,
    DateTime? returnedAt,
    bool? isReturned,
    Map<String, dynamic>? rubricScores,
  }) {
    return Grade(
      id: id ?? this.id,
      submissionId: submissionId ?? this.submissionId,
      assignmentId: assignmentId ?? this.assignmentId,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      professorId: professorId ?? this.professorId,
      professorName: professorName ?? this.professorName,
      questionGrades: questionGrades ?? this.questionGrades,
      totalScore: totalScore ?? this.totalScore,
      maxScore: maxScore ?? this.maxScore,
      overallFeedback: overallFeedback ?? this.overallFeedback,
      gradedAt: gradedAt ?? this.gradedAt,
      returnedAt: returnedAt ?? this.returnedAt,
      isReturned: isReturned ?? this.isReturned,
      rubricScores: rubricScores ?? this.rubricScores,
    );
  }

  double get percentage => maxScore > 0 ? (totalScore / maxScore) * 100 : 0.0;

  String get letterGrade {
    final percent = percentage;
    if (percent >= 97) return 'A+';
    if (percent >= 93) return 'A';
    if (percent >= 90) return 'A-';
    if (percent >= 87) return 'B+';
    if (percent >= 83) return 'B';
    if (percent >= 80) return 'B-';
    if (percent >= 77) return 'C+';
    if (percent >= 73) return 'C';
    if (percent >= 70) return 'C-';
    if (percent >= 67) return 'D+';
    if (percent >= 65) return 'D';
    return 'F';
  }

  String get scoreDisplayText =>
      '${totalScore.toStringAsFixed(1)}/${maxScore.toStringAsFixed(0)}';

  String get percentageDisplayText => '${percentage.toStringAsFixed(1)}%';

  bool get isPassing => percentage >= 70.0;

  int get questionsGraded => questionGrades.length;

  int get questionsWithFeedback => questionGrades
      .where((qg) => qg.feedback != null && qg.feedback!.isNotEmpty)
      .length;

  bool get hasOverallFeedback =>
      overallFeedback != null && overallFeedback!.isNotEmpty;
}
