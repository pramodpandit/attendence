import 'dart:math';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:office/ui/auth/loginScreen.dart';
import 'package:office/ui/home/home_bar.dart';
import 'package:office/ui/splash/introduction.dart';
import 'package:office/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  static const route = "/";
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {


  FirebaseMessaging messaging = FirebaseMessaging.instance;

  late String token;

  @override
  void initState() {
    super.initState();
    initializeFirebase();
  }

  initializeFirebase() {
    print('initializeFirebase getting called');
    getFirebaseToken();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (
      // This step (if condition) is only necessary if you pretend to use the
      // test page inside console.firebase.google.com
      !AwesomeStringUtils.isNullOrEmpty(message.notification?.title,
          considerWhiteSpaceAsEmpty: true) ||
          !AwesomeStringUtils.isNullOrEmpty(message.notification?.body,
              considerWhiteSpaceAsEmpty: true)) {
        print('Message also contained a notification: ${message.notification}');

        String? imageUrl;
        imageUrl ??= message.notification!.android?.imageUrl;
        imageUrl ??= message.notification!.apple?.imageUrl;

        // https://pub.dev/packages/awesome_notifications#notification-types-values-and-defaults
        Map<String, dynamic> notificationAdapter = {
          NOTIFICATION_CONTENT: {
            NOTIFICATION_ID: Random().nextInt(2147483647),
            NOTIFICATION_CHANNEL_KEY: 'basic_channel',
            NOTIFICATION_TITLE: message.notification!.title,
            NOTIFICATION_BODY: message.notification!.body,
            NOTIFICATION_LAYOUT:
            AwesomeStringUtils.isNullOrEmpty(imageUrl) ? 'Default' : 'BigPicture',
            NOTIFICATION_BIG_PICTURE: imageUrl,
          }
        };

        AwesomeNotifications().createNotificationFromJsonData(notificationAdapter);
      } else {
        AwesomeNotifications().createNotificationFromJsonData(message.data);
      }
    });
  }

  getFirebaseToken() async {
    // use the returned token to send messages to users from your custom server
    token = (await messaging.getToken(
      vapidKey: FirebaseVapidKey.key,
    ))!;
    debugPrint('fcmToken $token');

    initApp();
  }

  initApp() {

    final prefs = context.read<SharedPreferences>();
    if(prefs.containsKey('uid')) {
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pushNamedAndRemoveUntil(context, HomeBar.route, (r) => false);
      });
    } else {
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pushNamedAndRemoveUntil(context, IntroductionPage.route, (r) => false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Image.asset('images/splash.png', height: double.infinity, width:  double.infinity,fit: BoxFit.fill),
    );
  }
}
