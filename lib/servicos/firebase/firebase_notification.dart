import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:garen/utils/request.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseNotifications {
  FirebaseMessaging firebaseMessaging;

  void setupUpFirebase() {
    firebaseMessaging = FirebaseMessaging();
    firebaseCloudMessagingListeners();
  }

  void firebaseCloudMessagingListeners() {
    if (Platform.isIOS) iOSPermission();

    firebaseMessaging.getToken().then((token) => {this.saveFCMToken(token)});

    firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print("received message: $message");
        },
        onResume: (Map<String, dynamic> message) async {},
        onLaunch: (Map<String, dynamic> message) async {});
  }

  void iOSPermission() {
    firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  void saveFCMToken(String token) async {
    print("FCM Token: $token");

    RequestUtil _request = new RequestUtil();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('ins_c_token', token);
    _request.saveTokenInstaladorShared(tokenInstalador: token);
  }
}
