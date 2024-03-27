import 'dart:convert';
import 'dart:math';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:office/bloc/profile_bloc.dart';
import 'package:office/data/repository/profile_repo.dart';
import 'package:office/ui/auth/loginScreen.dart';
import 'package:office/ui/chat/call.dart';
import 'package:office/ui/chat/chatScreen.dart';
import 'package:office/ui/chat/imageAnimation.dart';
import 'package:office/ui/home/home_bar.dart';
import 'package:office/ui/splash/introduction.dart';
import 'package:office/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:office/utils/message_handler.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  static const route = "/";
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late ProfileBloc profileBloc;
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  late String token;
  String nextScreen = "";

  @override
  void initState() {
    super.initState();
    profileBloc=ProfileBloc(context.read<ProfileRepository>());
    profileBloc.msgController?.stream.listen((event) {
      AppMessageHandler().showSnackBar(context, event);
    });
    notificationPermission();
    initApp();
  }

  notificationPermission()async{
    PermissionStatus permissionStatus = await Permission.notification.status;
    if(!permissionStatus.isGranted){
      permissionStatus = await Permission.notification.request();
      if(!permissionStatus.isGranted){
        notificationPermission();
      }
    }
  }

  // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // void initLocalNotifications(RemoteMessage message)async{
  //   var androidInitializationSettings = AndroidInitializationSettings("@mipmap/ic_launcher");
  //   var iosInitializationSettings = DarwinInitializationSettings();
  //   var initializationSettings = InitializationSettings(
  //     android: androidInitializationSettings,
  //     iOS: iosInitializationSettings,
  //   );
  //
  //   await flutterLocalNotificationsPlugin.initialize(
  //     initializationSettings,
  //     onDidReceiveNotificationResponse: (details) {
  //
  //     },
  //   );
  // }



  // Future<void> showNotifications(RemoteMessage message)async{
  //   AndroidNotificationChannel channel = AndroidNotificationChannel(
  //     Random.secure().nextInt(10000).toString(),
  //     "High Importance Notification",
  //     importance: Importance.max,
  //   );
  //
  //   AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
  //     channel.id.toString(),
  //     channel.name.toString(),
  //     channelDescription: "your channel description",
  //     importance: Importance.high,
  //     priority: Priority.high,
  //     ticker: "ticker",
  //   );
  //   DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(
  //     presentAlert: true,
  //     presentBadge: true,
  //     presentSound: true,
  //   );
  //   NotificationDetails notificationDetails = NotificationDetails(
  //     android: androidNotificationDetails,
  //     iOS: darwinNotificationDetails,
  //   );
  //
  //   Future.delayed(Duration.zero,() {
  //     flutterLocalNotificationsPlugin.show(
  //         0,
  //         message.notification!.title.toString(),
  //         message.notification!.body.toString(),
  //         notificationDetails,
  //     );
  //   },);
  // }

  // getFirebaseToken() async {
  //   // use the returned token to send messages to users from your custom server
  //   token = (await messaging.getToken(
  //     vapidKey: FirebaseVapidKey.key,
  //   ))!;
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setString("fcmToken", token);
  //   debugPrint('fcmToken $token');
  //   initApp();
  // }

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
