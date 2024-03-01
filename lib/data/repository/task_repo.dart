import 'package:shared_preferences/shared_preferences.dart';

import '../model/Task_list.dart';
import '../model/api_response.dart';
import '../model/community_list.dart';
import '../network/api_exception.dart';
import '../network/api_service.dart';

class TaskRepositary{
  final SharedPreferences prefs;
  final ApiService _api;
  TaskRepositary(this.prefs, this._api);

  Future<ApiResponse2> getTaskData(String type)async{
    var response=await _api.postRequest("employee/detailst", {
      "user_id":prefs.getString('uid'),
    });
    return ApiResponse2.fromJson(response,response['data']['task'][type]);
  }

  Future<ApiResponse2> fetchAllTaskDetail(int id) async {
    var response = await _api.postRequest("tasks_details", {
      "user_id":prefs.getString('uid'),
      "task_id": id,
    });
    if (response == null) {
      ApiException.fromString("response null");
    }
    return ApiResponse2.fromJson(response,response);
  }

  Future<ApiResponse2> fetchAllTaskCategoryData()async{
    try{
      var response = await _api.getRequest("task_category");
      return ApiResponse2.fromJson(response,response['data']);
    }catch(e){
      throw Exception('data is not avaible ${e.toString()}');
    }
  }
  Future<ApiResponse2> fetchAllProjectsData()async{
    try{
      var response = await _api.getRequest("lead/projects",data: {
        "user_id" : prefs.getString("uid"),
      });
      return ApiResponse2.fromJson(response,response['data']);
    }catch(e){
      throw Exception('data is not avaible ${e.toString()}');
    }
  }
  Future<ApiResponse2> fetchEmployeesDataByProjectId(String projectId)async{
    try{
      var response = await _api.getRequest("project/projectmember-list",data: {
        "project_id" : projectId
      });
      return ApiResponse2.fromJson(response,response['data']);
    }catch(e){
      throw Exception('data is not avaible ${e.toString()}');
    }
  }
  Future<ApiResponse2> fetchAllDepartmentData()async{
    try{
      var response = await _api.getRequest("fetch_data");
      return ApiResponse2.fromJson(response,response['data']);
    }catch(e){
      throw Exception('data is not avaible ${e.toString()}');
    }
  }
  Future<ApiResponse2> fetchAllTaskLabelData()async{
    try{
      var response = await _api.getRequest("task_label");
      return ApiResponse2.fromJson(response,response['data']);
    }catch(e){
      throw Exception('data is not avaible ${e.toString()}');
    }
  }

  Future<ApiResponse2> addTaskFunction(Map<String,dynamic> data)async{
    try{
      var response = await _api.postRequest("add_task", data);
      return ApiResponse2.fromJson(response,response['data']);
    }catch(e){
      throw Exception('data is not avaible ${e.toString()}');
    }

  }

  Future<ApiResponse2> Add(String url,Map<String,dynamic> data,bool withfile) async {
    try{

      var response= await _api.postRequest(url,data,withFile: withfile);
      if (response == null) {
        ApiException.fromString("response null");
      }
      return ApiResponse2.fromJson(response,response);
    }catch(e){
      print("data is not avaible ${e.toString()}");
      throw Exception('data is not avaible ${e.toString()}');
    }
  }
  Future<ApiResponse4> getemployeedata()async{
    var response=await _api.getRequest("user/get_all_employee_details",data: {
      "user_id":prefs.getString('uid'),
    });

    if (response == null) {
      ApiException.fromString("response null");
    }
    return ApiResponse4.fromJson(response,response);
  }
}