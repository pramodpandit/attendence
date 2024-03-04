import 'dart:io';

import 'package:dio/dio.dart';
import 'package:office/data/model/api_response.dart';
import 'package:office/data/model/bankDetails_model.dart';
import 'package:office/data/model/guardianModel.dart';
import 'package:office/data/model/links_model.dart';
import 'package:office/data/model/policy_model.dart';
import 'package:office/data/model/user.dart';
import 'package:office/data/model/warning_model.dart';
import 'package:office/data/network/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/Assets_Detail_modal.dart';
import '../model/Assets_model.dart';
import '../model/document.dart';
import '../network/api_exception.dart';

class ProfileRepository {
  final SharedPreferences prefs;
  final ApiService _api;

  ProfileRepository(this.prefs, this._api);

  Future<ApiResponse2<User>> userDetails() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    var response = await _api.getRequest(
      "user/details",
      data: {
        'user_id': _pref.getString('uid'),
      },
    );
    if (response == null) {
      throw ApiException.fromString("response null");
    }
    return ApiResponse2.fromJson(response,
        response['data'] == null ? null : User.fromJson(response['data']));
  }

  Future<ApiResponse2> allUserDetails() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    var response = await _api.getRequest(
      "user/get_all_employee_details",
      data: {
        'user_id': _pref.getString('uid'),
      },
    );
    if (response == null) {
      throw ApiException.fromString("response null");
    }
    List<dynamic> list = response['data1'] ?? [];
    return ApiResponse2.fromJson(response,list);
  }

  Future<ApiResponse2<List<Document>>> userDocuments() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    var response = await _api.postRequest("user/fetch_documents", {
      "user_id": _pref.getString('uid'),
    });
    if (response == null) {
      throw ApiException.fromString("response null");
    }
    List<dynamic> list = response['data'] ?? [];
    List<Document> documents =
        list.map<Document>((e) => Document.fromJson(e)).toList();
    return ApiResponse2<List<Document>>.fromJson(response, documents);
  }

  Future<ApiResponse2<List<Guardian>>> userGuardian() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    var response = await _api.getRequest("user/guardians", data: {
      "user_id": _pref.getString('uid'),
    });
    List<dynamic> list = response['data'] ?? [];
    List<Guardian> guardian =
        list.map<Guardian>((e) => Guardian.fromJson(e)).toList();
    return ApiResponse2<List<Guardian>>.fromJson(response, guardian);
  }

  Future<List<BankDetailsModel>> userBankDetails() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    var response = await _api.getRequest("user/bank_details", data: {
      "user_id": _pref.getString('uid'),
    });
    List<dynamic> list = response ?? [];
    List<BankDetailsModel> bankDetails = list
        .map<BankDetailsModel>((e) => BankDetailsModel.fromJson(e))
        .toList();
    return bankDetails;
  }
  Future<ApiResponse4<List<UserAssets>>> userAsset() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    var response = await _api.getRequest("user/user_assets", data: {
      "user_id": _pref.getString('uid'),
    });
    if (response == null) {
      throw ApiException.fromString("response null");
    }
    List<dynamic> list = response['data'] ?? [];
    List<UserAssets> warning =
    list.map<UserAssets>((e) => UserAssets.fromJson(e)).toList();
    return ApiResponse4<List<UserAssets>>.fromJson(response, warning);
  }
  Future<ApiResponse4<List<UserAssetDetail>>> userAssetDetail(int id) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    var response = await _api.getRequest("user/user_assets_history", data: {
      "id": id,
    });
    if (response == null) {
      throw ApiException.fromString("response null");
    }
    List<dynamic> list = response['data'] ?? [];
    List<UserAssetDetail> warning =
    list.map<UserAssetDetail>((e) => UserAssetDetail.fromJson(e)).toList();
    return ApiResponse4<List<UserAssetDetail>>.fromJson(response, warning);
  }


  Future<ApiResponse<List<LinksModel>>> userLinks() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    var response = await _api.postRequest("user/get_links", {
      "user_id": _pref.getString('uid'),
    });
    if (response == null) {
      throw ApiException.fromString("response null");
    }
    List<dynamic> list = response['data'] ?? [];
    List<LinksModel> links =
        list.map<LinksModel>((e) => LinksModel.fromJson(e)).toList();
    return ApiResponse<List<LinksModel>>.fromJson(response, links);
  }

  Future<ApiResponse<List<WarningModel>>> userWarnings() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    var response = await _api.postRequest("user/get_warning", {
      "user_id": _pref.getString('uid'),
    });
    if (response == null) {
      throw ApiException.fromString("response null");
    }
    List<dynamic> list = response['data'] ?? [];
    List<WarningModel> warning =
        list.map<WarningModel>((e) => WarningModel.fromJson(e)).toList();
    return ApiResponse<List<WarningModel>>.fromJson(response, warning);
  }

  Future<ApiResponse2<List<PolicyModel>>> userPolicy() async {
    // SharedPreferences _pref = await SharedPreferences.getInstance();
    var response = await _api.getRequest("user/fetch_policy", data: {});
    List<dynamic> list = response['data'] ?? [];
    List<PolicyModel> policy =
        list.map<PolicyModel>((e) => PolicyModel.fromJson(e)).toList();
    return ApiResponse2<List<PolicyModel>>.fromJson(response, policy);
  }

  Future<ApiResponse2<User>> employeeDetails(id) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    var response = await _api.getRequest(
      "user/details",
      data: {
        'user_id': id,
      },
    );
    if (response == null) {
      throw ApiException.fromString("response null");
    }
    return ApiResponse2.fromJson(response,
        response['data'] == null ? null : User.fromJson(response['data']));
  }

  Future<ApiResponse2> todayWorking() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    var response = await _api.getRequest(
      "today_working_details",
      data: {
        'emp_id': _pref.getString('uid'),
        'date' : "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}",
      },
    );
    if (response == null) {
      throw ApiException.fromString("response null");
    }
    return ApiResponse2.fromJson(response,response['data']);
  }

  Future<ApiResponse2> checkInAttendance(String work,File image, String latitude,String longitude, String attendanceType,String dayCount) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();

    var response = await _api.postRequest("mark_attendence", {
      "user_id": _pref.getString('uid'),
      "date" : "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}",
      "check_in" : DateTime.now(),
      "check_in_latitude" : latitude,
      "check_in_longitude" : longitude,
      "check_in_worknote" : work,
      "image" : await MultipartFile.fromFile(image.path,
        filename: image.path.split("/").last
      ),
      "type" : "check_in",
      "attend_type" : attendanceType,
      "daycont" : dayCount,
    },withFile: true);
    if (response == null) {
      throw ApiException.fromString("response null");
    }
    return ApiResponse2.fromJson(response,response['data']);
  }

  Future<ApiResponse2> checkOutAttendance(String work,File image, String latitude,String longitude, String dayCount) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();

    var response = await _api.postRequest("mark_attendence", {
      "user_id": _pref.getString('uid'),
      "date" : "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}",
      "check_out" : DateTime.now(),
      "check_out_latitude" : latitude,
      "check_out_longitude" : longitude,
      "check_out_worknote" : work,
      "image" : await MultipartFile.fromFile(image.path,
          filename: image.path.split("/").last
      ),
      "type" : "check_out",
      "daycont" : dayCount,
    },withFile: true);
    if (response == null) {
      throw ApiException.fromString("response null");
    }
    return ApiResponse2.fromJson(response,response['data']);
  }

  Future<ApiResponse2> getDoingTaskData(String type)async{
    var response=await _api.postRequest("employee/detailst", {
      "user_id":prefs.getString('uid'),
    });
    return ApiResponse2.fromJson(response,response['data']['task'][type]);
  }

}
