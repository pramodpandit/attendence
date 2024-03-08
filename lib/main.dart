import 'dart:math';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:office/data/repository/attendance_repo.dart';
import 'package:office/data/repository/auth_repo.dart';
import 'package:office/data/repository/complaint_repo.dart';
import 'package:office/data/repository/e_bill_repo.dart';
import 'package:office/data/repository/expense_repo.dart';
import 'package:office/data/repository/feedback_repo.dart';
import 'package:office/data/repository/holiday_repo.dart';
import 'package:office/data/repository/lead_repository.dart';
import 'package:office/data/repository/leave_repository.dart';
import 'package:office/data/repository/notes_repo.dart';
import 'package:office/data/repository/notice_repo.dart';
import 'package:office/data/repository/post_repo.dart';
import 'package:office/data/repository/profile_repo.dart';
import 'package:office/data/repository/project_repo.dart';
import 'package:office/data/repository/water_repo.dart';
import 'package:office/data/repository/work_from_home_repository.dart';
import 'package:office/ui/splash/splash_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/network/api_service.dart';
import 'data/network/interceptors.dart';
import 'data/repository/community.dart';
import 'data/repository/task_repo.dart';
import 'data/repository/team_repo.dart';
import 'utils/constants.dart';
import 'utils/routes.dart';

void main() async {
  bool inProduction = true;
  if (inProduction) {
    // debugPrint = (message, {wrapWidth}) {};
  }
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      // options: DefaultFirebaseOptions.currentPlatform,
      );
  await FlutterDownloader.initialize(debug: true, ignoreSsl: true);
  // WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // await Hive.initFlutter();
  // Hive.registerAdapter(UserReminderAdapter());

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.white,
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.portraitDown]);

  AwesomeNotifications().initialize(
      // 'resource://drawable/logo',
      null,
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: K.themeColorPrimary,
          ledColor: Colors.blue,
          channelShowBadge: true,
          playSound: true,
          enableVibration: true,
          enableLights: true,
          importance: NotificationImportance.High,
        ),
        NotificationChannel(
          channelKey: 'scheduled',
          channelName: 'Alarms',
          channelDescription: 'Scheduled Notification Channel',
          defaultColor: K.themeColorPrimary,
          ledColor: K.themeColorPrimary,
          channelShowBadge: true,
          importance: NotificationImportance.High,
          playSound: true,
          enableVibration: true,
          onlyAlertOnce: true,
        ),
      ]);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  final sharedPreferences = await SharedPreferences.getInstance();
  // FirebaseMessaging.instance.getToken().then((value) {
  //   if (value != null) {
  //     sharedPreferences.setString('device_token', value);
  //   }
  // });
  Dio dio = Dio();
  dio.interceptors.add(AppInterceptors());
  // dio.interceptors.add(DioCacheManager(CacheConfig(
  //   baseUrl: ApiService.host,
  //   defaultMaxAge: const Duration(minutes: 30),
  //   defaultMaxStale: const Duration(days: 2),
  // )).interceptor);
  final ApiService apiService = ApiService(dio);
  runApp(MyApp(sharedPreferences, apiService));
}

class MyApp extends StatelessWidget {
  const MyApp(this.prefs, this.apiService, {Key? key}) : super(key: key);

