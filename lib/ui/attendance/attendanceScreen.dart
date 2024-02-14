import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:office/bloc/holiday_bloc.dart';
import 'package:office/data/model/holiday_model.dart';
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
  late HolidayEventBloc holidayBloc;
  int month = DateTime.now().month;
  var value;
  var condition;

  @override
  void initState() {
    holidayBloc = HolidayEventBloc(context.read<HolidayEventRepository>());
    super.initState();
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        child: DropdownButtonFormField<String>(
                          icon: const Icon(
                            Icons.keyboard_arrow_down_sharp,
                            color: Colors.grey,
                          ),
                          iconSize: 24,
                          elevation: 16,
                          style: const TextStyle(color: Colors.black, fontSize: 15),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[200],
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color(0xffF4F5F7)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color(0xffF2F2F2)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 10),
                            hintText: "${DateFormat.MMMM().format(DateTime.now())}",
                            hintStyle: TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 15,fontWeight: FontWeight.w500),
                          ),
                          onChanged: (String? data) {
                            var year = DateTime.now().year;
                            print("helo$data");
                            print(year);
                            holidayBloc.holidayList(data!, year.toString());

                          },
                          items: holidayBloc.months.map<DropdownMenuItem<String>>((value) {
                            return DropdownMenuItem<String>(
                              value: value['value'].toString(),
                              child: Text(value['month'].toString(),style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w500),),
                            );
                          }).toList(),
                        ),
                      ),
                    ):condition =='2'?
                    ValueListenableBuilder(
                      valueListenable: holidayBloc.calendar,
                      builder: (context, calendarFormatValue, child) {
                        return ValueListenableBuilder(
                          valueListenable: holidayBloc.holidayData,
                          builder: (BuildContext context, List<Holiday> value, Widget? child) {
                            Map<DateTime, List<dynamic>> eventsList = {};
                            final events = LinkedHashMap(
                              equals: isSameDay,
                            )..addAll(eventsList);
                            List _getEventsForDay(DateTime day) {
                              return events[day] ?? [];
                            }
                            print("focusDay1 ${holidayBloc.focusDay}");
                           return TableCalendar(
                              eventLoader: (day) {
                              return _getEventsForDay(day);
                              },
                              firstDay: DateTime.utc(DateTime.now().year, 01, 01),
                              lastDay: DateTime.utc(DateTime.now().year, 12, 31),
                              focusedDay: holidayBloc.focusDay,
                              currentDay: holidayBloc.focusDay/*DateTime.now()*/,
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
                                  print(holidayBloc.focusDay);
                                  month = focusedDay.month;
                                  holidayBloc.focusDay = focusedDay;
                                }
                              },
                              onFormatChanged: (format) {
                                if (value != format) {
                                  holidayBloc.calendar.value = format;
                                }
                              },
                             onDaySelected: (selectedDay, focusedDay) {
                                print("Selected Day: $selectedDay");
                               setState(() {
                                 holidayBloc.focusDay = selectedDay;
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
                      valueListenable: holidayBloc.calendar,
                      builder: (context, calendarFormatValue, child) {
                        return ValueListenableBuilder(
                          valueListenable: holidayBloc.holidayData,
                          builder: (BuildContext context, List<Holiday> value, Widget? child) {
                            Map<DateTime, List<dynamic>> eventsList = {};
                            final events = LinkedHashMap(
                              equals: isSameDay,
                            )..addAll(eventsList);
                            List _getEventsForDay(DateTime day) {
                              return events[day] ?? [];
                            }
                            print("focusDay1 ${holidayBloc.focusDay}");
                            return TableCalendar(
                              eventLoader: (day) {
                                return _getEventsForDay(day);
                              },
                              firstDay: DateTime.utc(DateTime.now().year, 01, 01),
                              lastDay: DateTime.utc(DateTime.now().year, 12, 31),
                              focusedDay: holidayBloc.focusDay,
                              currentDay: holidayBloc.focusDay/*DateTime.now()*/,
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
                                  print(holidayBloc.focusDay);
                                  month = focusedDay.month;
                                  holidayBloc.focusDay = focusedDay;
                                }
                              },
                              onFormatChanged: (format) {
                                if (value != format) {
                                  holidayBloc.calendar.value = format;
                                }
                              },
                              onDaySelected: (selectedDay, focusedDay) {
                                print("Selected Day: $selectedDay");
                                setState(() {
                                  holidayBloc.focusDay = selectedDay;
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
                                      valueListenable: holidayBloc.isAttendanceLoading,
                                      builder: (BuildContext context, bool isLoading,
                                          Widget? child) {
                                        return ValueListenableBuilder(
                                          valueListenable: holidayBloc.attendanceData,
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
                                                  child: ListView.builder(
                                                    physics: const ScrollPhysics(),
                                                    itemCount: 2,
                                                    // attendance.length,
                                                    itemBuilder: (_, index) {
                                                      return AttendanceList();
                                                    },
                                                  ),
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
  // final int index;
  // final List<Holiday> data;
  const AttendanceList({super.key});

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
                        "Thu",
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
                        "06",
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
                "9:10 AM",
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
               Text(
                // data[index].reason ?? 
                "6:20 PM",
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
               Text(
                // data[index].reason ?? 
                "9:15",
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
                  "Present",
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

