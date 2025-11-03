// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, body_might_complete_normally_nullable, avoid_print, unused_local_variable, use_build_context_synchronously, unnecessary_null_comparison, unnecessary_null_in_if_null_operators, unused_import

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../common_widgets/custom_button.dart';
import '../../common_widgets/custome_text_field.dart';
import '../../controller/sign_up_controller.dart';
import '../../theme.dart';
import '../professor_view/professor_main_nav_bar.dart';
import '../student_view/student_main_nav_bar.dart';
import 'sign_up.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> with TickerProviderStateMixin {
  final controller = Get.put(SignUpController());
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController mailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  bool isSecure = true;
  bool _isFormValid = false;
  String? _errorMessage;
  bool _hasError = false;
  AnimationController? _shakeController;
  Animation<double>? _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(
      begin: 0.0,
      end: 10.0,
    ).animate(CurvedAnimation(
      parent: _shakeController!,
      curve: Curves.elasticIn,
    ));

    // Listen to text changes for form validation
    mailController.addListener(_validateForm);
    passController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _shakeController?.dispose();
    mailController.dispose();
    passController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      _isFormValid = mailController.text.isNotEmpty &&
          passController.text.isNotEmpty &&
          RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
              .hasMatch(mailController.text);
      // Clear error when user starts typing
      if (_hasError &&
          (_isFormValid ||
              mailController.text.isNotEmpty ||
              passController.text.isNotEmpty)) {
        _clearError();
      }
    });
  }

  void _shakeForm() {
    HapticFeedback.lightImpact();
    _shakeController?.forward().then((_) => _shakeController?.reverse());
  }

  void _showErrorState(String message) {
    setState(() {
      _hasError = true;
      _errorMessage = message;
    });
    HapticFeedback.heavyImpact();
    _shakeController?.forward().then((_) => _shakeController?.reverse());
  }

  void _clearError() {
    setState(() {
      _hasError = false;
      _errorMessage = null;
    });
  }

  Future<void> _handleLogin() async {
    if (formState.currentState!.validate()) {
      // Clear any previous errors
      _clearError();

      // Store initial route to detect if navigation occurred
      final currentRoute = ModalRoute.of(context)?.settings.name;

      try {
        await controller.logIn(
          mailController.text,
          passController.text,
          context,
        );

        // Wait a bit to let the loading state settle
        await Future.delayed(Duration(milliseconds: 500));

        // Check if we're still on the same route (login failed)
        if (mounted &&
            ModalRoute.of(context)?.settings.name == currentRoute &&
            !controller.logInLoading.value) {
          // If we're still here and not loading, login probably failed
          _showErrorState(
              "Invalid email or password. Please check your credentials and try again.");
        }
      } catch (e) {
        _showErrorState("Login failed. Please check your credentials.");
      }
    } else {
      _shakeForm();
    }
  }

  Future<String?> determineUserRole(String uid) async {
    try {
      List<Map<String, dynamic>> allDocuments = await FirebaseFirestore.instance
          .collection('students')
          .doc(uid)
          .get()
          .then((value) => [value.data() ?? {}])
          .then((value) async => [
                ...value,
                ...(await FirebaseFirestore.instance
                    .collection('professors')
                    .doc(uid)
                    .get()
                    .then((doc) => [doc.data() ?? {}]))
              ]);

      String? role = allDocuments.firstWhereOrNull(
              (element) => element.containsKey('role'))?['role'] ??
          null;

      if (role == null) {
        print('User not found in either Students or Professors collection');
      }

      return role;
    } catch (e) {
      print('Error fetching user role: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: TColor.background,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              TColor.background,
              TColor.primary.withOpacity(0.05),
              TColor.secondary.withOpacity(0.03),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: height * 0.02),

                    // Logo and Welcome Section
                    FadeInDown(
                      delay: Duration(milliseconds: 300),
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: TColor.surface,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: TColor.primary.withOpacity(0.1),
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: TColor.primary.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Image.asset(
                                "assets/img/logo2.png",
                                width: 120,
                                height: 120,
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              "Welcome Back!",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: TColor.onSurface,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Sign in to continue your learning journey",
                              style: TextStyle(
                                fontSize: 16,
                                color: TColor.onSurfaceVariant,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 40),

                    // Login Form (using simpler approach without complex animations)
                    FadeInDown(
                      delay: Duration(milliseconds: 500),
                      child: Container(
                        padding: EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: TColor.surface,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: TColor.primary.withOpacity(0.08),
                              blurRadius: 25,
                              offset: Offset(0, 15),
                            ),
                          ],
                        ),
                        child: Form(
                          key: formState,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Email Field
                              Text(
                                "Email Address",
                                style: TextStyle(
                                  color: TColor.onSurface,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 12),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: TColor.primary.withOpacity(0.1),
                                      blurRadius: 10,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: TextFormField(
                                  controller: mailController,
                                  keyboardType: TextInputType.emailAddress,
                                  style: TextStyle(
                                    color: TColor.onSurface,
                                    fontSize: 16,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "Enter your email address",
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: TColor.onSurfaceVariant,
                                    ),
                                    prefixIcon: Container(
                                      margin: EdgeInsets.all(12),
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: TColor.primary.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        Icons.email_outlined,
                                        color: TColor.primary,
                                        size: 20,
                                      ),
                                    ),
                                    suffixIcon: mailController.text.isNotEmpty
                                        ? Icon(
                                            RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                                    .hasMatch(
                                                        mailController.text)
                                                ? Icons.check_circle
                                                : Icons.error,
                                            color:
                                                RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                                        .hasMatch(
                                                            mailController.text)
                                                    ? TColor.success
                                                    : TColor.error,
                                          )
                                        : null,
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 20,
                                      horizontal: 20,
                                    ),
                                    filled: true,
                                    fillColor: TColor.background,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide.none,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                        color: TColor.primary.withOpacity(0.1),
                                        width: 1,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                        color: TColor.primary,
                                        width: 2,
                                      ),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                        color: TColor.error,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  validator: (val) {
                                    if (val == null || val.isEmpty) {
                                      return "Email address is required";
                                    }
                                    if (!RegExp(
                                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                        .hasMatch(val)) {
                                      return "Please enter a valid email address";
                                    }
                                    return null;
                                  },
                                ),
                              ),

                              SizedBox(height: 24),

                              // Password Field
                              Text(
                                "Password",
                                style: TextStyle(
                                  color: TColor.onSurface,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 12),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: TColor.primary.withOpacity(0.1),
                                      blurRadius: 10,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: TextFormField(
                                  controller: passController,
                                  obscureText: isSecure,
                                  style: TextStyle(
                                    color: TColor.onSurface,
                                    fontSize: 16,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "Enter your password",
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: TColor.onSurfaceVariant,
                                    ),
                                    prefixIcon: Container(
                                      margin: EdgeInsets.all(12),
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: TColor.primary.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        Icons.lock_outline,
                                        color: TColor.primary,
                                        size: 20,
                                      ),
                                    ),
                                    suffixIcon: InkWell(
                                      onTap: () {
                                        HapticFeedback.lightImpact();
                                        setState(() {
                                          isSecure = !isSecure;
                                        });
                                      },
                                      borderRadius: BorderRadius.circular(12),
                                      child: Container(
                                        margin: EdgeInsets.all(12),
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: TColor.onSurfaceVariant
                                              .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Icon(
                                          isSecure
                                              ? Icons.visibility_off_outlined
                                              : Icons.visibility_outlined,
                                          color: TColor.onSurfaceVariant,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 20,
                                      horizontal: 20,
                                    ),
                                    filled: true,
                                    fillColor: TColor.background,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide.none,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                        color: TColor.primary.withOpacity(0.1),
                                        width: 1,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                        color: TColor.primary,
                                        width: 2,
                                      ),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                        color: TColor.error,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  validator: (val) {
                                    if (val == null || val.isEmpty) {
                                      return "Password is required";
                                    }
                                    return null;
                                  },
                                ),
                              ),

                              SizedBox(height: 16),

                              // Forgot Password
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    HapticFeedback.lightImpact();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            "Forgot password feature coming soon!"),
                                        backgroundColor: TColor.warning,
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "Forgot Password?",
                                    style: TextStyle(
                                      color: TColor.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),

                              // Error Message Display
                              if (_hasError)
                                AnimatedScale(
                                  scale: _hasError ? 1.0 : 0.0,
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                  child: Container(
                                    margin: EdgeInsets.only(top: 16),
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: TColor.error.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: TColor.error.withOpacity(0.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: TColor.error,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.error_outline,
                                            color: TColor.onPrimary,
                                            size: 16,
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            _errorMessage ?? "Login failed",
                                            style: TextStyle(
                                              color: TColor.error,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: _clearError,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: Container(
                                            padding: EdgeInsets.all(4),
                                            child: Icon(
                                              Icons.close,
                                              color: TColor.error,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 32),

                    // Sign In Button
                    FadeInDown(
                      delay: Duration(milliseconds: 700),
                      child: controller.logInLoading.value
                          ? Container(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: TColor.primary.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: CircularProgressIndicator(
                                      color: TColor.primary,
                                      strokeWidth: 3,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    "Signing you in...",
                                    style: TextStyle(
                                      color: TColor.onSurfaceVariant,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _isFormValid
                                    ? () async {
                                        HapticFeedback.mediumImpact();
                                        await _handleLogin();
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _isFormValid
                                      ? (_hasError
                                          ? TColor.error
                                          : TColor.primary)
                                      : TColor.onSurfaceVariant
                                          .withOpacity(0.3),
                                  foregroundColor: TColor.onPrimary,
                                  padding: EdgeInsets.symmetric(vertical: 18),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: _isFormValid ? 8 : 0,
                                  shadowColor: (_hasError
                                          ? TColor.error
                                          : TColor.primary)
                                      .withOpacity(0.3),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      _hasError ? Icons.refresh : Icons.login,
                                      size: 20,
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      _hasError ? "Try Again" : "Sign In",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ),

                    SizedBox(height: 24),

                    // Divider
                    FadeInDown(
                      delay: Duration(milliseconds: 800),
                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: TColor.onSurfaceVariant.withOpacity(0.3),
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              "or",
                              style: TextStyle(
                                color: TColor.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: TColor.onSurfaceVariant.withOpacity(0.3),
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24),

                    // Sign Up Section
                    FadeInDown(
                      delay: Duration(milliseconds: 900),
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: TColor.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: TColor.primary.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account?",
                              style: TextStyle(
                                color: TColor.onSurface,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 8),
                            GestureDetector(
                              onTap: () {
                                HapticFeedback.lightImpact();
                                Get.to(() => SignUp(),
                                    transition: Transition.rightToLeft);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: TColor.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    color: TColor.primary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
