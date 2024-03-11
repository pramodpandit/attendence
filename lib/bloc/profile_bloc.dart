import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:office/data/model/api_response.dart';
import 'package:office/data/model/bankDetails_model.dart';
import 'package:office/data/model/document.dart';
import 'package:office/data/model/guardianModel.dart';
import 'package:office/data/model/links_model.dart';
import 'package:office/data/model/warning_model.dart';
import 'package:office/data/repository/profile_repo.dart';
import 'package:office/ui/profile/menus/assets.dart';
import 'package:office/ui/profile/menus/bank_details.dart';
import 'package:office/ui/profile/menus/basic_info.dart';
import 'package:office/ui/profile/menus/documents.dart';
import 'package:office/ui/profile/menus/guardian_details.dart';
import 'package:office/ui/profile/menus/links.dart';
import 'package:office/ui/profile/menus/official_details.dart';
import 'package:office/ui/profile/menus/warning.dart';
import 'package:office/utils/message_handler.dart';
import '../data/model/Assets_Detail_modal.dart';
import '../data/model/Assets_model.dart';
import '../data/model/user.dart';
import 'bloc.dart';

class ProfileBloc extends Bloc {
  final ProfileRepository _repo;

  ProfileBloc(this._repo);
  File? image;
  List<String> profileMenus = [
    "Basic Info",
    "Official Details",
    "Documents",
    "Guardian Details",
    "Payments",
    "Links",
    "Warnings",
    "Assets"
  ];
  ValueNotifier<int> selectedMenuIndex = ValueNotifier(0);
  ValueNotifier<int> isLoadingDownload = ValueNotifier(-1);

  List<Widget> profileMenusWidgets = [
    const BasicInfoScreen(),
    const OfficialDetails(),
    const DocumentScreen(),
    const GuardianDetails(),
    const BankDetails(),
    const Links(),
    const Warning(),
    const Assets(),
  ];
  ValueNotifier<User?> userDetail = ValueNotifier(null);
  ValueNotifier todayWorkingDetail = ValueNotifier(null);
  ValueNotifier<User?> employeeDetail = ValueNotifier(null);
  ValueNotifier<List<Document>?> userDocuments = ValueNotifier([]);
  ValueNotifier<List<Guardian>?> userGuardian = ValueNotifier([]);
  ValueNotifier<List<BankDetailsModel>?> userBankDetails = ValueNotifier([]);
  ValueNotifier<List<WarningModel>?> userWarnings=ValueNotifier([]);
  ValueNotifier<List<UserAssets>?>assetsUser=ValueNotifier([]);
  ValueNotifier<List<UserAssetDetail>?>assetsUserDetail=ValueNotifier([]);
  ValueNotifier<List<LinksModel>?> userLinks=ValueNotifier([]);
  ValueNotifier<bool> isUserDetailLoad = ValueNotifier(false);
  ValueNotifier<bool> isEmployeeDetailLoad = ValueNotifier(false);
  ValueNotifier<bool> isGuardianDetailLoad = ValueNotifier(false);
  ValueNotifier<bool> isUserDocumentLoad = ValueNotifier(false);
  ValueNotifier<bool> isBankDetailsLoad = ValueNotifier(false);
  ValueNotifier<bool> isLinksLoad = ValueNotifier(false);
  ValueNotifier<bool> isWarningsLoad=ValueNotifier(false);
  ValueNotifier<bool> isAssetsLoad=ValueNotifier(false);
  ValueNotifier<bool> isAssetsLoadDetail=ValueNotifier(false);
  ValueNotifier<bool> isAllUserDetailLoad = ValueNotifier(false);
  ValueNotifier<List?> allUserDetail = ValueNotifier(null);

  ValueNotifier<String?> currentLatitude = ValueNotifier(null);
  ValueNotifier<String?> currentLongitude = ValueNotifier(null);
  ValueNotifier<File?> imageFile = ValueNotifier(null);

  selectMenu(int index){
    selectedMenuIndex.value =index;
  }

