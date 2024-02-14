import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:office/data/model/user_detail_model.dart';
import 'package:office/utils/message_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/network/api_exception.dart';
import '../data/repository/auth_repo.dart';
import 'bloc.dart';

class AuthBloc extends Bloc {
  final AuthRepository _repo;

  AuthBloc(this._repo);
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  ValueNotifier<bool> isPasswordVisible = ValueNotifier(true);
  late Map<String, dynamic> response;
  StreamController<String> authStream = StreamController.broadcast();
  userLogin(String token) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    try {
      isLoading.value = true;
      response = await _repo.userLoginWithEmail(
          emailController.text, passwordController.text,
          fcmToken: token);
      if (response['status']) {
        Map<String, dynamic> uData = response['data'];
        _pref.setString('uid', uData['id'].toString());
        _pref.setString('name', "${uData["first_name"]} ${uData["last_name"]}");
        _pref.setString('email', uData['email'].toString());
        _pref.setString('phone', uData['phone'].toString());
        /*sharedPreferences.setString('fullname', uData['fullname'].toString());
      sharedPreferences.setString('employment_id', uData['employment_id'].toString());
      sharedPreferences.setString('mobile', uData['mobile'].toString());
      sharedPreferences.setString('gender', uData['gender'].toString());
      sharedPreferences.setString('avatar_url', uData['avatar_url'].toString());
      sharedPreferences.setString('password', password);*/
      }else{
        showMessage(MessageType.error('${response['message']}'));
      }
      return response;
    } catch (e, s) {
      debugPrint('error: $e');
      debugPrint('stackTrace $s');
    }finally{
      isLoading.value = false;
    }
  }

  TextEditingController phoneController = TextEditingController();
  TextEditingController pinController = TextEditingController();
  String verifyId = '';
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  ValueNotifier<bool> isValidUser = ValueNotifier(false);
  loginWithOtp() async {
    try {
      isLoading.value = true;
      FirebaseAuth auth = FirebaseAuth.instance;
      await auth.verifyPhoneNumber(
        phoneNumber: '+91${phoneController.text.trim()}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          // isLoading.value = false;
          await auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            showMessage(const MessageType.error(
                'The provided phone number is not valid.'));
          } else if (e.code == 'too-many-requests') {
            showMessage(const MessageType.error(
                'We have blocked all requests from this device due to unusual activity.'));
          } else {
            debugPrint('FirebaseError: ${e.code} :: ${e.message}');
          }
        },
        codeSent: (String verificationId, int? resendToken) async {
          verifyId = verificationId;
          authStream.sink.add('codeIsSent');
          isLoading.value = false;
          isValidUser.value = true;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          verificationId = verificationId;
          debugPrint("verificationId: $verificationId");
          debugPrint("Timeout");
        },
      );
    } catch (e) {
      debugPrint('error: $e');
    } finally {
      // isLoading.value = false;
    }
  }

  verifyOTP() async {
    try {
      SharedPreferences _pref = await SharedPreferences.getInstance();
      isLoading.value = true;
      if (pinController.text.isEmpty) {
        showMessage(const MessageType.error('Please enter OTP'));
        return;
      }
      if(pinController.text.length < 6){
        showMessage(const MessageType.error('Invalid OTP.'));
        return;
      }
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verifyId, smsCode: pinController.text.trim());
      await FirebaseAuth.instance.signInWithCredential(credential);
      if(isValidUser.value == false){
        _pref.setString('uid', userData['id'].toString());
        _pref.setString('name', userData["name"].toString());
        _pref.setString('email', userData['email'].toString());
        _pref.setString('phone', userData['phone'].toString());
      }
      authStream.sink.add('verified');
    } on FirebaseAuthException catch (exception) {
      if (exception.code == 'invalid-verification-code') {
        showMessage(const MessageType.error('Invalid Verification Code'));
      } else {
        debugPrint('FirebaseError: ${exception.message}');
        
      }
    } finally {
      isLoading.value = false;
    }
  }

  Map<String,dynamic> userData= {};
  checkPhoneNumber() async {
    try{
      isLoading.value = true;
      if (phoneController.text.isEmpty) {
        showMessage(const MessageType.error('Phone number is required'));
        isLoading.value = false;
        return;
      }
      if(phoneController.text.length < 10){
        showMessage(const MessageType.error('Invalid Phone Number.'));
        isLoading.value = false;
        return;
      }
      var response = await _repo.checkPhoneNumber(phoneController.text);
      if(response.status){
        if(response.data != null){
          UserDetail? uData = response.data;
          userData =
          {
            'uid' : uData?.id.toString() ?? '' ,
            'name': "${uData?.firstName??""} ${uData?.lastName??""}",
            'email' : uData?.email.toString()?? "",
            'phone' : uData?.phone.toString() ?? "",
          };
          print('user: $userData');
        }
        loginWithOtp();
      }else{
        showMessage(const MessageType.error('User not found!'));
        isLoading.value = false;
      }
    }catch(e){
      debugPrint('error: $e');
      isLoading.value = false;
    }finally{
      // isLoading.value = false;
    }
  }

  ValueNotifier<bool> isPsdVisible = ValueNotifier(true);
  ValueNotifier<bool> isConfirmPsdVisible = ValueNotifier(true);
  resetPassword()async {
    try{
      isLoading.value = true;
      var res = await _repo.resetPassword(phoneController.text,pinController.text);
      if(res.status){
        authStream.sink.add('resetVerify');
      }else{
        showMessage(MessageType.error("${res.message}"));
      }

    }on ApiException catch (apiError) {
      showMessage(MessageType.error(apiError.message));
    } catch (e) {
      debugPrint("e");
      showMessage(MessageType.error("Something went wrong!"));
    }finally{
      isLoading.value= false;
    }
  }

}
