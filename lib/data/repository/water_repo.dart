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

  Future<ApiResponse3> addWaterTypeDaily(String? date,String? type,String? quantity) async {
    var response = await _api.postRequest("add_waterdaily", {
      "user_id": prefs.getString('uid'),
      "date": date,
      "type": type,
      "quantity": quantity,
    });
    if (response == null) {
      throw ApiException.fromString("response null");
    }
    return ApiResponse3.fromJson(response);
  }

  Future<List<Water>> fetchWaterList(String? month,String? year) async {
    var response = await _api.postRequest("fetch_waterlist",{
      "user_id": prefs.getString('uid'),
      "month": month,
      "year": year,
    });
    if (response == null) {
      throw ApiException.fromString("response null");
    }
    return List.from(response['data'].map((e) => Water.fromJson(e)));
  }

}
