// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, use_build_context_synchronously

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studymate/common_widgets/custom_button.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../common_widgets/custom_app_bar.dart';
import '../../controller/store_controller.dart';
import '../../theme.dart';

class BookedCourseDetail extends StatefulWidget {
  const BookedCourseDetail(
      {super.key,
      required this.courseID,
      required this.courseName,
      required this.courseField});
  final String courseID;
  final String courseName;
  final String courseField;
  @override
  State<BookedCourseDetail> createState() => _BookedCourseDetailState();
}

class _BookedCourseDetailState extends State<BookedCourseDetail>
    with TickerProviderStateMixin {
  final storeController = Get.put(StoreController());
  final comment = TextEditingController();
  double rate = 0.0;
  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: TColor.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30),
                CustomAppBar(),
                SizedBox(height: 80),
                FadeInDown(
                  delay: Duration(milliseconds: 600),
                  child: Center(
                      child: CourseCell2(
                    courseName: widget.courseName,
                    courseField: widget.courseField,
                    onTap: () {},
                  )),
                ),
                SizedBox(height: 50),
                FadeInDown(
                  delay: Duration(milliseconds: 700),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    width: double.infinity,
                    height: media.height * 0.4,
                    decoration: BoxDecoration(
                      color: TColor.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(1, 1.5),
                          blurRadius: 0.2,
                          blurStyle: BlurStyle.outer,
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 50),
                        Column(
                          children: [
                            Text(
                              "How was your experience?",
                              style: TextStyle(
                                color: TColor.onSurface,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 16),
                            RatingBar.builder(
                              initialRating: 0,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 32,
                              itemPadding:
                                  EdgeInsets.symmetric(horizontal: 8.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: TColor.accent,
                              ),
                              onRatingUpdate: (rating) {
                                print(rating);
                                rate = rating;
                                setState(() {});
                              },
                              glowColor: TColor.accent.withOpacity(0.4),
                            ),
                            SizedBox(height: 8),
                            Text(
                              rate == 0
                                  ? "Tap to rate"
                                  : rate < 2
                                      ? "Poor"
                                      : rate < 3
                                          ? "Fair"
                                          : rate < 4
                                              ? "Good"
                                              : "Excellent",
                              style: TextStyle(
                                color: rate == 0
                                    ? TColor.onSurfaceVariant
                                    : rate < 2
                                        ? TColor.error
                                        : rate < 3
                                            ? TColor.warning
                                            : rate < 4
                                                ? TColor.primary
                                                : TColor.success,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: TextField(
                            controller: comment,
                            maxLines: 3,
                            style: TextStyle(
                              color: TColor.onSurface,
                              fontSize: 14,
                            ),
                            decoration: InputDecoration(
                              hintText:
                                  "Share your thoughts about this course...",
                              hintStyle: TextStyle(
                                color: TColor.onSurfaceVariant,
                                fontSize: 14,
                              ),
                              filled: true,
                              fillColor: TColor.background,
                              contentPadding: EdgeInsets.all(16),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              prefixIcon: Icon(
                                Icons.message_outlined,
                                color: TColor.onSurfaceVariant,
                                size: 20,
                              ),
                              prefixIconConstraints: BoxConstraints(
                                minWidth: 40,
                                minHeight: 40,
                              ),
                              alignLabelWithHint: true,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 40),
                FadeInDown(
                  delay: Duration(milliseconds: 800),
                  child: Center(
                    child: SizedBox(
                      width: 200,
                      child: FadeInUp(
                        delay: Duration(milliseconds: 900),
                        child: ScaleTransition(
                          scale: Tween<double>(begin: 0.95, end: 1.0).animate(
                            CurvedAnimation(
                              parent: AnimationController(
                                vsync: this,
                                duration: Duration(milliseconds: 300),
                              )..forward(),
                              curve: Curves.easeOut,
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [TColor.primary, TColor.secondary],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: TColor.primary.withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () async {
                                  if (rate == 0) {
                                    Get.snackbar(
                                      "Rating Required",
                                      "Please rate the course before submitting",
                                      backgroundColor: TColor.warning,
                                      colorText: Colors.white,
                                      duration: Duration(seconds: 3),
                                    );
                                    return;
                                  }

                                  await storeController.sendFeedBack(
                                      widget.courseID, comment.text, rate);

                                  comment.clear();
                                  setState(() {
                                    rate = 0;
                                  });

                                  Get.snackbar(
                                    "Feedback Submitted",
                                    "Thank you for your feedback!",
                                    backgroundColor: TColor.success,
                                    colorText: Colors.white,
                                    duration: Duration(seconds: 3),
                                    icon: Icon(Icons.check_circle,
                                        color: Colors.white),
                                  );
                                },
                                borderRadius: BorderRadius.circular(20),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 14,
                                    horizontal: 22,
                                  ),
                                  child: Text(
                                    "Submit",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//=========the selected course cell===========
class CourseCell2 extends StatelessWidget {
  CourseCell2({
    super.key,
    required this.courseName,
    required this.courseField,
    required this.onTap,
  });
  void Function()? onTap;
  final String courseName;
  final String courseField;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: 20),
        width: 200,
        height: 220,
        decoration: BoxDecoration(
          color: TColor.surface,
          borderRadius: BorderRadius.circular(24),
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
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
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
              SizedBox(height: 12),
              Text(
                courseName,
                style: TextStyle(
                  color: TColor.onSurface,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 6),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: TColor.accent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: TColor.accent.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  courseField,
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
      ),
    );
  }
}
