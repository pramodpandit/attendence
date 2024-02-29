import 'package:shared_preferences/shared_preferences.dart';

import '../model/Task_list.dart';
import '../model/api_response.dart';
import '../model/community_list.dart';
import '../network/api_service.dart';

class TaskRepositary{
  final SharedPreferences prefs;
  final ApiService _api;

  TaskRepositary(this.prefs, this._api);
  Future<ApiResponse4<List<TaskData>>> getTaskData()async{
    var response=await _api.postRequest("fetch_tasks", {
      "user_id":prefs.getString('uid'),
    });
    //print('jek${response['data']['data']}');
    return ApiResponse4.fromJson(response,List.from((response['data'] ?? []).map((e) => TaskData.fromJson(e))));
  }

// Future<List<Getcommunity>> getLeaveRecords() async{
//   SharedPreferences _pref = await SharedPreferences.getInstance();
//   Map<String, dynamic> data = {
//     "user_id": _pref.getString('uid'),
//   };
//
//   var response= await _api.postRequest("getpost", data);
//   if(response==null){
//     throw ApiException.fromString("response null");
//   }
//   List<dynamic> list2 = (response??[]);
//   List<Getcommunity> resp = list2.map<Getcommunity>((item)=>Getcommunity.fromJson(item)).toList();
//   return resp;
// }

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
      var response = await _api.getRequest("lead/projects");
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

}