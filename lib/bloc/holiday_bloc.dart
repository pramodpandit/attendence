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

  ValueNotifier<List> attendanceData = ValueNotifier(<Events>[]);
  ValueNotifier<bool> isAttendanceLoading = ValueNotifier(false);
}