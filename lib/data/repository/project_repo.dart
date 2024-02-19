import 'dart:io';
import 'package:dio/dio.dart';
import 'package:office/data/network/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/api_response.dart';
import '../network/api_exception.dart';

class ProjectRepository {
  final SharedPreferences prefs;
  final ApiService _api;

  ProjectRepository(this.prefs, this._api);

  Future<ApiResponse2> fetchAllProjects() async {

    var response = await _api.postRequest("employee/detailst", {
      "user_id": prefs.getString('uid'),
      // "user_id": 95,
    });
    if (response == null) {
      ApiException.fromString("response null");
    }
    return ApiResponse2.fromJson(response,response);
  }
  Future<ApiResponse2> fetchAllProjectsDetail(int id) async {

    var response = await _api.postRequest("project/details", {
      "project_id": id,
      // "user_id": 95,
    });
   // print('data api${response}');
    if (response == null) {
      ApiException.fromString("response null");
    }
    return ApiResponse2.fromJson(response,response);
  }

}
