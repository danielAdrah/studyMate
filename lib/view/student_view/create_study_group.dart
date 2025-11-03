import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../common_widgets/custom_app_bar.dart';
import '../../common_widgets/custome_text_field.dart';
import '../../controller/store_controller.dart';
import '../../services/study_group_service.dart';
import '../../theme.dart';

class CreateStudyGroup extends StatefulWidget {
  const CreateStudyGroup({super.key});

  @override
  State<CreateStudyGroup> createState() => _CreateStudyGroupState();
}

class _CreateStudyGroupState extends State<CreateStudyGroup> {
  final studyGroupService = StudyGroupService();
  final storeController = Get.put(StoreController());
  final groupNameController = TextEditingController();
  final descriptionController = TextEditingController();
  String? selectedCourseId;
  String? selectedCourseName;
  bool isCreating = false;

  @override
  void initState() {
    super.initState();
    // Fetch courses when the widget initializes
    storeController.getAllCourse();
  }

  @override
  void dispose() {
    groupNameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> createGroup() async {
    if (groupNameController.text.isEmpty || selectedCourseId == null) {
      Get.snackbar(
        "Error",
        "Please enter a group name and select a course",
        backgroundColor: TColor.error,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        // snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    setState(() {
      isCreating = true;
    });

    try {
      final groupId = await studyGroupService.createStudyGroup(
        groupNameController.text,
        selectedCourseId!,
        selectedCourseName!,
        descriptionController.text.isNotEmpty
            ? descriptionController.text
            : null,
      );

      // Send notification to group members
      // await studyGroupService.sendGroupNotification(
      //   groupId,
      //   "New Study Group Created",
      //   "${groupNameController.text} has been created for ${selectedCourseName!}",
      // );

      // Show success message
      Get.snackbar(
        "Success",
        "Study group created successfully!",
        backgroundColor: TColor.success,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );

      // Navigate back to study groups view
      Get.back();
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to create study group: ${e.toString()}",
        backgroundColor: TColor.error,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      setState(() {
        isCreating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.background,
      appBar: AppBar(
        title: const Text("Create Study Group"),
        backgroundColor: TColor.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: TColor.onSurface),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Group Name Field
            CustomTextForm(
              hinttext: "Enter group name",
              mycontroller: groupNameController,
              secure: false,
              color: TColor.primary,
              onChanged: (value) {},
            ),
            const SizedBox(height: 20),

            // Course Selection
            _buildCourseSelection(),
            const SizedBox(height: 20),

            // Description Field
            CustomTextForm(
              hinttext: "Add a description (optional)",
              mycontroller: descriptionController,
              secure: false,
              color: TColor.primary,
              maxLines: 3,
              onChanged: (value) {},
            ),
            const SizedBox(height: 40),

            // Create Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isCreating ? null : createGroup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: TColor.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: isCreating
                    ? const CircularProgressIndicator.adaptive()
                    : const Text(
                        "Create Group",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseSelection() {
    return StreamBuilder<List<QueryDocumentSnapshot>>(
      stream: storeController.allCourse.stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        final courses = snapshot.data ?? [];

        if (courses.isEmpty) {
          return _buildEmptyCourses();
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: TColor.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: TColor.primary.withOpacity(0.2)),
          ),
          child: DropdownButton<String>(
            value: selectedCourseId,
            isExpanded: true,
            underline: Container(),
            hint: Text(
              "Select a course",
              style: TextStyle(
                color: TColor.onSurfaceVariant,
              ),
            ),
            items: courses.map((course) {
              final courseId = course.id;
              final courseName = course['courseName'] as String;
              return DropdownMenuItem(
                value: courseId,
                child: Text(courseName),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                // Find the selected course to get its name
                final selectedCourse = courses.firstWhere(
                  (course) => course.id == newValue,
                );
                setState(() {
                  selectedCourseId = newValue;
                  selectedCourseName = selectedCourse['courseName'] as String;
                });
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildEmptyCourses() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TColor.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: TColor.error.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning,
            color: TColor.error,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "No courses available. Please check your course enrollment.",
              style: TextStyle(
                color: TColor.error,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
