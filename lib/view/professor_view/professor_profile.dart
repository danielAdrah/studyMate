// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studymate/controller/store_controller.dart';

import '../../common_widgets/custome_text_field.dart';
import '../../controller/cours_controller.dart';
import '../../theme.dart';
import '../auth_view/log_in.dart';
import '../student_view/notification_view.dart';

class ProfessorProfile extends StatefulWidget {
  const ProfessorProfile({super.key});

  @override
  State<ProfessorProfile> createState() => _ProfessorProfileState();
}

class _ProfessorProfileState extends State<ProfessorProfile>
    with TickerProviderStateMixin {
  final controller = Get.put(CoursController());
  final storeController = Get.put(StoreController());
  final newName = TextEditingController();
  final newSpecailty = TextEditingController();
  final newPass = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;

  // Animations
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _headerAnimation;
  late Animation<double> _personalInfoAnimation;
  late Animation<double> _optionsAnimation;

  clearField() {
    newName.clear();
    newSpecailty.clear();
  }

  updateUserInfo(String userId, newName, newSpecailty) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'name': newName,
        'specialty': newSpecailty,
      });
      storeController.fetchUserData();

      // Show success confirmation
      Get.snackbar(
        "Profile Updated",
        "Your information has been updated successfully",
        backgroundColor: TColor.success,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        icon: const Icon(Icons.check_circle, color: Colors.white),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } catch (e) {
      // Show error message
      Get.snackbar(
        "Update Failed",
        "Failed to update profile information. Please try again.",
        backgroundColor: TColor.error,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.BOTTOM,
        icon: const Icon(Icons.error, color: Colors.white),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    storeController.fetchUserData();

    // Initialize animation controllers
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Initialize animations
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    // Staggered animations for different sections
    _headerAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
    ));

    _personalInfoAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: const Interval(0.3, 0.7, curve: Curves.easeOut),
    ));

    _optionsAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
    ));

    // Start animations
    _startAnimations();
  }

  void _startAnimations() {
    Future.delayed(const Duration(milliseconds: 100), () {
      _fadeController.forward();
      _slideController.forward();
      _scaleController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                // Animated profile header
                FadeTransition(
                  opacity: _headerAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Column(
                        children: [
                          Hero(
                            tag: "profile-avatar",
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  width: 140,
                                  height: 140,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        TColor.primary,
                                        TColor.secondary
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: TColor.primary.withOpacity(0.3),
                                        blurRadius: 15,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: CircleAvatar(
                                      radius: 66,
                                      backgroundImage: controller
                                                  .imagePath.value ==
                                              null
                                          ? const AssetImage(
                                              "assets/img/user.png")
                                          : FileImage(File(
                                                  controller.imagePath.value!))
                                              as ImageProvider<Object>?,
                                      backgroundColor: TColor.surface,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    controller.uploadImage();
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: TColor.primary,
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              TColor.primary.withOpacity(0.4),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: Text(
                              storeController.userFullName.value.isEmpty
                                  ? "User Name"
                                  : storeController.userFullName.value,
                              key: ValueKey(storeController.userFullName.value),
                              style: TextStyle(
                                color: TColor.onSurface,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: Text(
                              storeController.userSpecialty.value.isEmpty
                                  ? "Student"
                                  : storeController.userSpecialty.value,
                              key:
                                  ValueKey(storeController.userSpecialty.value),
                              style: TextStyle(
                                color: TColor.onSurfaceVariant,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // Animated content
                FadeTransition(
                  opacity: _personalInfoAnimation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.2),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: _slideController,
                      curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
                    )),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Personal Information Section
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Personal Information",
                                style: TextStyle(
                                  color: TColor.onSurface,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 36,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    customDialog(context, newName, newSpecailty,
                                        () {
                                      updateUserInfo(auth.currentUser!.uid,
                                          newName.text, newSpecailty.text);
                                      Get.back();
                                      clearField();
                                    });
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                    size: 16,
                                    color: TColor.primary,
                                  ),
                                  label: Text(
                                    "Edit",
                                    style: TextStyle(
                                      color: TColor.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: TColor.background,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: BorderSide(
                                        color: TColor.primary.withOpacity(0.3),
                                        width: 1,
                                      ),
                                    ),
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: TColor.surface,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: TColor.primary.withOpacity(0.2)),
                              boxShadow: [
                                BoxShadow(
                                  color: TColor.primary.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                InfoTile(
                                  onTap: () {},
                                  title: "Name",
                                  child: Text(
                                      storeController.userFullName.value,
                                      style: TextStyle(
                                          color: TColor.onSurfaceVariant,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500)),
                                  icon: Icons.person,
                                  isLast: false,
                                ),
                                InfoTile(
                                  title: "E-mail",
                                  onTap: () {},
                                  child: Text(storeController.userMail.value,
                                      style: TextStyle(
                                          color: TColor.onSurfaceVariant,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500)),
                                  icon: Icons.mail,
                                  isLast: false,
                                ),
                                InfoTile(
                                  title: "Specialty",
                                  onTap: () {},
                                  child: Text(
                                      storeController.userSpecialty.value,
                                      style: TextStyle(
                                          color: TColor.onSurfaceVariant,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500)),
                                  icon: Icons.add_chart_outlined,
                                  isLast: false,
                                ),
                                InfoTile(
                                  title: "Password",
                                  onTap: () {},
                                  child: Text("Change Password",
                                      style: TextStyle(
                                          color: TColor.primary,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500)),
                                  icon: Icons.security,
                                  isLast: true,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 35),
                          // Other Options Section
                          FadeTransition(
                            opacity: _optionsAnimation,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20, bottom: 12),
                                  child: Text(
                                    "Other Options",
                                    style: TextStyle(
                                        color: TColor.onSurface,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: TColor.surface,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: TColor.primary.withOpacity(0.2)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: TColor.primary.withOpacity(0.1),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      InfoTile(
                                        onTapGen: () async {
                                          Get.to(const NotificationView());
                                        },
                                        title: "Notifications",
                                        onTap: () {},
                                        child: const SizedBox(),
                                        icon: Icons.notifications,
                                        isLast: false,
                                      ),
                                      InfoTile(
                                        onTapGen: () async {
                                          await FirebaseAuth.instance.signOut();
                                          Get.off(const LogIn());
                                        },
                                        title: "Log Out",
                                        onTap: () {},
                                        child: const SizedBox(),
                                        icon: Icons.logout,
                                        isLast: true,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 35),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  InfoTile({
    super.key,
    required this.title,
    required this.icon,
    required this.child,
    required this.onTap,
    this.onTapGen,
    this.isLast = false,
  });

  final String title;
  final IconData icon;
  final Widget child;
  final VoidCallback? onTapGen;
  final VoidCallback? onTap;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: !isLast
            ? Border(bottom: BorderSide(color: TColor.primary.withOpacity(0.2)))
            : null,
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            TColor.primary.withOpacity(0.05),
            Colors.transparent,
          ],
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTapGen,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: TColor.primary.withOpacity(0.1),
                  ),
                  child: Icon(
                    icon,
                    color: TColor.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: TColor.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (onTap != null)
                        InkWell(
                          onTap: onTap,
                          child: DefaultTextStyle(
                            style: TextStyle(
                              color: TColor.onSurfaceVariant,
                              fontSize: 14,
                            ),
                            child: child,
                          ),
                        )
                      else
                        DefaultTextStyle(
                          style: TextStyle(
                            color: TColor.onSurfaceVariant,
                            fontSize: 14,
                          ),
                          child: child,
                        ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: TColor.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//==========Enhanced Edit Profile Dialog==============
Future<dynamic> customDialog(
  BuildContext context,
  TextEditingController name,
  TextEditingController specialty,
  void Function()? updateOnTap,
) {
  final _formKey = GlobalKey<FormState>();

  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: TColor.surface,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: TColor.primary.withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: TColor.primary.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with icon
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [TColor.primary, TColor.secondary],
                  ),
                ),
                child: const Icon(
                  Icons.edit,
                  size: 30,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Edit Profile",
                style: TextStyle(
                  color: TColor.onSurface,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Update your information",
                style: TextStyle(
                  color: TColor.onSurfaceVariant,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 15),

              // Form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: TColor.background,
                        borderRadius: BorderRadius.circular(12),
                        border:
                            Border.all(color: TColor.primary.withOpacity(0.2)),
                      ),
                      child: TextFormField(
                        controller: name,
                        decoration: InputDecoration(
                          labelText: "Full Name",
                          labelStyle: TextStyle(color: TColor.primary),
                          prefixIcon: Icon(Icons.person, color: TColor.primary),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your name';
                          }
                          if (value.trim().length < 2) {
                            return 'Name must be at least 2 characters';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: TColor.background,
                        borderRadius: BorderRadius.circular(12),
                        border:
                            Border.all(color: TColor.primary.withOpacity(0.2)),
                      ),
                      child: TextFormField(
                        controller: specialty,
                        decoration: InputDecoration(
                          labelText: "Specialty",
                          labelStyle: TextStyle(color: TColor.primary),
                          prefixIcon: Icon(Icons.school, color: TColor.primary),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your specialty';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: OutlinedButton(
                        onPressed: () {
                          Get.back();
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                              color: TColor.primary.withOpacity(0.5)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            color: TColor.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            updateOnTap?.call();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TColor.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: const Text(
                          "Update",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

//===========community button==================
class CommunityBtn extends StatelessWidget {
  CommunityBtn({
    super.key,
    required this.title,
    required this.onTap,
  });
  final String title;
  void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
        decoration: BoxDecoration(
          color: TColor.primary,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          title,
          style: TextStyle(color: TColor.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
