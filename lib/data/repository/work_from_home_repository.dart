import 'package:intl/intl.dart';
import 'package:office/data/model/LeaveCategory.dart';
import 'package:office/data/model/LeaveRecord.dart';
import 'package:office/data/model/api_response.dart';
import 'package:office/data/model/notice_board.dart';
import 'package:office/data/network/api_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/api_service.dart';

class WorkFromHomeRepository {
  final SharedPreferences prefs;
  final ApiService _api;

  WorkFromHomeRepository(this.prefs, this._api);

  Future<List> getWorkFromHomeRecords(String recordType) async{
    SharedPreferences _pref = await SharedPreferences.getInstance();
    Map<String, dynamic> data = {
      "user_id": _pref.getString('uid'),
      // "user_id": 490,
      "status": recordType,
    };

    var response= await _api.postRequest("wfh/leave_records", data);
    if(response==null){
      throw ApiException.fromString("response null");
    }
    List<dynamic> list2 = (response["data"]??[]);
    return list2;
  }

  Future<ApiResponse> applyForWorkFromHome(String title, String description, DateTime startDate, String durationType, {DateTime? endDate}) async{
    SharedPreferences _pref = await SharedPreferences.getInstance();
    Map<String, dynamic> data = {
      "user_id": _pref.getString('uid'),
      // "user_id" : 490,
      "reason_title": title,
      "reason": description,
      "start_date": DateFormat("yyyy-MM-dd").format(startDate),
      "duration_type": durationType,
    };
    if(endDate!=null) {
      data['end_date'] = DateFormat("yyyy-MM-dd").format(endDate);
    }
    // if(durationType == "")
    var response= await _api.postRequest("wfh/single", data);
    if(response==null) {
      throw ApiException.fromString("response null");
    }
    return ApiResponse.fromJson(response);
  }
  Future<ApiResponse2> CancelWorkFormhome(String id) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();

    var response = await _api.postRequest("wfh/leave_cancle", {
      "user_id": _pref.getString('uid'),
      "id": int.parse(id),
    },);
    if (response == null) {
      ApiException.fromString("response null");
    }
    return ApiResponse2.fromJson(response);
  }
  Future<ApiResponse> EditForwfh(int id,String title, String description, DateTime startDate,  String durationType, {DateTime? endDate}) async{
    SharedPreferences _pref = await SharedPreferences.getInstance();
    Map<String, dynamic> data = {
      "id":id,
      "user_id": _pref.getString('uid'),
      "reason_title": title,
      "reason": description,
      "start_date": DateFormat("yyyy-MM-dd").format(startDate),
      "duration_type": durationType,
    };
    if(endDate!=null) {
      data['end_date'] = DateFormat("yyyy-MM-dd").format(endDate);
    }
    var response= await _api.postRequest("wfh/edit", data,);
    if(response==null) {
      throw ApiException.fromString("response null");
    }
    return ApiResponse.fromJson(response);
  }

  Future<ApiResponse2> CancelLeave(int id) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();

    var response = await _api.postRequest("wfh/leave_cancle", {
      "user_id": _pref.getString('uid'),
      "id": id,
    },);
    if (response == null) {
      ApiException.fromString("response null");
    }
    return ApiResponse2.fromJson(response);
  }
  Future<ApiResponse2> ApprovedLeave(int id) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();

    var response = await _api.postRequest("wfh/leave_approved", {
      "user_id": _pref.getString('uid'),
      "id": id,
    },);
    if (response == null) {
      ApiException.fromString("response null");
    }
    return ApiResponse2.fromJson(response);
  }
  Future<ApiResponse2> AddRemark(int id,String remark) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();

    var response = await _api.postRequest("wfh/remark", {
      "user_id": _pref.getString('uid'),
      "id": id,
      "remark":remark
    },);
    if (response == null) {
      ApiException.fromString("response null");
    }
    return ApiResponse2.fromJson(response);
  }

  // Future<ApiResponse2> respondLeaveRequest(String leaveId,String status) async{
  //   var response= await _api.postRequest("leave/respond_request", {
  //     "leave_id":leaveId,
  //     "status": status
  //   });
  //   if(response==null){
  //     throw ApiException.fromString("response null");
  //   }
  //   return ApiResponse2.fromJson(response);
  // }
}
