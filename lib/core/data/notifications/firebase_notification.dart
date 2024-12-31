import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dr_mohamed_salah_admin/core/data/exceptions/exceptions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'local_notification.dart';

class FirebaseNotifications {
  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  static listen() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("On Message : ${message.data}");
      var id = message.data["id"];
      _showLocalNotification(id, message.notification);
    });
    firebaseMessaging.getInitialMessage().then((message) {
      print("Initial Message : ${message?.data}");
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("On Message Opened App : ${message.data}");
    });
  }

  static init() async {
    await FirebaseMessaging.instance
        .requestPermission(sound: true, badge: true, alert: true)
        .then((settings) =>
            print("Settings registered: ${settings.authorizationStatus}"));
  }

  static _showLocalNotification(
    id,
    RemoteNotification? message,
  ) async {
    if (message != null) {
      final title = message.title;
      final body = message.body;
      if ((title != null && title.isNotEmpty) ||
          (body != null && body.isNotEmpty)) {
        await LocalNotifications.show(
          id: int.tryParse(id.toString()) ?? 100,
          title: title ?? "",
          body: body ?? "",
        );
      }
    }
  }

  static final Dio _dio = Dio(BaseOptions(
    baseUrl: "https://fcm.googleapis.com/fcm/",
    receiveDataWhenStatusError: true,
    connectTimeout: const Duration(milliseconds: 60 * 1000),
    sendTimeout: const Duration(milliseconds: 60 * 1000),
    receiveTimeout: const Duration(milliseconds: 60 * 1000),
  ))
    ..options.headers = {'Authorization': "key=[Firebase Server Key]"};

  static Future<void> sendTopicNotification(
      {required String topic,
      required String title,
      required String body,
      Map<String, dynamic>? jsonData}) async {
    try {
      final data = {
        "to": "/topics/$topic",
        "notification": {"title": title, "body": body, "sound": "default"},
        "data": jsonData
      };

      await _dio.post("send", data: json.encode(data));
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  static Future<void> sendUsersNotification(
      {required List<String> registrationIds,
      required String title,
      required String body,
      Map<String, dynamic>? jsonData}) async {
    try {
      final data = {
        "registration_ids": registrationIds,
        "notification": {"title": title, "body": body, "sound": "default"},
        "data": jsonData
      };

      await _dio.post("send", data: json.encode(data));
    } catch (e) {
      throw AppException(e.toString());
    }
  }
}
