import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:office/data/model/events_model.dart';
import 'package:office/data/model/holiday_model.dart';
import 'package:office/data/network/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExpenseRepository {
  final SharedPreferences prefs;
  final ApiService _api;

  ExpenseRepository(this.prefs, this._api);

  Future userDetails() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    var response = await _api.getRequest(
      "user/details",
      data: {
        'user_id': _pref.getString('uid'),
      },
    );
    return response;
  }

  Future fetchActiveExpenseTypeData()async{
    try{
      var res = _api.getRequest("get-active-expance");
      return res;
    }catch(e){
      throw e;
    }
  }
  Future fetchExpenseData(Map<String,dynamic> data)async{
    try{
      var res = _api.postRequest("get-item-expance", data);
      return res;
    }catch(e){
      throw e;
    }
  }

  Future addExpenseData(Map<String,dynamic> data)async{
    try{
      var res = _api.postRequest("post-add-item", data);
      return res;
    }catch(e){
      throw e;
    }
  }

}