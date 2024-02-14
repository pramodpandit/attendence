import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:office/bloc/auth_bloc.dart';
import 'package:office/ui/auth/forget_password/resetPassword.dart';
import 'package:office/ui/widget/custom_button.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../LoginScreen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late AuthBloc bloc;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    bloc = context.read<AuthBloc>();
    super.initState();
    bloc.isValidUser.value = false;
    bloc.phoneController.text = '';
    bloc.authStream.stream.listen((event) { 
      if(event == 'verified'){
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>
        Provider.value(value: bloc,child: ResetPasswordScreen(phone: bloc.phoneController.text)) ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print(bloc.phoneController.text);
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
                  SizedBox(
                    height: 200,
                    width: 200,
                    child: Image.asset('images/aarvy_logo.png'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Forgot Password",
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
                  ValueListenableBuilder(
                    valueListenable: bloc.isValidUser,
                    builder: (context, bool validUser, child) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Text(
                              validUser
                                  ? "Enter the code send on your phone number."
                                  : "Enter Your Phone Number. We Will Send You 6 Digit Code To Your Phone Number",
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
                            height: 30,
                          ),
                          if(!validUser)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            child: TextFormField(
                              style: const TextStyle(color: Colors.black),
                              keyboardType: TextInputType.number,
                              controller: bloc.phoneController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xffffffff),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.red.withOpacity(1)),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.red.withOpacity(1)),
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
                                      color:
                                          const Color(0xff777777).withOpacity(1)),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                hintText: "Phone Number",
                                prefixIcon: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 25, right: 10),
                                      child: IntrinsicHeight(
                                        child: Row(children: [
                                          const Text(
                                            "+91",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 17,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: "outfit2"),
                                          ),
                                          VerticalDivider(
                                            thickness: 1,
                                            color: Colors.black.withOpacity(1),
                                          )
                                        ]),
                                      ),
                                    )
                                  ],
                                ),
                                focusColor: Colors.white,
                                counterStyle:
                                    const TextStyle(color: Colors.white),
                                hintStyle: const TextStyle(
                                  color: Color(0xff777777),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              validator: (v) =>
                                  v!.isEmpty ? "Please enter phone number" : null,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(10),
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              onFieldSubmitted: (value) {
                                bloc.phoneController.text = value;
                              },
                            ),
                          ),
                          if(validUser)
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                            child: PinCodeTextField(
                              autoDisposeControllers: false,
                              pinTheme: PinTheme(
                                inactiveColor: Colors.grey.shade500,
                                selectedColor: Colors.blue.shade700,
                                activeColor: Colors.green.shade700,
                                shape: PinCodeFieldShape.box,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              appContext: context,
                              length: 6,
                              onChanged: (value) =>
                                  bloc.pinController.text = value,
                              autoDismissKeyboard: false,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: (v) =>
                                  v!.isEmpty ? "Please enter OTP" : null,
                            ),
                          ),
                          const SizedBox(
                            height: 60,
                          ),
                          ValueListenableBuilder(
                            valueListenable: bloc.isLoading,
                            builder: (context, bool loading, child) {
                              if (loading) {
                                return CircularProgressIndicator();
                              }
                              return CustomButton(
                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {
                                      validUser ? bloc.verifyOTP() : bloc.checkPhoneNumber();
                                    }
                                  },
                                  tittle: validUser ? 'Verify' :'Get OTP'
                                  );
                            },
                          ),
                        ],
                      );
                    },
                  ),


                  //Changes BY ADITYA

                  const SizedBox(
                    height: 26,
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
                      "Login With Password",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: 14,
                          letterSpacing: 1.2,
                          color: const Color(0xff253FA4).withOpacity(1),
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                    },
                  ),
                  SizedBox(
                    height: 1,
                    width: 190,
                    child: Divider(
                      color: const Color(0xff253FA4).withOpacity(1),
                    ),
                  ),
                  const SizedBox(
                    height: 120,
                  ),

                  const SizedBox(
                    height: 18,
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
