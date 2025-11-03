import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'notification_service.dart';

class UserService extends ChangeNotifier {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  String? _userRole;
  bool _isLoading = false;

  String? get userRole => _userRole;
  bool get isLoading => _isLoading;

  // Cache the user role to avoid repeated Firestore calls
  Future<String?> getUserRole() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _userRole = null;
      return null;
    }

    // Try to get from local storage first (instant access)
    final prefs = await SharedPreferences.getInstance();
    final cachedRole = prefs.getString('user_role_${user.uid}');
    if (cachedRole != null) {
      _userRole = cachedRole;
      return _userRole;
    }

    // If not in cache, fetch from Firestore
    _isLoading = true;
    notifyListeners();

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      _userRole = doc.data()?['role'] as String?;

      // Save to local storage for future instant access
      if (_userRole != null) {
        await prefs.setString('user_role_${user.uid}', _userRole!);
      }

      _isLoading = false;
      notifyListeners();
      return _userRole;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  // Clear cache when user logs out
  void clearUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_role_${user.uid}');
    }
    _userRole = null;
    notifyListeners();
  }

  // Listen to auth changes and update role accordingly
  void initializeAuthListener() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        clearUserData();
      } else {
        getUserRole(); // Fetch role for new user
        saveDeviceToken(); // Save device token for notifications
      }
    });
  }

  // Save device token for Firebase messaging
  Future<void> saveDeviceToken() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      // Get device token from notification service
      final NotificationService notiService = NotificationService();
      final deviceToken = await notiService.getDeviceToken();

      if (deviceToken != null && deviceToken.isNotEmpty) {
        // Save token to Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'deviceToken': deviceToken,
          'lastTokenUpdate': FieldValue.serverTimestamp(),
        });
        print('Device token saved for user: ${user.uid}');
      }
    } catch (e) {
      print('Error saving device token: $e');
    }
  }
}
