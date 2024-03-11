import 'package:office/data/model/water_type_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/api_response.dart';
import '../model/water_model.dart';
import '../network/api_exception.dart';
import '../network/api_service.dart';

class WaterRepository {
  final SharedPreferences prefs;
  final ApiService _api;

  WaterRepository(this.prefs, this._api);


  Future<ApiResponse2<Water>> fetchWaterDaily(String? date,String? type) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    var response = await _api.postRequest(
      "fetch_waterdaily",
      {
        'user_id': _pref.getString('uid'),
        'date': date,
        'type':type,
      },
    );
    if (response == null) {
      throw ApiException.fromString("response null");
    }
    return ApiResponse2.fromJson(response,
        response['data'] == null ? null : Water.fromJson(response['data']));
  }

  Future<List<WaterType>> fetchWaterType() async {
    var response = await _api.getRequest("fetch_watertype");
    if (response == null) {
      throw ApiException.fromString("response null");
    }
    return List.from(response['data'].map((e) => WaterType.fromJson(e)));
  }

  Future<ApiResponse2> addWaterTypeDaily(String? date,String? type,String? quantity, branchid) async {
    var response = await _api.postRequest("add_waterdaily", {
      "user_id": prefs.getString('uid'),
      "date": date,
      "type": type,
      "quantity": quantity,
      "branch_id":branchid
    });
    print('date is :$response');
    if (response == null) {
      throw ApiException.fromString("response null");
    }
    return ApiResponse2.fromJson(response);
  }

  Future<ApiResponse2> fetchWaterList(String? month,String? year) async {
    var response = await _api.postRequest("fetch_waterlist",{
      "user_id": prefs.getString('uid'),
      "month": month,
      "year": year,
    });
    if (response == null) {
      throw ApiException.fromString("response null");
    }
    return ApiResponse2.fromJson(response,response["data"]);
  }
  Future<ApiResponse2> Add(String url,Map<String,dynamic> data,) async {
    try{
      SharedPreferences _pref = await SharedPreferences.getInstance();
      var response= await _api.getRequest(url,data: data);
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
