import 'package:office/data/model/api_response.dart';
import 'package:office/data/model/document.dart';
import 'package:office/data/model/user_detail_model.dart';
import 'package:office/data/network/api_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/api_service.dart';

class AuthRepository {
  final SharedPreferences prefs;
  final ApiService _api;

  AuthRepository(this.prefs, this._api);


  Future<Map<String,dynamic>> userLoginWithEmail(String email, String password, {String? fcmToken}) async {
    Map<String, dynamic> data = {
      'phone': email,
      'password': password,
      // 'fcmToken': fcmToken ?? prefs.getString('device_token'),
    };
    if(fcmToken!=null) {
      data['fcm_token'] = fcmToken;
    }

    var res = await _api.postRequest('login_user', data);
    if (res == null) {
      throw ApiException.fromString("response null");
    }
    return res;
  }

  Future<ApiResponse2<UserDetail>> checkPhoneNumber(String phone) async {
    var data = {
      'phone':phone
    };
    var res = await _api.getRequest('user/check_phone',data: data);
    return ApiResponse2.fromJson(res,res['data'] != null ? UserDetail.fromJson(res['data']): null);
  }

  Future<ApiResponse2> resetPassword(String phone,String password)async{
    var response = await _api.postRequest("user/reset_password",
        {
          "phone":phone,
          "password":password
        });
    if(response==null){
      throw ApiException.fromString("response null");
    }
    return ApiResponse2.fromJson(response);
  }
}
