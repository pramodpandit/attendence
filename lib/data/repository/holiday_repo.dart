import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:office/data/model/events_model.dart';
import 'package:office/data/model/holiday_model.dart';
import 'package:office/data/network/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HolidayEventRepository {
  final SharedPreferences prefs;
  final ApiService _api;

  HolidayEventRepository(this.prefs, this._api);

  Future<List<Holiday>?> holidayList (String month,String year)async{
    var response=await _api.getRequest("leave/holidays",data: {
      "user_id":prefs.getString('uid'),
      "month":month,
      "year":year,
    });
    print("holiday list is : ${response}");
    List<dynamic> list = response ?? [];
    List<Holiday> documents = list.map<Holiday>((e) => Holiday.fromJson(e)).toList();
    return documents;
  }

    Future<List<Events>?> eventsList (String month,String year)async{
    var response=await _api.getRequest("events",data: {
      "user_id":prefs.getString('uid'),
      "month":month,
      "year":year,
    });
    List<dynamic> list = response ?? [];
    List<Events> documents = list.map<Events>((e) => Events.fromJson(e)).toList();
    return documents;
  }

}