  bool hasAccess(List<Departmentaccess>? departmentAccess, int id, String permission) {
    return departmentAccess?.any((d) =>
    d.id == id.toString() && d.viewA == permission.toString()
    ) ?? false;
  }

  fetchUserDetail() async{
    try{
      isUserDetailLoad.value = true;
      ApiResponse2<User> result = await _repo.userDetails();
      if(result.status){
        userDetail.value = result.data;
      }
    }catch (e, s) {
      print(e);
      print(s);
    }finally{
      isUserDetailLoad.value = false;
    }
  }


  fetchEmployeeDetail(id) async{
    try{
      isEmployeeDetailLoad.value = true;
      ApiResponse2<User> result = await _repo.employeeDetails(id);
      if(result.status){
        employeeDetail.value = result.data;
      }
    }catch (e, s) {
      print(e);
      print(s);
    }finally{
      isEmployeeDetailLoad.value = false;
    }
  }
  ValueNotifier<String?> allUser = ValueNotifier(null);
  fetchAllUserDetail() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try{
      isAllUserDetailLoad.value = true;
      var result = await _repo.allUserDetails();
      if(result.status){
        allUserDetail.value = (result.data as List).where((element) => element['user_id'].toString() != prefs.getString("uid")).toList();
      }
    }catch (e, s) {
      allUserDetail.value = [];
      print("a error $e");
      print(s);
    }finally{
      isAllUserDetailLoad.value = false;
    }
  }

  fetchUserGuardianDetail() async{
    try{
      isGuardianDetailLoad.value = true;
      var result = await _repo.userGuardian();
      if(result.status){
        userGuardian.value = result.data;
      }
    }catch (e,s) {
      print(e);
      print(s);
    }finally{
      isGuardianDetailLoad.value = false;
    }
  }

  fetchUserDocuments() async{
    try{
      isUserDocumentLoad.value = true;
      var result = await _repo.userDocuments();
      if(result.status){
        userDocuments.value = result.data;
      }
    }catch (e,s) {
      print(e);
      print(s);
    }finally{
      isUserDocumentLoad.value=false;
    }
  }

  fetchBankDocuments() async{
    try{
      isBankDetailsLoad.value = true;
      var result = await _repo.userBankDetails();
      if(result!=null){
        userBankDetails.value = result;
      }
    }catch (e,s) {
      print(e);
      print(s);
    }finally{
      isBankDetailsLoad.value=false;
    }
  }

  fetchLinks() async{
    try{
      isLinksLoad.value=true;
      var result=await _repo.userLinks();
      if(result!=null){
        userLinks.value=result.data;
      }
    }catch(e,s){
      print(e);
      print(s);
    }finally{
      isLinksLoad.value=false;
    }
  }

  fetchUserWarnings() async{
    try{
      isWarningsLoad.value=true;
      var result=await _repo.userWarnings();
      if(result!=null){
        userWarnings.value=result.data;
      }
    }catch(e,s){
      print(e);
      print(s);
    }finally{
      isWarningsLoad.value=false;
    }
  }

  fetchTodayWorkingDetail()async {
    try {
      ApiResponse2 result = await _repo.todayWorking();
      print("the result is : ${result.data}");
      if (result.status) {
        todayWorkingDetail.value = result.data;
      }
    } catch (e, s) {
      print(e);
      print(s);
    }
  }

  fetchUserAssets() async{
    try{
      isAssetsLoad.value=true;
      var result=await _repo.userAsset();
      if(result.status == true && result!=null){
        assetsUser.value = result.data;
      }
    }catch(e,s){
      print(e);
      print(s);
    }finally{
      isAssetsLoad.value=false;
    }
  }
  fetchUserAssetsDetail(int id) async{
    try{
      isAssetsLoadDetail.value=true;
      var result=await _repo.userAssetDetail(id);
      if(result.status == true && result!=null){
        assetsUserDetail.value = result.data;
      }
    }catch(e,s){
      print(e);
      print(s);
    }finally{
      isAssetsLoadDetail.value=false;
    }
  }


  markCheckInAttendance(String work, String attendanceType,String dayCount)async{
    try {
      ApiResponse2 result = await _repo.checkInAttendance(work, imageFile.value!,currentLatitude.value!,currentLongitude.value!,attendanceType,dayCount);
      if (result.status) {
        toast("Attendance checked in");
      }
    } catch (e, s) {
      print(e);
      print(s);
    }finally{
      fetchTodayWorkingDetail();
    }
  }
  markCheckOutAttendance(String work,String dayCount)async{
    try {
      ApiResponse2 result = await _repo.checkOutAttendance(work, imageFile.value!, currentLatitude.value!, currentLongitude.value!,dayCount);
      if (result.status) {
        toast("Attendance checked out");
      }
    } catch (e, s) {
      print(e);
      print(s);
    }finally{
      fetchTodayWorkingDetail();
    }
  }


  ValueNotifier<List?> allDoingTaskData = ValueNotifier(null);

  fetchDoingTaskData() async{
    try{
      isUserDetailLoad.value = true;
      var result = await _repo.getDoingTaskData("doing");
      if(result.status && result.data != null){
        allDoingTaskData.value = result.data;
      }else{
        allDoingTaskData.value = [];
      }
    }catch (e, s) {
      allDoingTaskData.value = [];
      print(e);
      print(s);
    }finally{
      isUserDetailLoad.value = false;
    }
  }

  Stream<List> getRecentChats() async*{
    while(true){
      try{
        var result = await _repo.fetchRecentChats();
        yield result.data as List;
      }catch (e, s) {
        print(e);
        print(s);
      }
      await Future.delayed(Duration(seconds: 5));
    }
  }

  Stream<List> getOneToOneChat(String senderId) async*{
    while(true){
      try{
        var result = await _repo.fetchOneToOneChat(senderId);
        yield (result.data as List).reversed.toList();
      }catch (e, s) {
        print(e);
        print(s);
      }
      await Future.delayed(Duration(seconds: 5));
    }
  }

  TextEditingController sendMessageController = TextEditingController();
  ValueNotifier<bool> isSending = ValueNotifier(false);

  sendMessage(String toUser,String chatType,String messageType)async{
    isSending.value = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String,dynamic> data = {
      "from_user" : prefs.getString("uid"),
      "to_user" : toUser,
      "type" : chatType,
      "message_type" : messageType,
      "message" : sendMessageController.text
    };
    try{
      var result = await _repo.sendMessageApi(data);
      if(result['status']){
        sendMessageController.clear();
        showMessage(MessageType.success(result['message']));
      }else{
        showMessage(MessageType.error(result['message']));
      }
    }catch(e){
      print(e);
    }finally{
      isSending.value = false;
    }
  }

  sendNotification(Map<String,dynamic> user)async{
    Map<String,dynamic> data = {
      "to": user['fcm_token'].toString(),
      "notification": {
        "body": sendMessageController.text,
        "OrganizationId": "2",
        "content_available": true,
        "priority": "high",
        "subtitle": "Subtitle",
        "title":  "${user['first_name'] ?? ''} ${user['middle_name'] ?? ''} ${user['last_name'] ?? ''}",
      },
      "data": {
        "priority": "high",
        "content_available": true,
        // "data" : "jsonEncode(user)",
        // "screen" : "chatting",
        "OrganizationId": "2",
      }
    };
    try{
      var result = await _repo.sendNotificationApi(data);
      if(result['success'].toString() == "1"){
        // showMessage(MessageType.success("done"));
      }else{
        // showMessage(MessageType.error("some error ${result['results'][0]}"));
      }
    }catch(e){
      // showMessage(MessageType.error(e.toString()));
      print(e);
    }
  }

  ValueNotifier<dynamic> expenseAllow = ValueNotifier("");
  getExpanseAllowData() async{
    try{
      var result = await _repo.fetchExpanseAllowData();
      expenseAllow.value = result;
    }catch (e, s) {
      print(e);
      print(s);
    }
  }
}