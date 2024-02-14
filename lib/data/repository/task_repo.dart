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

}