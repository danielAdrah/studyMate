import 'package:cloud_firestore/cloud_firestore.dart';

enum AssignmentType { multipleChoice, shortAnswer, essay, survey, quiz }

enum AssignmentStatus { draft, published, closed, graded }

class Question {
  final String id;
  final String questionText;
  final AssignmentType type;
  final List<String>? options; // For multiple choice
  final String? correctAnswer; // For auto-grading
  final int maxPoints;
  final bool isRequired;

  Question({
    required this.id,
    required this.questionText,
    required this.type,
    this.options,
    this.correctAnswer,
    required this.maxPoints,
    this.isRequired = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'questionText': questionText,
      'type': type.toString(),
      'options': options,
      'correctAnswer': correctAnswer,
      'maxPoints': maxPoints,
      'isRequired': isRequired,
    };
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      id: map['id'] ?? '',
      questionText: map['questionText'] ?? '',
      type: AssignmentType.values.firstWhere(
        (e) => e.toString() == map['type'],
        orElse: () => AssignmentType.shortAnswer,
      ),
      options:
          map['options'] != null ? List<String>.from(map['options']) : null,
      correctAnswer: map['correctAnswer'],
      maxPoints: map['maxPoints']?.toInt() ?? 0,
      isRequired: map['isRequired'] ?? true,
    );
  }
}

class Assignment {
  final String id;
  final String title;
  final String description;
  final String courseId;
  final String courseName;
  final String professorId;
  final String professorName;
  final List<Question> questions;
  final DateTime createdAt;
  final DateTime dueDate;
  final DateTime? publishedAt;
  final AssignmentStatus status;
  final int totalPoints;
  final bool allowLateSubmissions;
  final int submissionCount;
  final int gradedCount;

  Assignment({
    required this.id,
    required this.title,
    required this.description,
    required this.courseId,
    required this.courseName,
    required this.professorId,
    required this.professorName,
    required this.questions,
    required this.createdAt,
    required this.dueDate,
    this.publishedAt,
    required this.status,
    required this.totalPoints,
    this.allowLateSubmissions = false,
    this.submissionCount = 0,
    this.gradedCount = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'courseId': courseId,
      'courseName': courseName,
      'professorId': professorId,
      'professorName': professorName,
      'questions': questions.map((q) => q.toMap()).toList(),
      'createdAt': Timestamp.fromDate(createdAt),
      'dueDate': Timestamp.fromDate(dueDate),
      'publishedAt':
          publishedAt != null ? Timestamp.fromDate(publishedAt!) : null,
      'status': status.toString(),
      'totalPoints': totalPoints,
      'allowLateSubmissions': allowLateSubmissions,
      'submissionCount': submissionCount,
      'gradedCount': gradedCount,
    };
  }

  factory Assignment.fromMap(Map<String, dynamic> map) {
    return Assignment(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      courseId: map['courseId'] ?? '',
      courseName: map['courseName'] ?? '',
      professorId: map['professorId'] ?? '',
      professorName: map['professorName'] ?? '',
      questions: (map['questions'] as List<dynamic>?)
              ?.map((q) => Question.fromMap(q as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      dueDate: (map['dueDate'] as Timestamp).toDate(),
      publishedAt: map['publishedAt'] != null
          ? (map['publishedAt'] as Timestamp).toDate()
          : null,
      status: AssignmentStatus.values.firstWhere(
        (e) => e.toString() == map['status'],
        orElse: () => AssignmentStatus.draft,
      ),
      totalPoints: map['totalPoints']?.toInt() ?? 0,
      allowLateSubmissions: map['allowLateSubmissions'] ?? false,
      submissionCount: map['submissionCount']?.toInt() ?? 0,
      gradedCount: map['gradedCount']?.toInt() ?? 0,
    );
  }

  Assignment copyWith({
    String? id,
    String? title,
    String? description,
    String? courseId,
    String? courseName,
    String? professorId,
    String? professorName,
    List<Question>? questions,
    DateTime? createdAt,
    DateTime? dueDate,
    DateTime? publishedAt,
    AssignmentStatus? status,
    int? totalPoints,
    bool? allowLateSubmissions,
    int? submissionCount,
    int? gradedCount,
  }) {
    return Assignment(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      courseId: courseId ?? this.courseId,
      courseName: courseName ?? this.courseName,
      professorId: professorId ?? this.professorId,
      professorName: professorName ?? this.professorName,
      questions: questions ?? this.questions,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      publishedAt: publishedAt ?? this.publishedAt,
      status: status ?? this.status,
      totalPoints: totalPoints ?? this.totalPoints,
      allowLateSubmissions: allowLateSubmissions ?? this.allowLateSubmissions,
      submissionCount: submissionCount ?? this.submissionCount,
      gradedCount: gradedCount ?? this.gradedCount,
    );
  }

  bool get isOverdue => DateTime.now().isAfter(dueDate);
  bool get isDraft => status == AssignmentStatus.draft;
  bool get isPublished => status == AssignmentStatus.published;
  bool get isClosed => status == AssignmentStatus.closed;
  bool get isGraded => status == AssignmentStatus.graded;

  double get gradingProgress =>
      submissionCount > 0 ? gradedCount / submissionCount : 0.0;

  String get statusDisplayText {
    switch (status) {
      case AssignmentStatus.draft:
        return 'Draft';
      case AssignmentStatus.published:
        return 'Published';
      case AssignmentStatus.closed:
        return 'Closed';
      case AssignmentStatus.graded:
        return 'Graded';
    }
  }
}
