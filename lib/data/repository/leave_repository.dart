import 'package:intl/intl.dart';
import 'package:office/data/model/LeaveCategory.dart';
import 'package:office/data/model/LeaveRecord.dart';
import 'package:office/data/model/api_response.dart';
import 'package:office/data/model/notice_board.dart';
import 'package:office/data/network/api_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/api_service.dart';

class LeaveRepository {
  final SharedPreferences prefs;
  final ApiService _api;

  LeaveRepository(this.prefs, this._api);

  Future<List<LeaveRecord>> getLeaveRecords(String recordType) async{
    SharedPreferences _pref = await SharedPreferences.getInstance();
    Map<String, dynamic> data = {
      "user_id": _pref.getString('uid'),
      "status": recordType,
    };

    var response= await _api.postRequest("leave_records", data);
    if(response==null){
      throw ApiException.fromString("response null");
    }
    List<dynamic> list2 = (response??[]);
    List<LeaveRecord> resp = list2.map<LeaveRecord>((item)=>LeaveRecord.fromJson(item)).toList();
    return resp;
  }

  Future<List<LeaveCategory>> getLeaveCategories() async{
    SharedPreferences _pref = await SharedPreferences.getInstance();
    Map<String, dynamic> data = {
      "user_id": _pref.getString('uid')
    };
    var response= await _api.getRequest("leave/categories", data: data);
    if(response==null){
      throw ApiException.fromString("response null");
    }
    List<dynamic> list2 = (response??[]);
    List<LeaveCategory> resp = list2.map<LeaveCategory>((item)=>LeaveCategory.fromJson(item)).toList();
    return resp;
  }

  Future<ApiResponse> applyForLeave(String title, String description, DateTime startDate, String typeId, String durationType, {DateTime? endDate}) async{
    SharedPreferences _pref = await SharedPreferences.getInstance();
    Map<String, dynamic> data = {
      "user_id": _pref.getString('uid'),
      "title": title,
      "leave_category_id": typeId,
      "reason": description,
      "leave_start_date": DateFormat("yyyy-MM-dd").format(startDate),
      "duration_type": durationType,
    };
    if(endDate!=null) {
      data['end_date'] = DateFormat("yyyy-MM-dd").format(endDate);
    }
    var response= await _api.postRequest("leave/apply", data);
    if(response==null) {
      throw ApiException.fromString("response null");
    }
    return ApiResponse.fromJson(response);
  }

  Future<ApiResponse2> respondLeaveRequest(String leaveId,String status) async{
    var response= await _api.postRequest("leave/respond_request", {
      "leave_id":leaveId,
      "status": status
    });
    if(response==null){
      throw ApiException.fromString("response null");
    }
    return ApiResponse2.fromJson(response);
  }
  Future<ApiResponse2> leaveBalance() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();

    var response = await _api.postRequest("leaves_count", {
      "user_id": _pref.getString('uid'),

    });

    if (response == null) {
      ApiException.fromString("response null");
    }
    return ApiResponse2.fromJson(response,response);
  }
}
