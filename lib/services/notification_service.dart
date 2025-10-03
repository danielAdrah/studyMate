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
      "type": "service_account",
      "project_id": "studyfriend",
      "private_key_id": "5e1d6b71ca647f897e0b7a9065598d772e2948bd",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDGaIDYEYTu1/It\nmWh8SwFTNtm83sn+TiVGC+FfDioM19OieOfTuCKG6V53gdY7gK/v5glZMlNzgTSK\nc7mjZTiCez0avrAUdTsDWKJ2fWt5k8L1GIh6Q44M7cvmC9yHmA9Vv6fX4Sl/ZMWN\nqNVH+rposE8Ifk/pZKYN0EJPnNbTUO6JzGYJyEuped/s/n/OJfNt7H1Ok1DNsWOE\nVft+AIdiEOGQoyPylaaqHA7F8qxE/L74qRiSJP/kjgdDDywNngv5UEPiGM8+bP/L\nntW1dfylMJG13w4CbE8Z/TaBsJylCDH0gR+IEJzjhmOPWCufTN/dBxmnwFwK8Pc6\nlXs8GdJXAgMBAAECggEACDxxUMbVZlbHglYSbMpuSSaHPlxfNTPIP1Kh7eC4JSVW\nbzGmqfbEVCZe2gYlPv4WD5bUf4Pjy/Eqna61H4/Fm0EDZddRlt/Q7dAhmlqVegwE\ntUjp7W1debLrWmbWpjhNNqmIjaEWqGel/b3q8Jx7XXooJbmclpsre3pQLl7b2hS4\nxCOmohiw8ZVXf7behPWhnHdHSPeS1EbyjzuGWSFUHPdIoNCfWTCqrfk5aTSvb0l+\nl/CDJLXGMzYk+Wb6ZcrgLIhIP079b1aQ9EYcmgmCQLNvuSyHTbhFf4nTJxH6mpEo\nSbnIBPxMQGCYPgQ4i3D90f0RKL8zL7wizVydJ8JTSQKBgQDiTIoYZbf76ytpaOWr\npCwDv2p97QbllpjdjRwfPLJiZ5l9R52MglbMLi8aHJSRxoS2VNiyoZZxTe7bzZm8\nym+kzNGTq/LUI7TRlmY/0W96TI5/ev7f5E/+SRFpSKYJBh52DiDP9kqlnem3cW5X\nhZ1AWfRFTr74AQObvhI5YNuJeQKBgQDgctthAJS0+DLKKnqTuKpSGfsUxAmvf8Mk\nggQfGUvE38xzGMWWg90whpFoLSVlEjaNF6RB4NmQPIkJ6FwX6W5M4aRlcLQYtxEs\nAvcads/DNWv4e6/ope/5Uhcp9/VjP7S42kcdq88qWhfir0E98q2TR+UhPsPC5edI\nzsOq1loWTwKBgDPP7GpLl8VRAb5/qt4Sl5VAFUTBqSuVwGgxb7fjMMCBEc5yQCs0\niGT1SgmDc6ywtB/+6yJzBrvoaQDgYQutmcQ0tONHojBaAINgGQcRj6GDt7iOU561\nam9BEYB2hrVYNk83SuHydQLYVfOPQAE/8VIThm776ZNkwAu/h/KlL36ZAoGATmcw\nxPC8AX9V1pMCIIn4TRewQm+8Zma91wnnwKlIc2wt8eKsWsiTQnkvX/GtR2IWVjD0\n+uI9fYn34NMfIGc1VXvYvmqhLqT8RaB/iuoH50vI/JLQPveAHVqUpt9sA5BkY9Iz\n12SFyGiSQWgw5R/ZjEIoAvX20iUXJrK7XPjlnTcCgYANagfjWe5siOTU1Dg2ZUde\nF7iypPNU9KUbzAtuC9KhPUdcVhGHa82U8MFxBd3GGCmgHpI43xTmdXaqRf3GIYxU\nOixkJNRF/bpDyOyq1NxZucBvtvC8Liz+JFNwazN1Af7TJKWmOIysftUKM5zYid3R\nn4CII62Zgljk0xys1Njv0A==\n-----END PRIVATE KEY-----\n",
      "client_email": "studyfriend@studyfriend.iam.gserviceaccount.com",
      "client_id": "117726183895886332540",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/studyfriend%40studyfriend.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
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

    // Initialize timezone database
    tz.initializeTimeZones();

    try {
      // Get the local timezone
      final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(currentTimeZone));
    } catch (e) {
      // Fallback to UTC if timezone detection fails
      tz.setLocalLocation(tz.getLocation('UTC'));
      print('Could not get local timezone: $e. Using UTC as fallback.');
    }

    // ANDROID SETTINGS
    const AndroidInitializationSettings initSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // IOS SETTINGS
    const DarwinInitializationSettings initSettingsIos =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // TOTAL INITIALIZATION
    const InitializationSettings initSettings = InitializationSettings(
      android: initSettingsAndroid,
      iOS: initSettingsIos,
    );

    await notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (payload) {
        // Handle notification tap
        print('Notification tapped: $payload');
      },
    );

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
