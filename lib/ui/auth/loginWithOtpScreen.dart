import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:office/bloc/auth_bloc.dart';
import 'package:office/ui/auth/LoginScreen.dart';
import 'package:office/ui/auth/otpScreen.dart';
import 'package:office/ui/widget/custom_button.dart';
import 'package:provider/provider.dart';

class LoginWithOtpScreen extends StatefulWidget {
  const LoginWithOtpScreen({super.key});

  @override
  State<LoginWithOtpScreen> createState() => _LoginWithOtpScreenState();
}

class _LoginWithOtpScreenState extends State<LoginWithOtpScreen> {
  late AuthBloc bloc;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    bloc = context.read<AuthBloc>();
    super.initState();
    bloc.phoneController.text = '';
    bloc.authStream.stream.listen((event) { 
      if(event=='codeIsSent'){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return Provider.value(
              value: bloc,
              child: const OtpScreen(),
            );
          }));
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
                  SizedBox(
                    height: 150,
                    width: 150,
                    child: Image.asset('images/aarvy_logo.png'),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Text(
                    "Enter Your Number To Get Started",
                    style: TextStyle(
                        fontSize: 21,
                        letterSpacing: 0.5,
                        color: Colors.black.withOpacity(1),
                        fontFamily: "outfit2",
                        fontWeight: FontWeight.bold),textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      "Confirm the Country Code and Entre Your Mobile Number.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        letterSpacing: 0.5,
                        color: const Color(0xff262525).withOpacity(1),
                        fontFamily: "outfit2",
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
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
                          borderSide: BorderSide(color: Colors.red.withOpacity(1)),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red.withOpacity(1)),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        contentPadding: const EdgeInsets.all(17.0),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blueAccent.withOpacity(0.8)),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: const Color(0xff777777).withOpacity(1)),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        hintText: "Phone Number",
                        prefixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 25, right: 10),
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
                        counterStyle: const TextStyle(color: Colors.white),
                        hintStyle: const TextStyle(
                          color: Color(0xff777777),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      validator: (v) => v!.isEmpty ? "Please enter phone number" : null,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(10),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onFieldSubmitted: (value) {
                        bloc.phoneController.text = value;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  ValueListenableBuilder(
                    valueListenable: bloc.isLoading,
                    builder: (context, bool loading, child) {
                      print("object $loading");
                      if(bloc.isLoading.value){
                        return const CircularProgressIndicator();
                      }
                      else{
                        return CustomButton(
                          tittle: 'Get OTP',
                          onPressed: () {
                            if(formKey.currentState!.validate()){
                              bloc.checkPhoneNumber();
                            }
                          },
                        );
                      //   DecoratedBox(
                      //   decoration: BoxDecoration(
                      //     gradient: const LinearGradient(
                      //         begin: FractionalOffset.topCenter,
                      //         end: FractionalOffset.bottomCenter,
                      //         colors: [
                      //           Color(0xff0B20AA),
                      //           Color(0xff041165),
                      //         ]),
                      //     borderRadius: BorderRadius.circular(30),
                      //   ),
                      //   child: ElevatedButton(
                      //     onPressed: () {
                      //       // Navigator.push(context, MaterialPageRoute(builder: (context)=>Provider.value(value: bloc,child: OtpScreen(),)));
                      //       bloc.checkPhoneNumber();
                      //     },
                      //     style: ElevatedButton.styleFrom(
                      //       shape: const StadiumBorder(),
                      //       backgroundColor: Colors.transparent,
                      //       elevation: 3,
                      //       disabledForegroundColor:
                      //           Colors.transparent.withOpacity(0.38),
                      //       disabledBackgroundColor:
                      //           Colors.transparent.withOpacity(0.12),
                      //       shadowColor: Colors.transparent,
                      //       fixedSize: const Size(260, 55),
                      //     ),
                      //     child: const Text(
                      //       "Verify",
                      //       style: TextStyle(
                      //         fontWeight: FontWeight.bold,
                      //         fontFamily: "outfit2",
                      //         fontSize: 25,
                      //         color: Colors.white,
                      //       ),
                      //     ),
                      //   ),
                      // );
                      }
                    },
                  ),

                  //CHANGES BY Aditya

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

                  Text(
                      "Powered by Aarvy",
                      style: TextStyle(
                        fontSize: 13,
                        letterSpacing: 1.1,
                        fontFamily: "outfit2",
                        fontWeight: FontWeight.bold,
                        color: const Color(0xff0017AD).withOpacity(1),
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