  final SharedPreferences prefs;
  final ApiService apiService;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthRepository>.value(
            value: AuthRepository(prefs, apiService)),
        Provider<NoticeRepository>.value(
            value: NoticeRepository(prefs, apiService)),
        Provider<LeaveRepository>.value(
            value: LeaveRepository(prefs, apiService)),
        Provider<AuthRepository>.value(
            value: AuthRepository(prefs, apiService)),
        Provider<HolidayEventRepository>.value(
            value: HolidayEventRepository(prefs, apiService)),
        Provider<FeedbackRepository>.value(
            value: FeedbackRepository(prefs, apiService)),
        Provider<ComplaintRepository>.value(
            value: ComplaintRepository(prefs, apiService)),
        Provider<CommunityRepositary>.value(
            value: CommunityRepositary(prefs, apiService)),
        Provider<TaskRepositary>.value(
            value: TaskRepositary(prefs, apiService)),
        Provider<TeamRepo>.value(
            value: TeamRepo(prefs, apiService)),
        Provider<SharedPreferences>.value(value: prefs),
        Provider<ProfileRepository>.value(
            value: ProfileRepository(prefs, apiService)),
        Provider<NotesRepository>.value(
            value: NotesRepository(prefs, apiService)),
        Provider<LeadsRepository>.value(
            value: LeadsRepository(prefs, apiService)),
        Provider<EBillRepository>.value(
            value: EBillRepository(prefs, apiService)),
        Provider<WaterRepository>.value(
            value: WaterRepository(prefs, apiService)),
        Provider<PostRepository>.value(
            value: PostRepository(prefs, apiService)),
        Provider<ProjectRepository>.value(
            value: ProjectRepository(prefs, apiService)),
        Provider<WorkFromHomeRepository>.value(
            value: WorkFromHomeRepository(prefs, apiService)),
        Provider<AttendanceRepository>.value(
            value: AttendanceRepository(prefs, apiService)),
        Provider<ExpenseRepository>.value(
            value: ExpenseRepository(prefs, apiService)),
        // Provider<HiveService>.value(value: HiveService()),
        // ChangeNotifierProvider<ThemeBloc>(
        //   create: (_) => ThemeBloc(AppRepository(prefs, apiService)),
        // ),
      ],
      child: ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (context, _) {
            return MaterialApp(
              title: 'Office',
              debugShowCheckedModeBanner: false,
              builder: (context, widget) {
                //add this line
                // ScreenUtil.setContext(context);
                return MediaQuery(
                  //Setting font does not change with system font size
                  data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                  child: widget!,
                );
              },
              theme: ThemeData(
                // primarySwatch: Colors.green,
                colorSchemeSeed: Colors.blue,
                scaffoldBackgroundColor: K.themeColorBg,
                appBarTheme: const AppBarTheme(
                  backgroundColor: Color(0xFF009FE3),
                  foregroundColor: Colors.white,
                  systemOverlayStyle: SystemUiOverlayStyle.dark,
                  titleTextStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      fontFamily: K.fontFamily,),
                  iconTheme:
                      IconThemeData(color: Colors.white,size: 22),
                  centerTitle: true,
                ),
                useMaterial3: true,
                bottomSheetTheme: const BottomSheetThemeData(
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(8)),
                  ),
                ),
                pageTransitionsTheme: const PageTransitionsTheme(builders: {
                  TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
                  TargetPlatform.iOS: CupertinoPageTransitionsBuilder()
                }),
                fontFamily: "Poppins", //'Gilroy', //'Lato', //'Poppins',
              ),
              initialRoute: SplashPage.route,
              routes: Routes.routes,
              // onGenerateRoute: (routeSettings) {
              //   print('routeSettings $routeSettings');
              // switch(routeSettings.name) {
              //   case CreateOrderPage.route:
              //     return MaterialPageRoute(
              //       builder: (context) => const CreateOrderPage(),
              //       settings: routeSettings,
              //     );
              // }
              // },
            );
          }),
    );
  }
}

// Declared as global, outside of any class
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");

  if (!AwesomeStringUtils.isNullOrEmpty(message.notification?.title,
          considerWhiteSpaceAsEmpty: true) ||
      !AwesomeStringUtils.isNullOrEmpty(message.notification?.body,
          considerWhiteSpaceAsEmpty: true)) {
    print('message also contained a notification: ${message.notification}');

    String? imageUrl;
    imageUrl ??= message.notification!.android?.imageUrl;
    imageUrl ??= message.notification!.apple?.imageUrl;

    Map<String, dynamic> notificationAdapter = {
      NOTIFICATION_CHANNEL_KEY: 'basic_channel',
      NOTIFICATION_ID: message.data[NOTIFICATION_CONTENT]?[NOTIFICATION_ID] ??
          message.messageId ??
          Random().nextInt(2147483647),
      NOTIFICATION_TITLE: message.data[NOTIFICATION_CONTENT]
              ?[NOTIFICATION_TITLE] ??
          message.notification?.title,
      NOTIFICATION_BODY: message.data[NOTIFICATION_CONTENT]
              ?[NOTIFICATION_BODY] ??
          message.notification?.body,
      NOTIFICATION_LAYOUT:
          AwesomeStringUtils.isNullOrEmpty(imageUrl) ? 'Default' : 'BigPicture',
      NOTIFICATION_BIG_PICTURE: imageUrl
    };

    AwesomeNotifications().createNotificationFromJsonData(notificationAdapter);
  } else {
    AwesomeNotifications().createNotificationFromJsonData(message.data);
  }
}
