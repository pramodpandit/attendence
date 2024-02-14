import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:office/bloc/auth_bloc.dart';
import 'package:office/ui/widget/custom_button.dart';
import 'package:office/utils/constants.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../home/home_bar.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late AuthBloc bloc;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    bloc = context.read<AuthBloc>();
    super.initState();
    bloc.authStream.stream.listen((event) { 
      if(event=='verified'){
        Navigator.of(context)
          .pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>const HomeBar()), (route) => false);
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
                    "Enter Your Code To Get Started",
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
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      "+91 ${bloc.phoneController.text}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        letterSpacing: 0.5,
                        color: K.textGrey,
                        fontFamily: "outfit2",
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
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
                      onChanged: (value) => bloc.pinController.text = value,
                      autoDismissKeyboard: false,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (v) => v!.isEmpty ? "Please enter OTP" : null,
                    ),
                  ),
                  
                  const SizedBox(
                    height: 50,
                  ),
                  ValueListenableBuilder(
                    valueListenable: bloc.isLoading,
                    builder: (BuildContext context, bool loading, Widget? child) {
                      if(loading){
                        return const CircularProgressIndicator();
                      }else{
                        return CustomButton(
                          tittle: 'Verify',
                          onPressed: () {
                            if(formKey.currentState!.validate()){
                              bloc.verifyOTP();
                            }
                          },
                        );
                        // DecoratedBox(
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
                        //       bloc.verifyOTP();
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
                  const SizedBox(
                    height: 150,
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
