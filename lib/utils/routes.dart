import 'package:office/ui/auth/loginScreen.dart';
import 'package:office/ui/home/home_bar.dart';
import 'package:office/ui/splash/introduction.dart';
import 'package:office/ui/splash/splash_page.dart';
import 'package:flutter/material.dart';

class Routes {
  static Map<String, WidgetBuilder> routes = {
    SplashPage.route: (context) => const SplashPage(),
    HomeBar.route: (context) => const HomeBar(),
    LoginScreen.route: (context) => const LoginScreen(),
    IntroductionPage.route:(context)=>const IntroductionPage(),
  };
}