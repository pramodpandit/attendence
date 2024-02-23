import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:office/bloc/attendence_bloc.dart';
import 'package:office/bloc/holiday_bloc.dart';
import 'package:office/data/model/holiday_model.dart';
import 'package:office/data/repository/attendance_repo.dart';
import 'package:office/data/repository/holiday_repo.dart';
import 'package:office/ui/attendance/attendancePolicy.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';


class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  late AttendanceBloc attendanceBloc;
  int month = DateTime.now().month;
  var value;
  var condition;
  int? selectedYear;

  @override
  void initState() {
    attendanceBloc = AttendanceBloc(context.read<AttendanceRepository>());
    super.initState();
    attendanceBloc.fetchAttendanceData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: MyAppBar(
      //   title: 'Attendance',
      //   actions: [
      //     Padding(
      //       padding: EdgeInsets.only(right: 10.0),
      //       child: GestureDetector(
      //           onTap: () {
      //             Navigator.of(context).push(MaterialPageRoute(
      //                 builder: (context) => AttendancePolicyScreen()));
      //           },
      //           child: Icon(Icons.question_mark)),
      //     )
      //   ],
      // ),
      body: Stack(
        children: [
          Container(
            height: 100,
            width: 1.sw,
            decoration: const BoxDecoration(
                color: Color(0xFF009FE3),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20))
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 56,),
                Text(
                  "Attendance",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 56,
            left: 10,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const CircleAvatar(
                backgroundColor: Colors.white,
                radius: 15,
                child: Icon(Icons.arrow_back, size: 18,),
              ),
            ),
          ),
          Positioned(
            top: 56,
            right: 10,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const AttendancePolicyScreen()));
              },
              child: const CircleAvatar(
                backgroundColor: Colors.white,
                radius: 15,
                child: Icon(Icons.question_mark, size: 18,),
              ),
            ),
          ),
          Column(
            children: [
              const SizedBox(height: 110,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: (){
                      setState(() {
                        condition = '2';
                      });
                    },
                    child: Container(
                        height: 40,
                        width: 40,
                        child: Image.asset('images/img.png',fit: BoxFit.cover,)),
                  ),
                  InkWell(
                    onTap: (){
                      setState(() {
                        condition = '1';
                      });
                    },
                    child: Container(
                        height: 22,
                        width: 22,
                        child: Image.asset('images/img_1.png',height: 30,width: 30,)),
                  ),
                  SizedBox(width: 20,)
                ],
              ),

              Expanded(
                child: Column(
                  children: [
                    condition =='1'?
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(
                                "Select Year",
                                style: const TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            ValueListenableBuilder(
                                valueListenable: attendanceBloc.startYear,
                                builder: (context, DateTime? date, _) {
                                  return InkWell(
                                    // onTap: () async {
                                    //   DateTime? dt = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now().subtract(Duration(days: 15)), lastDate:  DateTime.now().add(Duration(days: 30)),);
                                    //   if(dt!=null) {
                                    //     await holidayBloc.updateStartYear(dt);
                                    //   }
                                    // },
                                    onTap: () async {
                                      int? selectedYear = await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title:
                                            const Text("Select Year"),
                                            content: DropdownButton<int>(
                                              value: date?.year ??
                                                  DateTime.now().year,
                                              items: List.generate(30,
                                                      (index) {
                                                    return DropdownMenuItem<
                                                        int>(
                                                      value:
                                                      DateTime.now().year -
                                                          15 +
                                                          index,
                                                      child: Text(
                                                          (DateTime.now().year -
                                                              15 +
                                                              index)
                                                              .toString()),
                                                    );
                                                  }),
                                              onChanged: (int? value) {
                                                attendanceBloc.allAttendanceData.value = null;
                                                Navigator.pop(
                                                    context, value);
                                              },
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(
                                                      context,
                                                      date?.year ??
                                                          DateTime.now()
                                                              .year);
                                                },
                                                child: Text('Select'),
                                              ),
                                            ],
                                          );
                                        },
                                      );

                                      if (selectedYear != null) {
                                        DateTime selectedDate =
                                        DateTime(selectedYear);
                                        await attendanceBloc.updateStartYear(selectedDate);
                                        await attendanceBloc.fetchAttendanceData();
                                        print("$selectedDate");
                                      }
                                    },

                                    child: Container(
                                      height: 50,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius:
                                        BorderRadius.circular(5),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(PhosphorIcons.clock),
                                          const SizedBox(width: 15),
                                          Text(
                                            date == null
                                                ? DateFormat('yyyy')
                                                .format(DateTime.now())
                                                : DateFormat('yyyy')
                                                .format(date),
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(
                                "Select Month",
                                style: const TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            ValueListenableBuilder(
                              valueListenable: attendanceBloc.startmonth,
                              builder: (context, DateTime? monthDate, _) {
                                return InkWell(
                                  onTap: () async {
                                    int? selectedMonth = await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text("Select Month"),
                                          content: DropdownButton<int>(
                                            value: monthDate?.month ??
                                                DateTime.now().month,
                                            items:
                                            List.generate(12, (index) {
                                              return DropdownMenuItem<int>(
                                                value: index + 1,
                                                child: Text(
                                                  DateFormat('MMMM').format(
                                                      DateTime(
                                                          DateTime.now()
                                                              .year,
                                                          index + 1,
                                                          1)),
                                                ),
                                              );
                                            }),
                                            onChanged: (int? value) {
                                              attendanceBloc.allAttendanceData.value = null;
                                              Navigator.pop(context, value);
                                            },
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(
                                                    context,
                                                    monthDate?.month ??
                                                        DateTime.now()
                                                            .month);
                                              },
                                              child: Text('Select'),
                                            ),
                                          ],
                                        );
                                      },
                                    );

                                    if (selectedMonth != null) {
                                      DateTime selectedDate = DateTime(
                                        attendanceBloc.year.value?.year ??
                                            DateTime.now().year,
                                        selectedMonth,
                                      );
                                      await attendanceBloc.updateStartMonth(selectedDate);
                                      await attendanceBloc.fetchAttendanceData();
                                      print("$selectedDate");
                                    }
                                  },
                                  child: Container(
                                    height: 50,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius:
                                      BorderRadius.circular(5),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(PhosphorIcons.calendar),
                                        const SizedBox(width: 15),
                                        Text(
                                          monthDate == null
                                              ? DateFormat('MMMM').format(
                                              DateTime(
                                                  DateTime.now().year,
                                                  DateTime.now().month,
                                                  1))
                                              : DateFormat('MMMM').format(
                                              DateTime(
                                                  DateTime.now().year,
                                                  monthDate.month,
                                                  1)),
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    )
                        :condition =='2'?
                    ValueListenableBuilder(
                      valueListenable: attendanceBloc.calendar,
                      builder: (context, calendarFormatValue, child) {
                        return ValueListenableBuilder(
                          valueListenable: attendanceBloc.allAttendanceData,
                          builder: (BuildContext context, value, Widget? child) {
                            Map<DateTime, List<dynamic>> eventsList = {};
                            final events = LinkedHashMap(
                              equals: isSameDay,
                            )..addAll(eventsList);
                            List _getEventsForDay(DateTime day) {
                              return events[day] ?? [];
                            }
                            print("focusDay1 ${attendanceBloc.focusDay}");
                           return TableCalendar(
                              eventLoader: (day) {
                              return _getEventsForDay(day);
                              },
                              firstDay: DateTime.utc(DateTime.now().year, 01, 01),
                              lastDay: DateTime.utc(DateTime.now().year, 12, 31),
                              focusedDay: attendanceBloc.focusDay,
                              currentDay: attendanceBloc.focusDay/*DateTime.now()*/,
                              headerStyle: const HeaderStyle(
                                formatButtonVisible: false,
                              ),
                              calendarStyle: const CalendarStyle(
                                weekendTextStyle: TextStyle(color: Colors.red),
                              ),
                              daysOfWeekStyle: const DaysOfWeekStyle(
                                weekendStyle: TextStyle(color: Colors.red),
                              ),
                              startingDayOfWeek: StartingDayOfWeek.monday,
                              calendarFormat: calendarFormatValue,
                              onPageChanged: (focusedDay) {
                                if(focusedDay.month != month){
                                  print(attendanceBloc.focusDay);
                                  month = focusedDay.month;
                                  attendanceBloc.focusDay = focusedDay;
                                }
                              },
                              onFormatChanged: (format) {
                                if (value != format) {
                                  attendanceBloc.calendar.value = format;
                                }
                              },
                             onDaySelected: (selectedDay, focusedDay) {
                                print("Selected Day: $selectedDay");
                               setState(() {
                                 attendanceBloc.focusDay = selectedDay;
                               });
                             },
                              availableCalendarFormats: const {
                                CalendarFormat.month: 'Month',
                                CalendarFormat.week: 'Weeks',
                              },
                            );
                          },
                        );
                      },
                    ):
                    ValueListenableBuilder(
                      valueListenable: attendanceBloc.calendar,
                      builder: (context, calendarFormatValue, child) {
                        return ValueListenableBuilder(
                          valueListenable: attendanceBloc.allAttendanceData,
                          builder: (BuildContext context, value, Widget? child) {
                            Map<DateTime, List<dynamic>> eventsList = {};
                            final events = LinkedHashMap(
                              equals: isSameDay,
                            )..addAll(eventsList);
                            List _getEventsForDay(DateTime day) {
                              return events[day] ?? [];
                            }
                            print("focusDay1 ${attendanceBloc.focusDay}");
                            return TableCalendar(
                              eventLoader: (day) {
                                return _getEventsForDay(day);
                              },
                              firstDay: DateTime.utc(DateTime.now().year, 01, 01),
                              lastDay: DateTime.utc(DateTime.now().year, 12, 31),
                              focusedDay: attendanceBloc.focusDay,
                              currentDay: attendanceBloc.focusDay/*DateTime.now()*/,
                              headerStyle: const HeaderStyle(
                                formatButtonVisible: false,
                              ),
                              calendarStyle: const CalendarStyle(
                                weekendTextStyle: TextStyle(color: Colors.red),
                              ),
                              daysOfWeekStyle: const DaysOfWeekStyle(
                                weekendStyle: TextStyle(color: Colors.red),
                              ),
                              startingDayOfWeek: StartingDayOfWeek.monday,
                              calendarFormat: calendarFormatValue,
                              onPageChanged: (focusedDay) {
                                if(focusedDay.month != month){
                                  print(attendanceBloc.focusDay);
                                  month = focusedDay.month;
                                  attendanceBloc.focusDay = focusedDay;
                                }
                              },
                              onFormatChanged: (format) {
                                if (value != format) {
                                  attendanceBloc.calendar.value = format;
                                }
                              },
                              onDaySelected: (selectedDay, focusedDay) {
                                print("Selected Day: $selectedDay");
                                setState(() {
                                  attendanceBloc.focusDay = selectedDay;
                                });
                              },
                              availableCalendarFormats: const {
                                CalendarFormat.month: 'Month',
                                CalendarFormat.week: 'Weeks',
                              },
                            );
                          },
                        );
                      },
                    ),
                    SizedBox(height: 20,),
                    Expanded(
                      child:
                      Container(
                        padding: const EdgeInsets.only(bottom: 20),
                        color: Colors.grey.shade100.withOpacity(0.5),
                        child: ValueListenableBuilder(
                              valueListenable: attendanceBloc.isAttendanceLoading,
                              builder: (BuildContext context, bool isLoading,
                                  Widget? child) {
                                return ValueListenableBuilder(
                                  valueListenable: attendanceBloc.attendanceData,
                                  builder: (BuildContext context,
                                      List attendance, Widget? child) {
                                    if (isLoading) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    // if(attendance.isEmpty){
                                    //   return Center(
                                    //     child: Text(
                                    //       "No Data Found",
                                    //       style: TextStyle(
                                    //         fontWeight: FontWeight.w600,
                                    //         fontSize: 18,
                                    //       ),
                                    //     ),
                                    //   );
                                    // }
                                    return Column(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.symmetric(horizontal: 20),
                                          padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10,right: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.withOpacity(0.3),
                                            boxShadow: [
                                              BoxShadow(
                                                  spreadRadius: 0,
                                                  blurRadius: 3,
                                                  color: Colors.black.withOpacity(0.1))
                                            ],
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Date'
                                              ,style: TextStyle(fontSize: 12),
                                              ),
                                              Row(
                                                children: [
                                                  Text('Punchin' ,style: TextStyle(fontSize: 12),),
                                                  Icon(PhosphorIcons.arrow_up,size: 15,color: Colors.green,)
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text('Punchout' ,style: TextStyle(fontSize: 12),),
                                                  Icon(PhosphorIcons.arrow_down,size: 15,color: Colors.red,)
                                                ],
                                              ),
                                              Text('Working Hour' ,style: TextStyle(fontSize: 12),),
                                              Text('Status' ,style: TextStyle(fontSize: 12),),
                                            ],
                                          )
                                        ),
                                        Expanded(
                                          child: ValueListenableBuilder(
                                            valueListenable: attendanceBloc.allAttendanceData,
                                            builder: (context, allData, child) {
                                              if(allData == null){
                                                return Center(child: CircularProgressIndicator(strokeWidth: 2,));
                                              }
                                              if(allData.isEmpty){
                                                return Center(child: Text("No data available"));
                                              }
                                            return ListView.builder(
                                              physics: const ScrollPhysics(),
                                              itemCount: allData.length,
                                              // attendance.length,
                                              itemBuilder: (_, index) {
                                                return AttendanceList(data: allData[index]);
                                              },
                                            );
                                          },),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),

                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AttendanceList extends StatelessWidget {
  final Map data;
  const AttendanceList({super.key,required this.data});

  String calculateTimeGap() {
    if(data["check_in"]!=null && data["checkout"] != null){
      Duration timeGap = DateTime.parse(data["check_in"]).difference(DateTime.parse(data["checkout"]));
      int hours = timeGap.inHours.abs();
      int minutes = (timeGap.inMinutes - hours * 60).abs();
      // int seconds = (timeGap.inSeconds - hours * 3600 - minutes * 60);
      return "${hours.toString().padLeft(2,'0')}:${minutes.toString().padLeft(2, '0')}";
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10,right: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  spreadRadius: 0,
                  blurRadius: 3,
                  color: Colors.black.withOpacity(0.1))
            ],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    // DateFormat.E().format(
                    //         DateTime.parse("${data[index].holidayDate}")) ??
                        DateFormat("EEE").format(DateTime.parse(data["mark_date"])),
                    style: const TextStyle(
                      fontSize: 11,
                      fontFamily: 'Poppins',
                      color: Colors.blue,
                    ),
                  ),
                  Text(
                    // DateTime.parse("${data[index].holidayDate}")
                    //         .day
                    //         .toString() ??
                    "${DateTime.parse(data["mark_date"]).day}",
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              // const SizedBox(height: 30, child: VerticalDivider()),
              // const SizedBox(
              //   width: 10,
              // ),
              Text(
                // data[index].reason ??
                data["check_in"]!=null?DateFormat("h:mm a").format(DateTime.parse(data["check_in"])):"",
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
               Text(
                // data[index].reason ??
                 data["checkout"]!=null?DateFormat("h:mm a").format(DateTime.parse(data["checkout"])):"",
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
               Text(
                // data[index].reason ??
                 calculateTimeGap(),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
               Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(2)
                ),
                 child: Text(
                  // data[index].reason ??
                  data["status_type"].toString().capitalizeFirstLetter(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.green
                  ),
                             ),
               ),
            ],
          )),
    );
  }
}

