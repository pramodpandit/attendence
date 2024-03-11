import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:office/bloc/auth_bloc.dart';
import 'package:office/data/repository/auth_repo.dart';
import 'package:office/ui/auth/forget_password/forgetPassword.dart';
import 'package:office/ui/auth/loginWithOtpScreen.dart';
import 'package:office/ui/home/home_bar.dart';
import 'package:office/ui/widget/custom_button.dart';
import 'package:office/utils/constants.dart';
import 'package:provider/provider.dart';
import '../../utils/message_handler.dart';

class LoginScreen extends StatefulWidget {
  static const route = "/LoginScreen";
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late AuthBloc authBloc;
  final formKey = GlobalKey<FormState>();
  late SharedPreferences prefs;

  @override
  void initState() {
    authBloc = AuthBloc(context.read<AuthRepository>());
    super.initState();
    authBloc.msgController?.stream.listen((event) {
      AppMessageHandler().showSnackBar(context, event);
    });
    getFirebaseToken();
  }

  getFirebaseToken() async {
    // use the returned token to send messages to users from your custom server
    String token = (await FirebaseMessaging.instance.getToken(
      vapidKey: FirebaseVapidKey.key,
    ))!;
    prefs = await SharedPreferences.getInstance();
    await prefs.setString("fcmToken", token);
    debugPrint('fcmToken $token');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 135,
                ),
                Image.asset(
                  'images/aarvy_logo2.png',
                  height: 150,
                  width: 150,
                ),
                const SizedBox(
                  height: 60,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: TextFormField(
                    style: const TextStyle(color: Colors.black),
                    keyboardType: TextInputType.phone,
                    controller: authBloc.emailController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xffffffff),
                      errorBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.red.withOpacity(1)),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.red.withOpacity(1)),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      contentPadding: const EdgeInsets.all(17.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.blueAccent.withOpacity(0.8)),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: const Color(0xff777777).withOpacity(1)),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      hintText: "Employed Id/Email/Phone No",
                      prefixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            child: Image.asset(
                              "images/user_icon.png",
                              height: 20,
                              width: 20,
                            ),
                          )
                        ],
                      ),
                      focusColor: Colors.white,
                      counterStyle: const TextStyle(color: Colors.white),
                      hintStyle: const TextStyle(
                        color: Color(0xff777777),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Employed id/Email/Phone number is required.";
                      }
                      return null;
                    },
                    onTap: () {},
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                ValueListenableBuilder(
                  valueListenable: authBloc.isPasswordVisible,
                  builder:
                      (BuildContext context, bool isVisible, Widget? child) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: TextFormField(
                        obscureText: isVisible,
                        controller: authBloc.passwordController,
                        style: const TextStyle(color: Colors.black),
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xffffffff),
                          errorBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.red.withOpacity(1)),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.red.withOpacity(1)),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          contentPadding: const EdgeInsets.all(17.0),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.blueAccent.withOpacity(0.8)),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: const Color(0xff777777).withOpacity(1)),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          hintText: "Password",
                          prefixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 18),
                                child: Image.asset(
                                  "images/lock_icon.png",
                                  height: 20,
                                  width: 20,
                                ),
                              )
                            ],
                          ),
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 18),
                                child: GestureDetector(
                                    onTap: () => authBloc.isPasswordVisible.value =
                                        !authBloc.isPasswordVisible.value,
                                    child: isVisible
                                        ? const Icon(PhosphorIcons.eye)
                                        : const Icon(PhosphorIcons.eye_closed)
                                    ),
                              )
                            ],
                          ),
                          focusColor: Colors.white,
                          counterStyle: const TextStyle(color: Colors.white),
                          hintStyle: const TextStyle(
                            color: Color(0xff777777),
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is required.';
                          }
                          return null;
                        },
                        onTap: () {},
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child: Text(
                        "Forgot Password?",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: 14,
                            color: const Color(0xff253FA4).withOpacity(1),
                            fontWeight: FontWeight.w600),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => Provider.value(
                              value: authBloc,
                              child: ForgotPasswordScreen(),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                ValueListenableBuilder(
                  valueListenable: authBloc.isLoading,
                  builder: (context, bool loading, child) {
                    if (loading) {
                      return const CircularProgressIndicator();
                    }
                    return CustomButton(
                      tittle: 'LOGIN',
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          var res = await authBloc.userLogin(prefs.getString("fcmToken").toString());
                          if (res['status']) {
                            // ignore: use_build_context_synchronously
                            Navigator.pushReplacementNamed(
                                context, HomeBar.route);
                          }
                        }
                      },
                    );
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  "OR",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextButton(
                  child: Text(
                    "LOGIN WITH OTP",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        fontSize: 14,
                        letterSpacing: 1.2,
                        color: const Color(0xff253FA4).withOpacity(1),
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return Provider.value(
                        value: authBloc,
                        child: const LoginWithOtpScreen(),
                      );
                    }));
                  },
                ),
                SizedBox(
                  height: 1,
                  width: 150,
                  child: Divider(
                    color: const Color(0xff253FA4).withOpacity(1),
                  ),
                ),
                const SizedBox(
                  height: 70,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // login() async{
  //   try {
  //     Map<String, dynamic> loginData = await loginNotifier.userLogin(token);

  //     if (loginData != null && loginData['status']) {
  //       Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Dashboard()));
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         content: Text("${loginData['message']}"),
  //         duration: const Duration(seconds: 2),
  //       ));
  //     }
  //   } on ApiException catch (apiError) {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text("${apiError.message}"),
  //       duration: const Duration(seconds: 2),
  //     ));
  //   } catch (e, s) {
  //     print(e);
  //     print(s);
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //       content: Text("Some Error Occurred While Logging In!"),
  //       duration: Duration(seconds: 2),
  //     ));
  //   }
  // }
}
