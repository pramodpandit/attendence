import 'package:shared_preferences/shared_preferences.dart';

import '../model/api_response.dart';
import '../model/community_list.dart';
import '../model/feedback_model.dart';
import '../network/api_exception.dart';
import '../network/api_service.dart';

class CommunityRepositary{
  final SharedPreferences prefs;
  final ApiService _api;

  CommunityRepositary(this.prefs, this._api);
  Future<ApiResponse2<List<Data>>> getLeaveRecords()async{
    var response=await _api.getRequest("getpost",data: {
      "user_id":prefs.getString('uid'),
    });
    //print('jek${response['data']['data']}');
    return ApiResponse2.fromJson(response,List.from((response['data']['data'] ?? []).map((e) => Data.fromJson(e))));
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