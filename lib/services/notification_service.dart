// ignore_for_file: avoid_print, unused_local_variable, use_build_context_synchronously

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import '../controller/store_controller.dart';

class NotificationService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final controller = Get.put(StoreController());
  final firebaseMessaging = FirebaseMessaging.instance;
  final GetStorage storage = GetStorage();

  // initialize notifications for this app or device
  Future<void> initNotifications() async {
    await firebaseMessaging.requestPermission();
    // get device token
    String? deviceToken = await firebaseMessaging.getToken();
    storage.write('deviceToken', deviceToken);
    print(
        "===================Device FirebaseMessaging Token====================");
    print(deviceToken);
    print(
        "===================Device FirebaseMessaging Token====================");
  }

  Future<String?> getDeviceToken() async {
    return await storage.read('deviceToken');
  }

  Future<String?> getAccessToken() async {
    final serviceAccountJson = {
     
    };
    print("1");

    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];
    print("2");

    try {
      http.Client client = await auth.clientViaServiceAccount(
          auth.ServiceAccountCredentials.fromJson(serviceAccountJson), scopes);
      print("4");

      auth.AccessCredentials credentials =
          await auth.obtainAccessCredentialsViaServiceAccount(
              auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
              scopes,
              client);
      print("5");

      client.close();
      print(
          "Access Token: ${credentials.accessToken.data}"); // Print Access Token
      return credentials.accessToken.data;
    } catch (e) {
      print("Error getting access token: $e");
      return null;
    }
  }

  //========SEND NOTIFICATIONS WHEN THE APP IS CLOSED
  Future<void> sendNotifications(
      String body, String title, String token) async {
    try {
      Future.delayed(Duration(seconds: 3));
      var serverKeyAuthorization = await getAccessToken();
      const String urlEndPoint =
          "https://fcm.googleapis.com/v1/projects/studyfriend/messages:send";

      print(token);

//this is the data we want to send in the notification
      final payload = {
        "message": {
          "token": token,
          "notification": {
            "body": body,
            "title": title,
          },
        }
      };
      print("before post");

      final response = await http.post(
        Uri.parse(urlEndPoint),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $serverKeyAuthorization',
        },
        body: jsonEncode(payload),
      );
      print("after post");
      if (response.statusCode == 200) {
        print("Notification sent successfully!");
      } else {
        print("Error sending notification: ${response.statusCode}");
      }
    } catch (e) {
      print("Error sending notification: $e");
    }
  }

  //==========================LOCAL NOTIFICATIONS====================================
  final notificationsPlugin = FlutterLocalNotificationsPlugin();
  bool _isInit = false;
  bool get isInit => _isInit;

  //=========INIT THE NOTIFICATIONS
  Future<void> initLocalNotifications() async {
    if (_isInit) return;

//INITIALIZE TIME ZONE
    tz.initializeTimeZones();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));
    tz.initializeDatabase([]);

    //ANDROID SETTINGS
    const AndroidInitializationSettings initSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    //IOS SETTINGS
    const DarwinInitializationSettings initSettingsIos =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    //TOTAL INITIALIZATION
    const InitializationSettings initSettings = InitializationSettings(
      android: initSettingsAndroid,
      iOS: initSettingsIos,
    );
    //====
    await notificationsPlugin.initialize(initSettings);
    _isInit = true;
  }

//===========NOTIFICATIONS DETAILS
  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_channel_id',
        'Daily Notifications',
        channelDescription: 'Daily Notification Channel',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

//==========DISPLAY THE NOTIFICATIOS
  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
  }) async {
    print("before");
    await firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('notifications')
        .add({
      'title': title,
      'body': body,
      'timestamp': FieldValue.serverTimestamp(),
    });
    return notificationsPlugin.show(id, title, body, notificationDetails());
  }

//==========SCHEDULE NOTIFICATIONS
  Future<void> scheduleNotification({
    int id = 1,
    required String title,
    required String body,
    required int hour,
    required int minute,
    //  required DateTime scheduledDate,
  }) async {
    try {
      print("1");
      const AndroidNotificationDetails androidPlatformChannelSpecifies =
          AndroidNotificationDetails(
        'daily_channel_id',
        'Daily Notifications',
        channelDescription: 'Daily Notification Channel',
        importance: Importance.max,
        priority: Priority.high,
      );
      const NotificationDetails platformChannelSpecifies = NotificationDetails(
        android: androidPlatformChannelSpecifies,
      );

      print("2");
      //GET THE CURRENT DATE OF THE DEVICE
      final now = tz.TZDateTime.now(tz.local);
      var scheduledDate = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      );

      print("3");
      print("Attempting to schedule notification for $scheduledDate");
      await notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        // tz.TZDateTime.from(scheduledDate, tz.local),
        platformChannelSpecifies,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
      print("notification send done");
    } catch (e) {
      print("Error scheduling notification: $e");
    }
  }

//==========CANCEL ALL NOTIFICATIONS
  Future<void> cancelNotifications() async {
    await notificationsPlugin.cancelAll();
  }
}
