import 'dart:convert';

import 'package:office/data/model/e_bill_model.dart';
import 'package:office/data/network/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/api_response.dart';
import '../network/api_exception.dart';

class EBillRepository {
  final SharedPreferences prefs;
  final ApiService _api;

  EBillRepository(this.prefs, this._api);

  Future<List<EBill>> fetchEBill(String? date) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    var response = await _api.postRequest(
      "fetch_ebilldaily",
      {
        'user_id': _pref.getString('uid'),
        'date': date,
      },
    );
    if (response == null) {
      throw ApiException.fromString("response null");
    }
    return List.from(response['data'].map((e) => EBill.fromJson(e)));
  }

  addEBillDaily(List<Map<String, dynamic>> billDaily)async{
    var response = await _api.postRequest('add_ebilldaily', {
      "data":jsonEncode(billDaily),
    });
    if (response == null) {
      throw ApiException.fromString("response null");
    }
    return response;
  }

}
