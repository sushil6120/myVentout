import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:overcooked/newFlow/services/app_url.dart';

class PushNotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final Uuid _uuid = const Uuid();

  final _androidChannel = const AndroidNotificationChannel(
      'high_importance_channel', 'High Importance Notification',
      description: 'This channel is used for important notifications',
      importance: Importance.defaultImportance);

  static final _localNotification = FlutterLocalNotificationsPlugin();

  Future<void> initPushNotification() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('@drawable/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) {},
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin);

    await _localNotification.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse: backgroundNotificationHandler,
      onDidReceiveNotificationResponse: notificationActionHandler,
    );

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      final notification = message.notification;
      if (notification != null && notification.title == 'Accept Call') {
        final callData = jsonDecode(notification.body ?? '{}');

        String callerName = callData['callerName'] ?? 'Unknown Caller';
        String callerImg = callData['callerImg'] ?? 'defaultImage';
        String payload = jsonEncode(callData);

        await showCallNotification(
          callerName,
          'Incoming call from $callerName',
          payload,
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      handleMessage(message);
    });

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        handleMessage(message);
      }
    });
  }

  Future<void> handleMessage(RemoteMessage message) async {
    final notification = message.notification;
    if (notification != null && notification.title == 'Accept Call') {
      final data = jsonDecode(notification.body.toString());
      // if (data['bookingType'] == 'Call') {
      //   Get.to(CallScreen(
      //       channelName: data['channelName'],
      //       name: data['callerName'],
      //       agoraToken: data['agoraToken'],
      //       therapistId: data['therapistId'],
      //       image: data['callerImg']));
      // } else if (data['bookingType'] == 'Video') {
      //   Get.to(VideoCallScreen(
      //       channelName: data['channelName'],
      //       name: data['callerName'],
      //       agoraToken: data['agoraToken'],
      //       therapistId: data['therapistId'],
      //       image: data['callerImg']));
      // }
    }
  }

  Future<void> notificationActionHandler(
      NotificationResponse notificationResponse) async {
    final String? actionId = notificationResponse.actionId;
    final String? payload = notificationResponse.payload;

    if (actionId != null) {
      switch (actionId) {
        case 'ACCEPT_CALL':
          print('Accepted');
          handleNotificationClick(payload);
          break;
        case 'DECLINE_CALL':
          print('Declined');
          break;
      }
    }
  }

  Future<void> handleNotificationClick(String? payload) async {
    if (payload != null) {
      final data = jsonDecode(payload);
      print("************* $data");
      // if (data['bookingType'] == 'Call') {
      //   Get.to(CallScreen(
      //       channelName: data['channelName'],
      //       name: data['callerName'],
      //       agoraToken: data['agoraToken'],
      //       therapistId: data['therapistId'],
      //       image: data['callerImg']));
      // } else if (data['bookingType'] == 'Video') {
      //   Get.to(VideoCallScreen(
      //       channelName: data['channelName'],
      //       name: data['callerName'],
      //       agoraToken: data['agoraToken'],
      //       therapistId: data['therapistId'],
      //       image: data['callerImg']));
      // }
    }
  }

  static Future<void> showCallNotification(
      String title, String body, String payload) async {
    await _localNotification.show(
      0,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'ventout',
          'High Importance Channel',
          channelDescription: 'Channel for incoming call notifications',
          importance: Importance.max,
          playSound: true,
          priority: Priority.high,
          fullScreenIntent: true,
          color: Colors.green,
          sound: const RawResourceAndroidNotificationSound('ringtone'),
          category: AndroidNotificationCategory.message,
          ongoing: true,
          autoCancel: false,
          icon: '@drawable/ic_launcher',
          largeIcon: FilePathAndroidBitmap(payload),
          actions: <AndroidNotificationAction>[
            const AndroidNotificationAction(
              'ACCEPT_CALL',
              'Accept',
              titleColor: Colors.white,
              showsUserInterface: true,
              cancelNotification: true,
            ),
            const AndroidNotificationAction(
              'DECLINE_CALL',
              'Decline',
              titleColor: Colors.white,
              showsUserInterface: true,
              cancelNotification: true,
            ),
          ],
        ),
        iOS: const DarwinNotificationDetails(
          presentSound: true,
          presentAlert: true,
          presentBadge: true,
          categoryIdentifier: 'incoming_call',
          threadIdentifier: 'call_notification_thread',
        ),
      ),
      payload: payload,
    );
  }

  Future<void> initLocalNotification() async {
    const android = AndroidInitializationSettings('@drawable/ic_launcher');
    final DarwinInitializationSettings iOS = const DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final InitializationSettings settings = InitializationSettings(
      android: android,
      iOS: iOS,
    );

    await _localNotification.initialize(
      settings,
      onDidReceiveNotificationResponse: notificationActionHandler,
    );

    final platform = _localNotification.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
  }

  Future<void> requestNotificationPermission(
      String userId, String token) async {
    var status = await Permission.notification.request();
    if (status.isGranted) {
      getDeviceToken(token);
    } else {
      requestNotificationPermission(userId, token);
    }
  }

  Future<String> getDeviceToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      await _firebaseMessaging.requestPermission(
          alert: true, badge: true, sound: true);

      String? deviceToken = await _firebaseMessaging.getToken();
      print('Device Token: $deviceToken');

      initPushNotification();
      initLocalNotification();

      await addDeviceToken(deviceToken.toString(), token);
      prefs.setString('deviceToken', deviceToken!);

      return deviceToken;
    } catch (e) {
      print('Error getting device token: $e');
      return e.toString();
    }
  }

  Future<void> addDeviceToken(String deviceToken, String token) async {
    final response = await http.patch(
      Uri.parse(AppUrl.baseUrl + AppUrl.fcmTokenUrl),
      body: jsonEncode({"fcmToken": deviceToken}),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      print("DT: ${response.body}");
    } else {
      print('Error: ${response.body}');
    }
  }
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  final callData = jsonDecode(message.notification?.body ?? '{}');

  String callerName = callData['callerName'] ?? 'Unknown Caller';
  String callerImg = callData['callerImg'] ?? 'defaultImage';
  String payload = jsonEncode(callData);

  await PushNotificationService.showCallNotification(
    callerName,
    'Incoming call from $callerName',
    payload,
  );
}

Future<void> backgroundNotificationHandler(
    NotificationResponse notificationResponse) async {
  final String? actionId = notificationResponse.actionId;
  final String? payload = notificationResponse.payload;

  if (actionId != null) {
    switch (actionId) {
      case 'ACCEPT_CALL':
        print('Accepted');
        PushNotificationService().handleNotificationClick(payload);
        break;
      case 'DECLINE_CALL':
        print('Declined');
        break;
    }
  }
}
