import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:office/bloc/holiday_bloc.dart';
import 'package:office/data/model/events_model.dart';
import 'package:office/data/model/holiday_model.dart';
import 'package:office/data/repository/holiday_repo.dart';
import 'package:office/ui/holiday/allHolidayScreen.dart';
import 'package:office/ui/widget/app_bar.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HolidayScreen extends StatefulWidget {
  const HolidayScreen({super.key});

  @override
  State<HolidayScreen> createState() => _HolidayScreenState();
}

class _HolidayScreenState extends State<HolidayScreen> {
  late HolidayEventBloc holidayBloc;
  int month = DateTime.now().month;

  @override
  void initState() {
    holidayBloc = HolidayEventBloc(context.read<HolidayEventRepository>());
    super.initState();
    holidayBloc.holidayList(
        '${DateTime.now().month}', '${DateTime.now().year}');
    // holidayBloc.eventsList('${DateTime.now().month}', '${DateTime.now().year}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: const MyAppBar(title: 'Holiday'),
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
                  "Holiday",
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
                    builder: (context) => const AllHoliday()));
              },
              child: const CircleAvatar(
                backgroundColor: Colors.white,
                radius: 15,
                child: Icon(
                  Icons.arrow_downward,
                  size: 18,
                ),
              ),
            ),
          ),
          Column(
            children: [
              const SizedBox(height: 100,),
              Expanded(
                child: Column(
                  children: [
                    ValueListenableBuilder(
                      valueListenable: holidayBloc.calendar,
                      builder: (context, calendarFormatValue, child) {
                        return ValueListenableBuilder(
                          valueListenable: holidayBloc.holidayData,
                          builder: (BuildContext context, List<Holiday> value, Widget? child) {
                            Map<DateTime, List<dynamic>> eventsList = {};
                            final events = LinkedHashMap(
                              equals: isSameDay,
                              // hashCode: getHashCode,
                            )..addAll(eventsList);
                            List _getEventsForDay(DateTime day) {
                              return events[day] ?? [];
                            }

                           return TableCalendar(
                              eventLoader: (day) {
                              return _getEventsForDay(day);
                              },
                              firstDay: DateTime.utc(DateTime.now().year, 01, 01),
                              lastDay: DateTime.utc(DateTime.now().year, 12, 31),
                              focusedDay: holidayBloc.focusDay,
                              currentDay: DateTime.now(),
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
                                  holidayBloc.holidayList("${holidayBloc.focusDay.month}",
                                      "${holidayBloc.focusDay.year}");
                                  // holidayBloc.eventsList("${holidayBloc.focusDay.month}",
                                  //     "${holidayBloc.focusDay.year}");
                                }
                              },
                              onFormatChanged: (format) {
                                if (value != format) {
                                  holidayBloc.calendar.value = format;
                                }
                              },
                              availableCalendarFormats: const {
                                CalendarFormat.month: 'Month',
                                CalendarFormat.week: 'Weeks'
                              },
                            );
                          },
                        );
                      },
                    ),
                    SizedBox(height: 20,),
                    // Expanded(
                    //   child: DefaultTabController(
                    //     length: 2,
                    //     initialIndex: 0,
                    //     child: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         const Material(
                    //           color: Colors.white,
                    //           child: SizedBox(
                    //             child: TabBar(
                    //               indicatorColor: Color(0xFF0E83EA),
                    //               tabs: [
                    //                 Tab(
                    //                   child: Text('Holiday',
                    //                       style: TextStyle(
                    //                           fontSize: 16,
                    //                           fontWeight: FontWeight.bold,
                    //                           color: Color(0xFF001233),
                    //                           fontFamily: 'Poppins')),
                    //                 ),
                    //                 Tab(
                    //                   child: Text('Event',
                    //                       style: TextStyle(
                    //                           fontSize: 16,
                    //                           fontWeight: FontWeight.bold,
                    //                           color: Color(0xFF001233),
                    //                           fontFamily: 'Poppins')),
                    //                 )
                    //               ],
                    //             ),
                    //           ),
                    //         ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.only(bottom: 20),
                                color: Colors.grey.shade100.withOpacity(0.5),
                                // child: TabBarView(
                                //   children: [
                                    child: ValueListenableBuilder(
                                      valueListenable: holidayBloc.isHolidayLoading,
                                      builder: (BuildContext context, bool isLoading,
                                          Widget? child) {
                                        return ValueListenableBuilder(
                                          valueListenable: holidayBloc.holidayData,
                                          builder: (BuildContext context,
                                              List<Holiday> holiday, Widget? child) {
                                            if (isLoading) {
                                              return const Center(
                                                child: CircularProgressIndicator(),
                                              );
                                            }
                                            if(holiday.isEmpty){
                                              return const Center(
                                                child: Text(
                                                  "No holiday this month.",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              );
                                            }
                                            return ListView.builder(
                                              physics: const ScrollPhysics(),
                                              itemCount: holiday.length,
                                              itemBuilder: (_, index) {
                                                return HolidayList(
                                                    index: index, data: holiday);
                                              },
                                            );
                                          },
                                        );
                                      },
                                    ),
    //                       ValueListenableBuilder(
    //                         valueListenable: holidayBloc.isEventLoading,
    //                         builder: (BuildContext context, bool isLoading,
    //                             Widget? child) {
    //                           return ValueListenableBuilder(
    //                             valueListenable: holidayBloc.eventsData,
    //                             builder: (BuildContext context,
    //                                 List<Events> event, Widget? child) {
    //                               if (isLoading) {
    //                                 return const Center(
    //                                   child: CircularProgressIndicator(),
    //                                 );
    //                               }
    //                               if(event.isEmpty){
    //                                 return Center(
    //                                   child: Text(
    //                                     "No events this month.",
    //                                     style: TextStyle(
    //                                       fontWeight: FontWeight.w600,
    //                                       fontSize: 18,
    //                                     ),
    //                                   ),
    //                                 );
    //                               }
    //                               return ListView.builder(
    //                                 physics: const ScrollPhysics(),
    //                                 itemCount: event.length,
    //                                 itemBuilder: (_, index) {
    //                                   return EventsList(
    //                                       index: index, data: event);
    //                                 },
    //                               );
    //                             },
    //                           );
    //                         },
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //               ),
    //             ],
                        // ),
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

class HolidayList extends StatelessWidget {
  final int index;
  final List<Holiday> data;
  const HolidayList({required this.index, required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
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
            children: [
              Column(
                children: [
                  Text(
                    DateFormat.E().format(
                            DateTime.parse("${data[index].holidayDate}")),
                    style: const TextStyle(
                      fontSize: 11,
                      fontFamily: 'Poppins',
                      color: Colors.blue,
                    ),
                  ),
                  Text(
                    DateTime.parse("${data[index].holidayDate}")
                            .day
                            .toString() ??
                        "",
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30, child: VerticalDivider()),
              const SizedBox(
                width: 10,
              ),
              Text(
                data[index].reason ?? "",
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          )),
    );
  }
}
