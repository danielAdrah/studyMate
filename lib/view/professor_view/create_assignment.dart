import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/assignment.dart';
import '../../services/assignment_service.dart';
import '../../common_widgets/custom_app_bar.dart';
import '../../common_widgets/custom_button.dart';
import '../../common_widgets/custome_text_field.dart';
import '../../common_widgets/date_time_selector.dart';
import '../../theme.dart';
import '../../controller/store_controller.dart';

class CreateAssignment extends StatefulWidget {
  final Assignment? assignment;

  const CreateAssignment({super.key, this.assignment});

  @override
  State<CreateAssignment> createState() => _CreateAssignmentState();
}

class _CreateAssignmentState extends State<CreateAssignment> {
  final AssignmentService _assignmentService = Get.find<AssignmentService>();
  final StoreController _storeController = Get.put(StoreController());
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  // Remove the course name controller since we'll use course selection
  String? _selectedCourseId;
  Map<String, dynamic>? _selectedCourse;
  List<Map<String, dynamic>> _professorCourses = [];

  DateTime _dueDate = DateTime.now().add(const Duration(days: 7));
  bool _allowLateSubmissions = false;
  bool _isLoading = false;

  List<Question> _questions = [];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    if (widget.assignment != null) {
      _titleController = TextEditingController(text: widget.assignment!.title);
      _descriptionController =
          TextEditingController(text: widget.assignment!.description);
      _selectedCourseId = widget.assignment!.courseId;
      _dueDate = widget.assignment!.dueDate;
      _allowLateSubmissions = widget.assignment!.allowLateSubmissions;
      _questions = List.from(widget.assignment!.questions);
    } else {
      _titleController = TextEditingController();
      _descriptionController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.background,
      appBar: AppBar(
        backgroundColor: TColor.primary,
        foregroundColor: TColor.onPrimary,
        elevation: 0,
        title: Text(
          widget.assignment == null ? "Create Assignment" : "Edit Assignment",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                TColor.primary,
                TColor.secondary,
              ],
            ),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: TColor.onPrimary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextButton(
              onPressed: _saveAsDraft,
              child: Text(
                "Save Draft",
                style: TextStyle(
                  color: TColor.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBasicInfo(),
              const SizedBox(height: 24),
              _buildSettings(),
              const SizedBox(height: 24),
              _buildQuestionsSection(),
              const SizedBox(height: 24),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInfo() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: TColor.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: TColor.primary.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: TColor.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.info_rounded,
                    color: TColor.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  "Basic Information",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: TColor.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildStyledTextField(
              controller: _titleController,
              label: "Assignment Title",
              icon: Icons.title_rounded,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter assignment title";
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildCourseSelector(),
            const SizedBox(height: 16),
            _buildStyledTextField(
              controller: _descriptionController,
              label: "Assignment Description",
              icon: Icons.description_rounded,
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter assignment description";
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStyledTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: TColor.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TColor.primary.withOpacity(0.2)),
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        validator: validator,
        style: TextStyle(color: TColor.onSurface),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: TColor.primary),
          prefixIcon: Icon(icon, color: TColor.primary),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: TColor.primary, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildCourseSelector() {
    return Container(
      decoration: BoxDecoration(
        color: TColor.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TColor.primary.withOpacity(0.2)),
      ),
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: _loadProfessorCourses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: const Row(
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(),
                  ),
                  SizedBox(width: 12),
                  Text('Loading courses...'),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Text('Error loading courses: ${snapshot.error}'),
            );
          }

          final courses = snapshot.data ?? [];
          _professorCourses = courses;

          // If editing an existing assignment, find and select the course
          if (widget.assignment != null && _selectedCourseId == null) {
            _selectedCourseId = widget.assignment!.courseId;
            _selectedCourse = courses.firstWhere(
              (course) => course['id'] == widget.assignment!.courseId,
              orElse: () => {},
            );
          }

          return DropdownButtonHideUnderline(
            child: DropdownButtonFormField<String>(
              value: _selectedCourseId,
              hint: const Text('Select a course'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a course';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Course',
                labelStyle: TextStyle(color: TColor.primary),
                prefixIcon: Icon(Icons.school_rounded, color: TColor.primary),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: TColor.primary, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              items: courses.map<DropdownMenuItem<String>>((course) {
                return DropdownMenuItem<String>(
                  value: course['id'],
                  child: Text(course['courseName']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCourseId = value;
                  _selectedCourse = courses.firstWhere(
                    (course) => course['id'] == value,
                    orElse: () => {},
                  );
                });
              },
            ),
          );
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _loadProfessorCourses() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) return [];

      final querySnapshot = await FirebaseFirestore.instance
          .collection('courses')
          .where('id', isEqualTo: userId)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      print('Error loading courses: $e');
      return [];
    }
  }

  Widget _buildSettings() {
    return Card(
      color: TColor.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Settings",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: TColor.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.schedule, color: TColor.onSurfaceVariant),
                const SizedBox(width: 8),
                Text("Due Date: ", style: TextStyle(color: TColor.onSurface)),
                const Spacer(),
                TextButton(
                  onPressed: _selectDueDate,
                  child: Text(
                    DateFormat('MMM dd, yyyy HH:mm').format(_dueDate),
                    style: TextStyle(color: TColor.primary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              title: Text("Allow Late Submissions",
                  style: TextStyle(color: TColor.onSurface)),
              subtitle: Text("Students can submit after due date",
                  style: TextStyle(color: TColor.onSurfaceVariant)),
              value: _allowLateSubmissions,
              activeColor: TColor.primary,
              onChanged: (value) {
                setState(() {
                  _allowLateSubmissions = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionsSection() {
    return Card(
      color: TColor.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Questions",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: TColor.onSurface,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: _addQuestion,
                  icon: Icon(Icons.add, color: TColor.primary),
                  label: Text("Add Question",
                      style: TextStyle(color: TColor.primary)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_questions.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: TColor.onSurfaceVariant.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Icon(Icons.quiz_outlined,
                        size: 48,
                        color: TColor.onSurfaceVariant.withOpacity(0.6)),
                    const SizedBox(height: 8),
                    Text(
                      "No questions added yet",
                      style: TextStyle(color: TColor.onSurfaceVariant),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Tap 'Add Question' to create your first question",
                      style: TextStyle(
                          color: TColor.onSurfaceVariant.withOpacity(0.8),
                          fontSize: 12),
                    ),
                  ],
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _questions.length,
                itemBuilder: (context, index) =>
                    _buildQuestionCard(_questions[index], index),
              ),
            if (_questions.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: TColor.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info, color: TColor.primary, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Total Points: ${_getTotalPoints()}",
                        style: TextStyle(
                          color: TColor.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard(Question question, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: TColor.surface,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: TColor.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: TColor.onPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    question.questionText,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: TColor.onSurface,
                    ),
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      _editQuestion(index);
                    } else if (value == 'delete') {
                      _deleteQuestion(index);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'edit', child: Text('Edit')),
                    const PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color:
                        _getQuestionTypeColor(question.type).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getQuestionTypeText(question.type),
                    style: TextStyle(
                      color: _getQuestionTypeColor(question.type),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  "${question.maxPoints} pts",
                  style: TextStyle(
                    color: TColor.onSurfaceVariant,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            if (question.options != null) ...[
              const SizedBox(height: 8),
              ...question.options!.map((option) => Padding(
                    padding: const EdgeInsets.only(left: 16, top: 4),
                    child: Row(
                      children: [
                        Icon(
                          question.correctAnswer == option
                              ? Icons.radio_button_checked
                              : Icons.radio_button_unchecked,
                          size: 16,
                          color: question.correctAnswer == option
                              ? TColor.success
                              : TColor.onSurfaceVariant,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          option,
                          style: TextStyle(
                            color: question.correctAnswer == option
                                ? TColor.success
                                : TColor.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                TColor.primary,
                TColor.secondary,
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: TColor.primary.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: _isLoading ? null : _saveAndPublish,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              elevation: 0,
            ),
            child: _isLoading
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            TColor.onPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "Publishing...",
                        style: TextStyle(
                          color: TColor.onPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  )
                : Text(
                    widget.assignment == null
                        ? "Create & Publish"
                        : "Save & Publish",
                    style: TextStyle(
                      color: TColor.onPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: TColor.primary),
            borderRadius: BorderRadius.circular(16),
          ),
          child: OutlinedButton(
            onPressed: _isLoading ? null : _saveAsDraft,
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              side: BorderSide.none,
            ),
            child: _isLoading
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            TColor.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "Saving Draft...",
                        style: TextStyle(
                          color: TColor.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  )
                : Text(
                    widget.assignment == null
                        ? "Save as Draft"
                        : "Save Changes",
                    style: TextStyle(
                      color: TColor.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  void _selectDueDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_dueDate),
      );

      if (time != null) {
        setState(() {
          _dueDate = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  void _addQuestion() {
    _showQuestionDialog();
  }

  void _editQuestion(int index) {
    _showQuestionDialog(question: _questions[index], index: index);
  }

  void _deleteQuestion(int index) {
    setState(() {
      _questions.removeAt(index);
    });
  }

  void _showQuestionDialog({Question? question, int? index}) {
    showDialog(
      context: context,
      builder: (context) => QuestionDialog(
        question: question,
        onSave: (newQuestion) {
          setState(() {
            if (index != null) {
              _questions[index] = newQuestion;
            } else {
              _questions.add(newQuestion);
            }
          });
        },
      ),
    );
  }

  int _getTotalPoints() {
    return _questions.fold(0, (sum, question) => sum + question.maxPoints);
  }

  Color _getQuestionTypeColor(AssignmentType type) {
    switch (type) {
      case AssignmentType.multipleChoice:
        return TColor.primary;
      case AssignmentType.shortAnswer:
        return TColor.success;
      case AssignmentType.essay:
        return TColor.secondary;
      case AssignmentType.survey:
        return TColor.warning;
      case AssignmentType.quiz:
        return TColor.error;
    }
  }

  String _getQuestionTypeText(AssignmentType type) {
    switch (type) {
      case AssignmentType.multipleChoice:
        return "Multiple Choice";
      case AssignmentType.shortAnswer:
        return "Short Answer";
      case AssignmentType.essay:
        return "Essay";
      case AssignmentType.survey:
        return "Survey";
      case AssignmentType.quiz:
        return "Quiz";
    }
  }

  Future<void> _saveAsDraft() async {
    if (!_formKey.currentState!.validate()) return;
    if (_questions.isEmpty) {
      Get.snackbar("Error", "Please add at least one question");
      return;
    }

    setState(() => _isLoading = true);
    Get.snackbar("Processing", "Saving assignment as draft...",
        backgroundColor: TColor.success, colorText: TColor.onPrimary);

    try {
      // Get current user info
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        Get.snackbar("Error", "User not authenticated",
            backgroundColor: TColor.error, colorText: Colors.white);
        return;
      }

      // Get professor name from Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('professors')
          .doc(currentUser.uid)
          .get();

      final professorName = userDoc.exists
          ? (userDoc.data()?['name'] ?? 'Unknown Professor')
          : 'Unknown Professor';

      final assignment = Assignment(
        id: widget.assignment?.id ?? const Uuid().v4(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        courseId: _selectedCourseId ?? "course_id",
        courseName: _selectedCourse?['courseName'] ?? "Unknown Course",
        professorId: currentUser.uid,
        professorName: professorName,
        questions: _questions,
        createdAt: widget.assignment?.createdAt ?? DateTime.now(),
        dueDate: _dueDate,
        status: AssignmentStatus.draft,
        totalPoints: _getTotalPoints(),
        allowLateSubmissions: _allowLateSubmissions,
      );

      if (widget.assignment == null) {
        await _assignmentService.createAssignment(assignment);
        Get.snackbar("Success", "Assignment saved as draft",
            backgroundColor: TColor.success, colorText: TColor.onPrimary);
      } else {
        await _assignmentService.updateAssignment(assignment);
        Get.snackbar("Success", "Assignment updated",
            backgroundColor: TColor.success, colorText: TColor.onPrimary);
      }

      Get.back();
    } catch (e) {
      Get.snackbar("Error", "Failed to save assignment: $e",
          backgroundColor: TColor.error, colorText: TColor.onPrimary);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveAndPublish() async {
    if (!_formKey.currentState!.validate()) return;
    if (_questions.isEmpty) {
      Get.snackbar("Error", "Please add at least one question",
          backgroundColor: TColor.warning, colorText: Colors.white);
      return;
    }

    setState(() => _isLoading = true);
    Get.snackbar("Processing", "Publishing assignment...",
        backgroundColor: TColor.success, colorText: TColor.onPrimary);

    try {
      print("Saving assignment...");

      // Get current user info
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        Get.snackbar("Error", "User not authenticated");
        return;
      }

      // Get professor name from Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('professors')
          .doc(currentUser.uid)
          .get();

      final professorName = userDoc.exists
          ? (userDoc.data()?['name'] ?? 'Unknown Professor')
          : 'Unknown Professor';

      final assignment = Assignment(
        id: widget.assignment?.id ?? const Uuid().v4(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        courseId: _selectedCourseId ?? "course_id",
        courseName: _selectedCourse?['courseName'] ?? "Unknown Course",
        professorId: currentUser.uid,
        professorName: professorName,
        questions: _questions,
        createdAt: widget.assignment?.createdAt ?? DateTime.now(),
        dueDate: _dueDate,
        publishedAt: DateTime.now(),
        status: AssignmentStatus.published,
        totalPoints: _getTotalPoints(),
        allowLateSubmissions: _allowLateSubmissions,
      );
      print("Assignment object created with ID: ${assignment.id}");

      if (widget.assignment == null) {
        print("Creating new assignment...");
        final assignmentId =
            await _assignmentService.createAssignment(assignment);
        print("Assignment created successfully with ID: $assignmentId");
        Get.snackbar("Success", "Assignment created and published",
            backgroundColor: TColor.success, colorText: TColor.onPrimary);
      } else {
        print("Updating existing assignment...");
        await _assignmentService.updateAssignment(assignment);
        print("Assignment updated successfully");
        Get.snackbar("Success", "Assignment updated and published",
            backgroundColor: TColor.success, colorText: TColor.onPrimary);
      }

      Get.back();
    } catch (e) {
      print("Error occurred: $e");
      Get.snackbar("Error", "Failed to save assignment: $e",
          backgroundColor: TColor.error, colorText: TColor.onPrimary);
    } finally {
      setState(() => _isLoading = false);
    }
  }
}

class QuestionDialog extends StatefulWidget {
  final Question? question;
  final Function(Question) onSave;

  const QuestionDialog({super.key, this.question, required this.onSave});

  @override
  State<QuestionDialog> createState() => _QuestionDialogState();
}

class _QuestionDialogState extends State<QuestionDialog> {
  late TextEditingController _questionController;
  late TextEditingController _pointsController;
  AssignmentType _selectedType = AssignmentType.shortAnswer;
  List<String> _options = [""];
  String? _correctAnswer;
  bool _isRequired = true;

  @override
  void initState() {
    super.initState();
    _questionController =
        TextEditingController(text: widget.question?.questionText ?? "");
    _pointsController = TextEditingController(
        text: widget.question?.maxPoints.toString() ?? "10");

    if (widget.question != null) {
      _selectedType = widget.question!.type;
      _options = widget.question!.options ?? [""];
      _correctAnswer = widget.question!.correctAnswer;
      _isRequired = widget.question!.isRequired;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: TColor.surface,
      title: Text(
        widget.question == null ? "Add Question" : "Edit Question",
        style: TextStyle(color: TColor.onSurface),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _questionController,
                style: TextStyle(color: TColor.onSurface),
                decoration: InputDecoration(
                  labelText: "Question Text",
                  labelStyle: TextStyle(color: TColor.onSurfaceVariant),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: TColor.onSurfaceVariant),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: TColor.primary),
                  ),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<AssignmentType>(
                      value: _selectedType,
                      style: TextStyle(color: TColor.onSurface),
                      decoration: InputDecoration(
                        labelText: "Question Type",
                        labelStyle: TextStyle(color: TColor.onSurfaceVariant),
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: TColor.onSurfaceVariant),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: TColor.primary),
                        ),
                      ),
                      items: AssignmentType.values.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(_getTypeText(type)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedType = value!;
                          if (_selectedType != AssignmentType.multipleChoice) {
                            _options = [""];
                            _correctAnswer = null;
                          }
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 100,
                    child: TextField(
                      controller: _pointsController,
                      style: TextStyle(color: TColor.onSurface),
                      decoration: InputDecoration(
                        labelText: "Points",
                        labelStyle: TextStyle(color: TColor.onSurfaceVariant),
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: TColor.onSurfaceVariant),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: TColor.primary),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              if (_selectedType == AssignmentType.multipleChoice) ...[
                const SizedBox(height: 16),
                Text("Options:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: TColor.onSurface,
                    )),
                const SizedBox(height: 8),
                ..._buildOptions(),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: _addOption,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColor.primary,
                    foregroundColor: TColor.onPrimary,
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text("Add Option"),
                ),
              ],
              const SizedBox(height: 16),
              SwitchListTile(
                title: Text("Required Question",
                    style: TextStyle(color: TColor.onSurface)),
                value: _isRequired,
                activeColor: TColor.primary,
                onChanged: (value) => setState(() => _isRequired = value),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child:
              Text("Cancel", style: TextStyle(color: TColor.onSurfaceVariant)),
        ),
        ElevatedButton(
          onPressed: _saveQuestion,
          style: ElevatedButton.styleFrom(
            backgroundColor: TColor.primary,
            foregroundColor: TColor.onPrimary,
          ),
          child: const Text("Save"),
        ),
      ],
    );
  }

  List<Widget> _buildOptions() {
    return _options.asMap().entries.map((entry) {
      final index = entry.key;
      final option = entry.value;

      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            Radio<String>(
              value: option,
              groupValue: _correctAnswer,
              activeColor: TColor.primary,
              onChanged: (value) => setState(() => _correctAnswer = value),
            ),
            Expanded(
              child: TextField(
                style: TextStyle(color: TColor.onSurface),
                decoration: InputDecoration(
                  hintText: "Option ${index + 1}",
                  hintStyle: TextStyle(color: TColor.onSurfaceVariant),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: TColor.onSurfaceVariant),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: TColor.primary),
                  ),
                ),
                onChanged: (value) {
                  _options[index] = value;
                  if (_correctAnswer == option && value != option) {
                    _correctAnswer = value;
                  }
                },
              ),
            ),
            if (_options.length > 1)
              IconButton(
                onPressed: () => _removeOption(index),
                icon: Icon(Icons.delete, color: TColor.error),
              ),
          ],
        ),
      );
    }).toList();
  }

  void _addOption() {
    setState(() {
      _options.add("");
    });
  }

  void _removeOption(int index) {
    setState(() {
      if (_correctAnswer == _options[index]) {
        _correctAnswer = null;
      }
      _options.removeAt(index);
    });
  }

  void _saveQuestion() {
    if (_questionController.text.trim().isEmpty) {
      Get.snackbar("Error", "Please enter question text");
      return;
    }

    final points = int.tryParse(_pointsController.text) ?? 10;
    if (points <= 0) {
      Get.snackbar("Error", "Points must be greater than 0");
      return;
    }

    if (_selectedType == AssignmentType.multipleChoice) {
      if (_options.where((o) => o.trim().isNotEmpty).length < 2) {
        Get.snackbar(
            "Error", "Multiple choice questions need at least 2 options");
        return;
      }
      if (_correctAnswer == null || _correctAnswer!.trim().isEmpty) {
        Get.snackbar("Error", "Please select the correct answer");
        return;
      }
    }

    final question = Question(
      id: widget.question?.id ?? const Uuid().v4(),
      questionText: _questionController.text.trim(),
      type: _selectedType,
      options: _selectedType == AssignmentType.multipleChoice
          ? _options.where((o) => o.trim().isNotEmpty).toList()
          : null,
      correctAnswer: _correctAnswer,
      maxPoints: points,
      isRequired: _isRequired,
    );

    widget.onSave(question);
    Navigator.pop(context);
  }

  String _getTypeText(AssignmentType type) {
    switch (type) {
      case AssignmentType.multipleChoice:
        return "Multiple Choice";
      case AssignmentType.shortAnswer:
        return "Short Answer";
      case AssignmentType.essay:
        return "Essay";
      case AssignmentType.survey:
        return "Survey";
      case AssignmentType.quiz:
        return "Quiz";
    }
  }
}
