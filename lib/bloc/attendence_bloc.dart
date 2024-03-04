import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:office/bloc/bloc.dart';
import 'package:office/data/model/events_model.dart';
import 'package:office/data/model/holiday_model.dart';
import 'package:office/data/repository/attendance_repo.dart';
import 'package:office/data/repository/holiday_repo.dart';
import 'package:table_calendar/table_calendar.dart';

class AttendanceBloc extends Bloc {
  final AttendanceRepository _repo;

  AttendanceBloc(this._repo);
  ValueNotifier<CalendarFormat> calendar = ValueNotifier(CalendarFormat.week);
  DateTime focusDay = DateTime.now();
  ValueNotifier<DateTime?> startYear = ValueNotifier(DateTime.now());
  updateStartYear(DateTime value) => startYear.value = value;
  ValueNotifier<List?> allAttendanceData = ValueNotifier(null);
  ValueNotifier<bool> isHolidayLoading = ValueNotifier(false);
  Map<DateTime, List<dynamic>> eventsListBadge = {DateTime.now():['a','b']};
  ValueNotifier<DateTime?> month = ValueNotifier(DateTime.now());
  ValueNotifier<DateTime?> startmonth = ValueNotifier(DateTime.now());
  ValueNotifier<DateTime?> year = ValueNotifier(DateTime.now());
  updateMonth(DateTime value) => month.value = value;
  updateStartMonth(DateTime value) => startmonth.value = value;
  updateYear(DateTime value) => year.value = value;

  ValueNotifier<List?> allAttendanceType = ValueNotifier(null);

  getAttendanceType() async {
    try{
      var result = await _repo.fetchAttendanceTypeList();
      allAttendanceType.value = result;
    }catch (e,s) {
      debugPrint("$e");
      debugPrint("$s");
    }
  }
  fetchAttendanceData() async {
    try{
      isHolidayLoading.value = true;
      String months = DateFormat('MM').format(startmonth.value!);
      String years = DateFormat('yyyy').format(startYear.value!);
      print('date$month  and year$year');
      var result = await _repo.attendanceList(months,years);
        print("my attendance is : ${result}");
      if(result.isNotEmpty){
        allAttendanceData.value = [];
        allAttendanceData.value = result;
      }else{
        allAttendanceData.value = [];
      }
    }catch (e,s) {
      debugPrint("$e");
      debugPrint("$s");
    }
    // finally{
    //   isHolidayLoading.value = false;
    // }
  }
  ValueNotifier<List<Events>> eventsData = ValueNotifier(<Events>[]);
  ValueNotifier<bool> isEventLoading = ValueNotifier(false);
  // eventsList() async {
  //   try{
  //     isEventLoading.value = true;
  //     String months = DateFormat('MM').format(month.value!);
  //     String years = DateFormat('yyyy').format(year.value!);
  //     var result = await _repo.eventsList(months,years);
  //     if(result != null && result.isNotEmpty){
  //       eventsData.value = [];
  //       eventsData.value = result;
  //     }else{
  //       eventsData.value = [];
  //     }
  //   }catch (e,s) {
  //     debugPrint("$e");
  //     debugPrint("$s");
  //   }finally{
  //     isEventLoading.value = false;
  //   }
  // }



  ValueNotifier<List> attendanceData = ValueNotifier(<Events>[]);
  ValueNotifier<bool> isAttendanceLoading = ValueNotifier(false);
}