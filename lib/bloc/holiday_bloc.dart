import 'package:flutter/material.dart';
import 'package:office/bloc/bloc.dart';
import 'package:office/data/model/events_model.dart';
import 'package:office/data/model/holiday_model.dart';
import 'package:office/data/repository/holiday_repo.dart';
import 'package:table_calendar/table_calendar.dart';

class HolidayEventBloc extends Bloc {
  final HolidayEventRepository _repo;

  HolidayEventBloc(this._repo);
  ValueNotifier<CalendarFormat> calendar = ValueNotifier(CalendarFormat.week);
  DateTime focusDay = DateTime.now();
  ValueNotifier<DateTime?> startYear = ValueNotifier(DateTime.now());
  updateStartYear(DateTime value) => startYear.value = value;
  ValueNotifier<DateTime?> startEventYear = ValueNotifier(DateTime.now());
  updateStartEventYear(DateTime value) => startEventYear.value = value;
  ValueNotifier<List<Holiday>> holidayData = ValueNotifier(<Holiday>[]);
  ValueNotifier<bool> isHolidayLoading = ValueNotifier(false);
  Map<DateTime, List<dynamic>> eventsListBadge = {DateTime.now():['a','b']};

  holidayList(String month,String year) async {
     try{
      isHolidayLoading.value = true;
      print('date$month  and year$year');
      var result = await _repo.holidayList(month,year);
      if(result != null && result.isNotEmpty){
        holidayData.value = [];
        holidayData.value = result;
      }else{
        holidayData.value = [];
      }
    }catch (e,s) {
      debugPrint("$e");
      debugPrint("$s");
    }finally{
      isHolidayLoading.value = false;
    }
  }
  ValueNotifier<List<Events>> eventsData = ValueNotifier(<Events>[]);
  ValueNotifier<bool> isEventLoading = ValueNotifier(false);
  eventsList(String month,String year) async {
     try{
      isEventLoading.value = true;
      var result = await _repo.eventsList(month,year);
      if(result != null && result.isNotEmpty){
        eventsData.value = [];
        eventsData.value = result;
      }else{
        eventsData.value = [];
      }
    }catch (e,s) {
      debugPrint("$e");
      debugPrint("$s");
    }finally{
      isEventLoading.value = false;
    }
  }
  List  months = [
    {
      "month":"January",
      "value":"1"
    },
    {
      "month":"Febuary",
      "value":"2"
    },
    {
      "month":"March",
      "value":"3"
    },
    {
      "month":"April",
      "value":"4"
    },
    {
      "month":"May",
      "value":"5"
    },
    {
      "month":"June",
      "value":"6"
    },
    {
      "month":"July",
      "value":"7"
    },
    {
      "month":"August",
      "value":"8"
    },
    {
      "month":"September",
      "value":"9"
    },
    {
      "month":"October",
      "value":"10"
    },
    {
      "month":"November",
      "value":"11"
    },
    {
      "month":"December",
      "value":"12"
    },
  ];


  ValueNotifier<List> attendanceData = ValueNotifier(<Events>[]);
  ValueNotifier<bool> isAttendanceLoading = ValueNotifier(false);
}