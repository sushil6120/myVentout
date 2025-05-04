import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:overcooked/newFlow/services/app_url.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

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
      } else if (notification != null) {
        await showModernNotification(
          id: 1,
          title: notification.title ?? 'Notification',
          body: notification.body ?? '',
          payload: jsonEncode(message.data),
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
      // Handle call navigation - same as your existing code
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
    }
  }

  static Future<void> showModernNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    String? imageUrl,
  }) async {
    StyleInformation? styleInformation;
    
    if (imageUrl != null && imageUrl.isNotEmpty) {
      styleInformation = BigPictureStyleInformation(
        FilePathAndroidBitmap(imageUrl),
        contentTitle: '<b>$title</b>',
        htmlFormatContentTitle: true,
        summaryText: body,
        htmlFormatSummaryText: true,
        largeIcon: FilePathAndroidBitmap(imageUrl),
      );
    } else {
      styleInformation = BigTextStyleInformation(
        body,
        htmlFormatBigText: true,
        contentTitle: '<b>$title</b>',
        htmlFormatContentTitle: true,
        summaryText: 'Summary',
        htmlFormatSummaryText: true,
      );
    }

    await _localNotification.show(
      id,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'modern_notification_channel',
          'Modern Notifications',
          channelDescription: 'Channel for modern styled notifications',
          importance: Importance.max,
          priority: Priority.high,
          styleInformation: styleInformation,
          color: const Color(0xFF6A11CB),
          colorized: true, 
          icon: '@drawable/ic_launcher',
          channelShowBadge: true,
          playSound: true,
          enableVibration: true,
        ),
        iOS: const DarwinNotificationDetails(
          presentSound: true,
          presentAlert: true,
          presentBadge: true,
        ),
      ),
      payload: payload,
    );
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

  static Future<void> showWithoutImageNotification(
      String title, String body, String payload) async {
    await _localNotification.show(
      0,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notification',
          channelDescription:
              'Notification channel for high importance messages',
          importance: Importance.max,
          priority: Priority.high,
          color: const Color(0xFF4FACFE), 
          colorized: true,
          playSound: true,
          enableVibration: true,
          styleInformation: BigTextStyleInformation(
            body,
            htmlFormatBigText: true,
            contentTitle: '<b>$title</b>',
            htmlFormatContentTitle: true,
          ),
        ),
        iOS: const DarwinNotificationDetails(presentSound: true),
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
    
    await platform?.createNotificationChannel(const AndroidNotificationChannel(
      'modern_notification_channel', 
      'Modern Notifications',
      description: 'Channel for modern styled notifications',
      importance: Importance.max
    ));
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
      Uri.parse(AppUrl.baseUrl+AppUrl.fcmTokenUrl), 
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
    final String title = message.notification?.title ?? '';
    final String body = message.notification?.body ?? '';
    final String payload = jsonEncode(message.toMap());
    
    if(kDebugMode){
      print("Title : $title");
      print("body : $body");
      print("payload : $payload");
    }
    
    if (title == 'Accept Call') {
      await PushNotificationService.showCallNotification(
        title,
        body,
        payload,
      );
    } else {
      await PushNotificationService.showModernNotification(
        id: 1,
        title: title,
        body: body,
        payload: payload,
      );
    }
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