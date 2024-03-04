import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:office/data/model/events_model.dart';
import 'package:office/data/model/holiday_model.dart';
import 'package:office/data/network/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttendanceRepository {
  final SharedPreferences prefs;
  final ApiService _api;

  AttendanceRepository(this.prefs, this._api);

  Future<List> fetchAttendanceTypeList ()async{
    var response=await _api.getRequest("attendence/get_attendence_type");
    List<dynamic> list = response["data"] ?? [];
    return list;
  }
  Future<List> attendanceList (String month,String year)async{
    var response=await _api.postRequest("attendence_record", {
      "user_id":prefs.getString('uid'),
      "month":month.toInt(),
      "year":year.toInt(),
    });
    print("holiday list is : ${response['data']}");
    List<dynamic> list = response["data"] ?? [];
    // List documents = list.map((e) => Holiday.fromJson(e)).toList();
    return list;
  }

  // Future<List<Events>?> eventsList (String month,String year)async{
  //   var response=await _api.getRequest("events",data: {
  //     "user_id":prefs.getString('uid'),
  //     "month":month,
  //     "year":year,
  //   });
  //   List<dynamic> list = response ?? [];
  //   List<Events> documents = list.map<Events>((e) => Events.fromJson(e)).toList();
  //   return documents;
  // }

}