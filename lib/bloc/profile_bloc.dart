import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
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
ValueNotifier<List?> searchData = ValueNotifier([]);
  Stream<List> getRecentChats() async*{
    while(true){
      try{
        var result = await _repo.fetchRecentChats();
        searchData.value = result.data;
        yield result.data as List;
      }catch (e, s) {
        print(e);
        print(s);
      }
      await Future.delayed(Duration(seconds: 10));
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

  ValueNotifier<List?> allGroupList = ValueNotifier(null);
  ValueNotifier<List?> searchGroup = ValueNotifier(null);

  Stream<List> getGroupList() async*{
      try{
        var result = await _repo.fetchGroupList();
        searchGroup.value = result.data;
        yield result.data as List;
      }catch (e, s) {
        print(e);
        print(s);
      }
  }

  Stream<List> getGroupChats(String senderId) async*{
    while(true){
      try{
        var result = await _repo.fetchGroupChats(senderId);
        yield (result.data as List).reversed.toList();
      }catch (e, s) {
        print(e);
        print(s);
      }
      await Future.delayed(Duration(seconds: 5));
    }
  }

  ValueNotifier<bool> groupDetailLoading = ValueNotifier(false);
  ValueNotifier<Map<String,dynamic>?> groupDetails = ValueNotifier({});

  getSpecificGroupDetails(String groupId)async {
    try{
      groupDetailLoading.value = true;
      var result = await _repo.fetchSpecificGroupDetail(groupId);
      if(result['status']){
        groupDetails.value = result;
      }else{
        groupDetails.value = null;
      }
    }catch(e){
      showMessage(MessageType.error("Something went wrong"));
      groupDetails.value = null;
      print(e);
    }finally{
      groupDetailLoading.value = false;
    }
  }

  ValueNotifier<bool> addMemberLoading = ValueNotifier(false);
  ValueNotifier<String> addingUsers = ValueNotifier("");
  
  addRemoveMemberInGroup(BuildContext context,String groupId, String type,{String? removeUser})async{
    Map<String,dynamic> data = {
      "group_id" : groupId,
      "type" : type,
    };
    if(type == "add"){
      data.addAll({
        "from_user" : addingUsers.value,
      });
    }
    if(type == "remove" && removeUser!=null){
      data.addAll({
        "from_user" : removeUser,
      });
    }
    if(type == "add") {
      if (addingUsers.value.isEmpty) {
        showMessage(MessageType.info("Please select atleast one user"));
        return;
      }
    }

    try{
      addMemberLoading.value = true;
      var result = await _repo.addRemoveMemberInGroupApi(data);
      if(result['status']){
        if(type == "add"){
          Navigator.pop(context);
          showMessage(MessageType.success("Users added successfully"));
        }else{
          showMessage(MessageType.success("User removed successfully"));
        }
        getSpecificGroupDetails(groupId);
      }else{
        if(type == "add"){
          showMessage(MessageType.error("User already added"));
        }else{
          showMessage(MessageType.error("Something went wrong"));
        }
      }
    }catch(e){
      showMessage(MessageType.error("Something went wrong"));
      print(e);
    }finally{
      addMemberLoading.value = false;
    }
  }

  makeRemoveAdminInGroup(String groupId,String userId,String permission)async{
    Map<String,dynamic> data = {
      "group_id" : groupId,
      "from_user" : userId,
      "permission" : permission
    };

    try{
      addMemberLoading.value = true;
      var result = await _repo.makeRemoveAdminInGroupApi(data);
      if(result['status']){
        showMessage(MessageType.success("Admin approved"));
      }else{
        showMessage(MessageType.error("Somethimg went wrong"));
      }
      getSpecificGroupDetails(groupId);
    }catch(e){
      showMessage(MessageType.error("Something went wrong"));
      print(e);
    }finally{
      addMemberLoading.value = false;
    }
  }


  TextEditingController sendMessageController = TextEditingController();
  ValueNotifier<bool> isSending = ValueNotifier(false);

  Future sendMessage(String toUser,String chatType,String messageType,{File? image,Position? position})async{
    isSending.value = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String,dynamic> data = {
      "from_user" : prefs.getString("uid"),
      "to_user" : toUser,
      "type" : chatType,
      "message_type" : messageType,
    };
    if(messageType == "text"){
      data.addAll({
        "message" : sendMessageController.text
      });
    }
    if(messageType == "image" && image!=null){
      data.addAll({
        "file_uploaded" : await MultipartFile.fromFile(image.path,
        filename: image.path.split('/').last,
        )
      });
    }
    if(messageType == "location" && position != null){
      data.addAll({
        "latitude" : position.latitude,
        "longitude" : position.longitude,
        });
    }
    try{
      var result = await _repo.sendMessageApi(data);
      if(result['status']){
        // sendMessageController.clear();
        showMessage(MessageType.success(result['message']));
      }else{
        showMessage(MessageType.error(result['message']));
      }
    }catch(e){
      print(e);
    }finally{
      sendMessageController.clear();
      isSending.value = false;
    }
  }

  sendNotification(Map<String,dynamic> user,{File? image})async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String,dynamic> notificationData = {
      "body": sendMessageController.text,
      "OrganizationId": "2",
      "content_available": true,
      "priority": "high",
      "title":  prefs.getString("name"),
    };
    // if(image!=null){
    //   notificationData.addAll({
    //     "image" : await MultipartFile.fromFile(image.path,
    //         filename: image.path.split('/').last),
    //   });
    // }
    Map<String,dynamic> data = {
      "to": user['fcm_token'].toString(),
      "notification": notificationData,
    };
    print("the main data is : ${data}");
    try{
      var result = await _repo.sendNotificationApi(data);
      if(result['success'].toString() == "1"){
        showMessage(MessageType.success("done"));
      }else{
        showMessage(MessageType.error("some error ${result['results'][0]}"));
      }
    }catch(e){
      showMessage(MessageType.error("catch error : ${e.toString()}"));
      print(e);
    }
  }

  ValueNotifier<bool> createGroupLoading = ValueNotifier(false);
  ValueNotifier<File?> groupLogo = ValueNotifier(null);
  TextEditingController groupName = TextEditingController();
  TextEditingController groupDesc = TextEditingController();

  Future createNewGroup(BuildContext context) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(groupLogo.value == null){
      showMessage(MessageType.info("Please choose group icon"));
      return;
    }
    Map<String,dynamic> data = {
      "from_user" : prefs.getString("uid"),
      "type" : "group",
      "group_name" : groupName.text,
      "description" : groupDesc.text,
      "logo" : await MultipartFile.fromFile(groupLogo.value!.path,
          filename: groupLogo.value!.path.split('/').last)
    };
    if(groupName.text.isEmpty){
      showMessage(MessageType.info("Please enter group name"));
      return;
    }
    if(groupDesc.text.isEmpty){
      showMessage(MessageType.info("Please enter group description"));
      return;
    }
    try{
      createGroupLoading.value = true;
      var response = await _repo.createGroupApi(data);
      if(response['status']){
        showMessage(MessageType.success("Group Created Successfully"));
        Navigator.pop(context);
      }else{
        showMessage(MessageType.success("Group not created"));
      }
    }catch(e){
      showMessage(MessageType.error("Failed"));
      print(e);
    }finally{
      createGroupLoading.value = false;
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