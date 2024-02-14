import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:office/bloc/auth_bloc.dart';
import 'package:office/ui/auth/loginScreen.dart';
import 'package:provider/provider.dart';

import '../../widget/custom_button.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String phone;
  const ResetPasswordScreen({Key? key, required this.phone}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState(phone);
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  String phone;
  late AuthBloc bloc;
  final formKey = GlobalKey<FormState>();

  _ResetPasswordScreenState(this.phone);

  @override
  void initState() {
    bloc = context.read<AuthBloc>();
    super.initState();
    bloc.authStream.stream.listen((event) {
      if (event == "resetVerify") {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if(bloc.isLoading.value){
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 80,
                  ),
                  Container(
                    height: 200,
                    width: 200,
                    child: Image.asset('images/aarvy_logo.png'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Reset Password",
                    style: TextStyle(
                        fontSize: 21,
                        letterSpacing: 0.5,
                        color: Colors.black.withOpacity(1),
                        fontFamily: "outfit2",
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      "Set the New Password For Your Account",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        letterSpacing: 0.5,
                        color: const Color(0x262525).withOpacity(1),
                        fontFamily: "outfit2",
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ValueListenableBuilder(
                    valueListenable: bloc.isPsdVisible,
                    builder:
                        (BuildContext context, bool isVisible, Widget? child) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextFormField(
                          obscureText: isVisible,
                          controller: bloc.passwordController,
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
                            hintText: "New Password",
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
                                      onTap: () => bloc.isPsdVisible.value =
                                          !bloc.isPsdVisible.value,
                                      child: isVisible
                                          ? const Icon(PhosphorIcons.eye)
                                          : const Icon(PhosphorIcons.eye_closed)),
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
                            if (value.toString().isEmpty) {
                              return "Please enter new password";
                            }
                            return null;
                          },
                          onFieldSubmitted: (value) {
                            bloc.passwordController.text = value;
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ValueListenableBuilder(
                    valueListenable: bloc.isConfirmPsdVisible,
                    builder:
                        (BuildContext context, bool isVisible, Widget? child) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextFormField(
                          obscureText: isVisible,
                          controller: bloc.confirmPasswordController,
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
                            hintText: "Confirm Password",
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
                                      onTap: () =>
                                          bloc.isConfirmPsdVisible.value =
                                              !bloc.isConfirmPsdVisible.value,
                                      child: isVisible
                                          ? const Icon(PhosphorIcons.eye)
                                          : const Icon(PhosphorIcons.eye_closed)),
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
                            if (value.toString().isEmpty) {
                              return "Please enter confirm password";
                            }
                            if (bloc.passwordController.text != value) {
                              return "Confirm password not match with new password";
                            }
                            return null;
                          },
                          onFieldSubmitted: (value) {
                            bloc.confirmPasswordController.text = value;
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  ValueListenableBuilder(
                    valueListenable: bloc.isLoading,
                    builder: (BuildContext context, bool loading, Widget? child) {
                      if (loading) {
                        return const CircularProgressIndicator();
                      }
                      return CustomButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              bloc.resetPassword();
                            }
                          },
                          tittle: "Reset Password");
                    },
                  ),
                  const SizedBox(
                    height: 170,
                  ),
                  Text(
                    "Powered by Aarvy",
                    style: TextStyle(
                      fontSize: 13,
                      letterSpacing: 1.1,
                      fontFamily: "outfit2",
                      fontWeight: FontWeight.bold,
                      color: const Color(0x0017AD).withOpacity(1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
