import 'package:shared_preferences/shared_preferences.dart';

import '../model/api_response.dart';
import '../network/api_exception.dart';
import '../network/api_service.dart';

class TeamRepo{
  final SharedPreferences prefs;
  final ApiService _api;
  TeamRepo(this.prefs, this._api);

  Future<ApiResponse2> Add(String url,Map<String,dynamic> data,) async {
    try{
      SharedPreferences _pref = await SharedPreferences.getInstance();
      var response= await _api.postRequest(url,data);
      if (response == null) {
        ApiException.fromString("response null");
      }
      return ApiResponse2.fromJson(response,response["data"]);
    }catch(e){
      print("data is not avaible ${e.toString()}");
      throw Exception('data is not avaible ${e.toString()}');
    }
  }


}