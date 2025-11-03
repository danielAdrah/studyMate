// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, use_build_context_synchronously

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:studymate/common_widgets/custom_button.dart';
import '../../common_widgets/custom_app_bar.dart';
import '../../controller/cours_controller.dart';
import '../../controller/sign_up_controller.dart';
import '../../controller/store_controller.dart';
import '../../services/notification_service.dart';
import '../../theme.dart';

class CourseReservation extends StatefulWidget {
  const CourseReservation(
      {super.key,
      required this.courseName,
      required this.courseField,
      required this.courseID});
  final String courseName;
  final String courseField;
  final String courseID;

  @override
  State<CourseReservation> createState() => _CourseReservationState();
}

class _CourseReservationState extends State<CourseReservation>
    with TickerProviderStateMixin {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final notiService = NotificationService();
  final coursCont = Get.put(CoursController());
  final authController = Get.put(SignUpController());
  final storeController = Get.put(StoreController());
  final courseDate = TextEditingController();
  final courseTime = TextEditingController();
  final min = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  bool isBooking = false; // Add loading state

  void updateDateTime(DateTime date, TimeOfDay time) {
    setState(() {
      selectedDate = date;
      selectedTime = time;
    });
  }

  void clearFields() {
    courseDate.clear();
    courseTime.clear();
    min.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.background,
      body: CustomScrollView(
        slivers: [
          // Modern App Bar
          SliverAppBar(
            expandedHeight: 100,
            floating: true,
            pinned: true,
            backgroundColor: TColor.background,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 30),
                    FadeInDown(
                      delay: Duration(milliseconds: 300),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [TColor.primary, TColor.secondary],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: TColor.primary.withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.book_online_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Book Course",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: TColor.black,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Select your preferred details",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: TColor.black.withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),

          // Course Selection Section
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  FadeInDown(
                    delay: Duration(milliseconds: 500),
                    child: _buildCoursePreview(),
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ),
          ),

          // Booking Form
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  FadeInDown(
                    delay: Duration(milliseconds: 700),
                    child: _buildProfessorSelection(),
                  ),
                  SizedBox(height: 24),
                  FadeInDown(
                    delay: Duration(milliseconds: 800),
                    child: _buildDateSelection(),
                  ),
                  SizedBox(height: 24),
                  FadeInDown(
                    delay: Duration(milliseconds: 900),
                    child: _buildTimeSelection(),
                  ),
                  SizedBox(height: 50),
                  FadeInUp(
                    delay: Duration(milliseconds: 1000),
                    child: _buildBookingButton(),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Enhanced Course Preview
  Widget _buildCoursePreview() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            TColor.primary.withOpacity(0.1),
            TColor.secondary.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: TColor.primary.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: TColor.primary.withOpacity(0.1),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [TColor.primary, TColor.secondary],
                    ),
                  ),
                  child: Center(
                    child: Image.asset(
                      "assets/img/online-course.png",
                      width: 40,
                      height: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.courseName,
                        style: TextStyle(
                          color: TColor.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: TColor.accent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: TColor.accent.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          widget.courseField,
                          style: TextStyle(
                            color: TColor.accent,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            LinearProgressIndicator(
              value: 0.68,
              backgroundColor: TColor.primary.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation(TColor.primary),
              minHeight: 6,
              borderRadius: BorderRadius.circular(3),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Course Progress",
                  style: TextStyle(
                    color: TColor.black.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
                Text(
                  "68% Complete",
                  style: TextStyle(
                    color: TColor.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String? selectedProfessor;

  // Professor Selection Section
  Widget _buildProfessorSelection() {
    return Container(
      decoration: BoxDecoration(
        color: TColor.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: TColor.primary.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: TColor.primary.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select Professor",
              style: TextStyle(
                color: TColor.onSurface,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16),
            StreamBuilder<List<Map<String, dynamic>>>(
              stream: storeController.getProfessorStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Text('Error loading professors');
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No professors available');
                }

                List<Map<String, dynamic>> professors = snapshot.data!;

                return DropdownButtonFormField<String>(
                  value: selectedProfessor,
                  isExpanded: true,
                  decoration: InputDecoration(
                    hintText: "Choose a professor",
                    hintStyle: TextStyle(color: TColor.onSurfaceVariant),
                    filled: true,
                    fillColor: TColor.background,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: professors.map<DropdownMenuItem<String>>((professor) {
                    return DropdownMenuItem<String>(
                      value: professor['name'] as String,
                      child: Text(
                        professor['name'] as String,
                        style: TextStyle(color: TColor.onSurface),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedProfessor = value;
                    });
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Date Selection Section
  Widget _buildDateSelection() {
    return Container(
      decoration: BoxDecoration(
        color: TColor.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: TColor.primary.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: TColor.primary.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select Date",
              style: TextStyle(
                color: TColor.onSurface,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2030),
                  builder: (context, child) {
                    return Theme(
                      data: ThemeData().copyWith(
                        colorScheme: ColorScheme.light(
                          primary: TColor.primary,
                          onPrimary: Colors.white,
                          onSurface: TColor.onSurface,
                        ),
                        textButtonTheme: TextButtonThemeData(
                          style: TextButton.styleFrom(
                            foregroundColor: TColor.primary,
                          ),
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (picked != null) {
                  setState(() {
                    selectedDate = picked;
                  });
                }
              },
              child: Container(
                height: 55,
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: TColor.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: TColor.primary,
                      size: 20,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                        style: TextStyle(
                          color: selectedDate == DateTime.now()
                              ? TColor.onSurfaceVariant
                              : TColor.onSurface,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                      color: TColor.onSurfaceVariant,
                      size: 24,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Time Selection Section
  Widget _buildTimeSelection() {
    return Container(
      decoration: BoxDecoration(
        color: TColor.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: TColor.primary.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: TColor.primary.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select Time",
              style: TextStyle(
                color: TColor.onSurface,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: selectedTime,
                  builder: (context, child) {
                    return Theme(
                      data: ThemeData().copyWith(
                        colorScheme: ColorScheme.light(
                          primary: TColor.primary,
                          onPrimary: Colors.white,
                          onSurface: TColor.onSurface,
                        ),
                        textButtonTheme: TextButtonThemeData(
                          style: TextButton.styleFrom(
                            foregroundColor: TColor.primary,
                          ),
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (pickedTime != null) {
                  setState(() {
                    selectedTime = pickedTime;
                  });
                }
              },
              child: Container(
                height: 55,
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: TColor.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      color: TColor.primary,
                      size: 20,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        selectedTime.format(context),
                        style: TextStyle(
                          color: TColor.onSurface,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                      color: TColor.onSurfaceVariant,
                      size: 24,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Booking Button Section
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    storeController.fetchUserData();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  // Format date and time for display
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dateTime =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('h:mm a').format(dateTime);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildBookingButton() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: SizedBox(
        width: double.infinity,
        child: FadeInUp(
          delay: Duration(milliseconds: 1200),
          child: GestureDetector(
            onTapDown: (_) {
              _controller.forward();
            },
            onTapUp: (_) {
              _controller.reverse();
            },
            onTapCancel: () {
              _controller.reverse();
            },
            onTap: () async {
              // Prevent multiple taps while booking
              if (isBooking) return;

              // Validate that all fields are filled
              if (selectedProfessor == null) {
                Get.snackbar(
                  "Error",
                  "Please select a professor",
                  backgroundColor: TColor.error,
                  colorText: Colors.white,
                  duration: Duration(seconds: 3),
                );
                return;
              }

              // Set loading state
              if (mounted) {
                setState(() {
                  isBooking = true;
                });
              }

              try {
                // Check if user has already booked this course
                final hasBooked =
                    await storeController.hasUserBookedCourse(widget.courseID);
                if (hasBooked) {
                  Get.snackbar(
                    "Already Booked",
                    "You have already booked this course",
                    backgroundColor: TColor.warning,
                    colorText: Colors.white,
                    duration: Duration(seconds: 3),
                  );
                  return;
                }

                // Call the reservation logic from StoreController
                await storeController.reserveCourse(
                  widget.courseName,
                  widget.courseField,
                  selectedProfessor!,
                  _formatDate(selectedDate),
                  _formatTime(selectedTime),
                  widget.courseID,
                  context,
                );

                // Show success dialog
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    icon: Icon(
                      Icons.check_circle_outline,
                      size: 48,
                      color: TColor.success,
                    ),
                    title: Text(
                      "Reservation Confirmed",
                      style: TextStyle(
                        color: TColor.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    content: Text(
                      "Your course has been successfully booked with $selectedProfessor on ${_formatDate(selectedDate)} at ${_formatTime(selectedTime)}.",
                      style: TextStyle(color: TColor.onSurfaceVariant),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Get.back();
                          Get.back(); // Close the reservation page
                        },
                        child: Text("OK"),
                      ),
                    ],
                  ),
                );

                // Schedule notification for the booked course
                try {
                  await notiService.scheduleNotification(
                    id: widget.courseID.hashCode,
                    title: "Upcoming Course: ${widget.courseName}",
                    body:
                        "Don't forget your course with $selectedProfessor today at ${_formatTime(selectedTime)}",
                    hour: selectedTime.hour,
                    minute: selectedTime.minute,
                  );

                  // Store notification in Firebase for display in notification view
                  await storeController.createNotification(
                    userId: auth.currentUser!.uid,
                    title: "Upcoming Course: ${widget.courseName}",
                    body:
                        "Don't forget your course with $selectedProfessor on ${_formatDate(selectedDate)} at ${_formatTime(selectedTime)}",
                    courseId: widget.courseID,
                    courseName: widget.courseName,
                    courseField: widget.courseField,
                    professor: selectedProfessor,
                    scheduledDate: DateTime(
                      selectedDate.year,
                      selectedDate.month,
                      selectedDate.day,
                      selectedTime.hour,
                      selectedTime.minute,
                    ),
                    type: 'course_reminder',
                    // notificationId:
                  );

                  print(
                      "Scheduled notification for course: ${widget.courseName}");
                } catch (e) {
                  print("Failed to schedule notification: $e");
                  Get.snackbar(
                    "Notification Error",
                    "Could not schedule reminder",
                    backgroundColor: TColor.error,
                    colorText: Colors.white,
                    duration: Duration(seconds: 3),
                  );
                }

                // Send Firebase notification to the selected professor
                try {
                  // Get current student name
                  final currentUserName =
                      await storeController.getCurrentUserName();

                  // Get professor's device token
                  final professorToken = await storeController
                      .getProfessorDeviceToken(selectedProfessor!);

                  if (professorToken != null && professorToken.isNotEmpty) {
                    // Send notification to professor
                    await notiService.sendNotifications(
                      "New course booking from $currentUserName for ${widget.courseName} on ${_formatDate(selectedDate)} at ${_formatTime(selectedTime)}",
                      "New Course Booking",
                      professorToken,
                    );

                    // Also store notification in professor's Firebase for in-app display
                    final professorUserId = await storeController
                        .getProfessorUserId(selectedProfessor!);
                    if (professorUserId != null) {
                      await storeController.createNotification(
                        userId: professorUserId,
                        title: "New Course Booking",
                        body:
                            "$currentUserName has booked your ${widget.courseName} course for ${_formatDate(selectedDate)} at ${_formatTime(selectedTime)}",
                        courseId: widget.courseID,
                        courseName: widget.courseName,
                        courseField: widget.courseField,
                        professor: selectedProfessor,
                        scheduledDate: DateTime(
                          selectedDate.year,
                          selectedDate.month,
                          selectedDate.day,
                          selectedTime.hour,
                          selectedTime.minute,
                        ),
                        type: 'course_booking',
                      );
                    }

                    print(
                        "Firebase notification sent to professor: $selectedProfessor");
                  } else {
                    print("Professor device token not found or empty");
                    // Show warning to user but don't prevent booking
                    Get.snackbar(
                      "Professor Notification",
                      "Course booked successfully, but couldn't notify professor",
                      backgroundColor: TColor.warning,
                      colorText: Colors.white,
                      duration: Duration(seconds: 3),
                    );
                  }
                } catch (e) {
                  print("Failed to send notification to professor: $e");
                  // Don't show error to user as booking was successful
                }
              } catch (e) {
                Get.snackbar(
                  "Error",
                  "Failed to book course: ${e.toString()}",
                  backgroundColor: TColor.error,
                  colorText: Colors.white,
                  duration: Duration(seconds: 3),
                );
              } finally {
                // Reset loading state
                if (mounted) {
                  setState(() {
                    isBooking = false;
                  });
                }
              }
            },
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.95, end: 1.0).animate(
                CurvedAnimation(
                  parent: _controller,
                  curve: Curves.easeOut,
                ),
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 60, vertical: 18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [TColor.primary, TColor.secondary],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: isBooking
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Text(
                          "Book Course",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

//==========this is a dialog==============
  Future<dynamic> customDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              icon: Icon(
                Icons.info_outline,
                size: 50,
                color: TColor.primary,
              ),
              backgroundColor: TColor.background,
              title: Center(
                  child: Column(
                children: [
                  Text(
                    "Please Be Aware",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 19,
                        color: TColor.black),
                  ),
                  Text(
                    "The fields can't be empty ",
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 17,
                        color: TColor.black),
                  ),
                ],
              )),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 50, vertical: 30),
              content: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 13, horizontal: 15),
                  decoration: BoxDecoration(
                    color: TColor.primary,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "OK",
                        style: TextStyle(
                            color: TColor.white, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              )
              // actions: [
              //   CommunityBtn(
              //     title: "Ok",
              //     onTap: () {
              //       Get.back();
              //     },
              //   ),
              // ],
              );
        });
  }

  //this method to select a date
  Future<void> showDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(3000),
      barrierColor: Colors.grey,
    );
    if (picked != null) {
      courseDate.text = picked.toString().substring(0, 10);
      print(courseDate.text);
    }
  }

  //method to select a time

  Future<void> showTimePicke() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(DateTime.now()),
    );
    if (pickedTime != null) {
      courseTime.text = pickedTime.format(context).toString();
      storeController.min.value = '${pickedTime.hour}:${pickedTime.minute}';
      print(courseTime.text);
    }
  }
}

//=========the selected course cell===========
class CourseCell2 extends StatelessWidget {
  CourseCell2({
    super.key,
    required this.courseName,
    required this.courseField,
    required this.onTap,

    // required this.courseImg,
  });
  void Function()? onTap;
  final String courseName;
  final String courseField;
  // final String courseImg;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: 20),
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(1, 1.5),
              blurRadius: 0.2,
              blurStyle: BlurStyle.outer,
            )
          ],
          borderRadius: BorderRadius.circular(20),
          color: TColor.white,
        ),
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                height: 130,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: TColor.primary,
                ),
                child: Center(
                  child: Image.asset("assets/img/online-course.png"),
                ),
              ),
              SizedBox(height: 6),
              Text(
                courseName,
                style: TextStyle(
                    color: TColor.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                courseField,
                style: TextStyle(
                    color: TColor.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//===========textField to display course date============
class DateTextField extends StatelessWidget {
  DateTextField(
      {super.key,
      required this.onTap,
      required this.controller,
      required this.width});
  void Function()? onTap;
  TextEditingController controller;
  final double width;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 2),
      height: 50,
      width: width,
      decoration: BoxDecoration(
        color: TColor.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: TextField(
          onTap: onTap,
          // readOnly: true,
          style:
              TextStyle(color: TColor.black, decoration: TextDecoration.none),
          controller: controller,
          obscureText: false,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 10),
            focusedBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
          ),
        ),
      ),
    );
  }
}

//=====
class DateTextField2 extends StatelessWidget {
  DateTextField2(
      {super.key,
      required this.onTap,
      required this.controller,
      required this.width});
  void Function()? onTap;
  TextEditingController controller;
  final double width;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 2),
      height: 50,
      width: width,
      decoration: BoxDecoration(
        color: TColor.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: TextField(
          onTap: onTap,
          readOnly: true,
          style:
              TextStyle(color: TColor.black, decoration: TextDecoration.none),
          controller: controller,
          obscureText: false,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 10),
            focusedBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
