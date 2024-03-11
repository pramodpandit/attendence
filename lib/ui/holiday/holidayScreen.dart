import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:office/bloc/holiday_bloc.dart';
import 'package:office/data/model/holiday_model.dart';
import 'package:office/data/repository/holiday_repo.dart';
import 'package:office/ui/holiday/allHolidayScreen.dart';
import 'package:office/ui/widget/app_bar.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../utils/image_icons.dart';

class HolidayScreen extends StatefulWidget {
  const HolidayScreen({super.key});
  @override
  State<HolidayScreen> createState() => _HolidayScreenState();
}

class _HolidayScreenState extends State<HolidayScreen> {
  late HolidayEventBloc holidayBloc;
  int month = DateTime.now().month;
  var check;
  var condition;

  @override
  void initState() {
    holidayBloc = HolidayEventBloc(context.read<HolidayEventRepository>());
    super.initState();
    holidayBloc.holidayList(
        );
    // holidayBloc.eventsList('${DateTime.now().month}', '${DateTime.now().year}');
  }
  int? selectedYear;
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
          // Positioned(
          //   top: 56,
          //   right: 10,
          //   child: GestureDetector(
          //     onTap: () {
          //       Navigator.of(context).push(MaterialPageRoute(
          //           builder: (context) => const AllHoliday()));
          //     },
          //     child: const CircleAvatar(
          //       backgroundColor: Colors.white,
          //       radius: 15,
          //       child: Icon(
          //         Icons.arrow_downward,
          //         size: 18,
          //       ),
          //     ),
          //   ),
          // ),
          Column(
            children: [
              const SizedBox(height: 120,),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //     InkWell(
              //       onTap: (){
              //         setState(() {
              //           condition = '2';
              //         });
              //       },
              //       child: Container(
              //           height: 40,
              //           width: 40,
              //           child: Image.asset('images/img.png',fit: BoxFit.cover,)),
              //     ),
              //     InkWell(
              //       onTap: (){
              //         setState(() {
              //           condition = '1';
              //         });
              //       },
              //       child: Container(
              //           height: 22,
              //           width: 22,
              //           child: Image.asset('images/img_1.png',height: 30,width: 30,)),
              //     ),
              //     SizedBox(width: 20,)
              //   ],
              // ),


              Expanded(
                child: Column(
                  children: [
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
                                valueListenable: holidayBloc.startYear,
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
                                        await holidayBloc.updateStartYear(selectedDate);
                                        await holidayBloc.holidayList();
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
                              valueListenable: holidayBloc.startmonth,
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
                                        holidayBloc.year.value?.year ??
                                            DateTime.now().year,
                                        selectedMonth,
                                      );
                                      await holidayBloc.updateStartMonth(selectedDate);
                                      await holidayBloc.holidayList();
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
                    ),
                    // condition =='1'?
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //   crossAxisAlignment: CrossAxisAlignment.end,
                    //   children: [
                    //     Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Padding(
                    //           padding: const EdgeInsets.only(left: 5),
                    //           child: Text(
                    //             "Select Year",
                    //             style: const TextStyle(
                    //               fontSize: 9,
                    //               fontWeight: FontWeight.w600,
                    //             ),
                    //           ),
                    //         ),
                    //         ValueListenableBuilder(
                    //             valueListenable: holidayBloc.startYear,
                    //             builder: (context, DateTime? date, _) {
                    //               return InkWell(
                    //                 // onTap: () async {
                    //                 //   DateTime? dt = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now().subtract(Duration(days: 15)), lastDate:  DateTime.now().add(Duration(days: 30)),);
                    //                 //   if(dt!=null) {
                    //                 //     await holidayBloc.updateStartYear(dt);
                    //                 //   }
                    //                 // },
                    //                 onTap: () async {
                    //                   int? selectedYear = await showDialog(
                    //                     context: context,
                    //                     builder: (BuildContext context) {
                    //                       return AlertDialog(
                    //                         title:
                    //                         const Text("Select Year"),
                    //                         content: DropdownButton<int>(
                    //                           value: date?.year ??
                    //                               DateTime.now().year,
                    //                           items: List.generate(30,
                    //                                   (index) {
                    //                                 return DropdownMenuItem<
                    //                                     int>(
                    //                                   value:
                    //                                   DateTime.now().year -
                    //                                       15 +
                    //                                       index,
                    //                                   child: Text(
                    //                                       (DateTime.now().year -
                    //                                           15 +
                    //                                           index)
                    //                                           .toString()),
                    //                                 );
                    //                               }),
                    //                           onChanged: (int? value) {
                    //                             Navigator.pop(
                    //                                 context, value);
                    //                           },
                    //                         ),
                    //                         actions: [
                    //                           TextButton(
                    //                             onPressed: () {
                    //                               Navigator.pop(context);
                    //                             },
                    //                             child: Text('Cancel'),
                    //                           ),
                    //                           TextButton(
                    //                             onPressed: () {
                    //                               Navigator.pop(
                    //                                   context,
                    //                                   date?.year ??
                    //                                       DateTime.now()
                    //                                           .year);
                    //                             },
                    //                             child: Text('Select'),
                    //                           ),
                    //                         ],
                    //                       );
                    //                     },
                    //                   );
                    //
                    //                   if (selectedYear != null) {
                    //                     DateTime selectedDate =
                    //                     DateTime(selectedYear);
                    //                     await holidayBloc.updateStartYear(selectedDate);
                    //                     await holidayBloc.holidayList();
                    //                     print("$selectedDate");
                    //                   }
                    //                 },
                    //
                    //                 child: Container(
                    //                   height: 50,
                    //                   padding: const EdgeInsets.symmetric(
                    //                       horizontal: 20),
                    //                   decoration: BoxDecoration(
                    //                     color: Colors.grey[200],
                    //                     borderRadius:
                    //                     BorderRadius.circular(5),
                    //                   ),
                    //                   child: Row(
                    //                     children: [
                    //                       const Icon(PhosphorIcons.clock),
                    //                       const SizedBox(width: 15),
                    //                       Text(
                    //                         date == null
                    //                             ? DateFormat('yyyy')
                    //                             .format(DateTime.now())
                    //                             : DateFormat('yyyy')
                    //                             .format(date),
                    //                         style: const TextStyle(
                    //                           fontSize: 15,
                    //                           fontWeight: FontWeight.w500,
                    //                         ),
                    //                       ),
                    //                     ],
                    //                   ),
                    //                 ),
                    //               );
                    //             }),
                    //       ],
                    //     ),
                    //     Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Padding(
                    //           padding: const EdgeInsets.only(left: 5),
                    //           child: Text(
                    //             "Select Month",
                    //             style: const TextStyle(
                    //               fontSize: 9,
                    //               fontWeight: FontWeight.w600,
                    //             ),
                    //           ),
                    //         ),
                    //         ValueListenableBuilder(
                    //           valueListenable: holidayBloc.startmonth,
                    //           builder: (context, DateTime? monthDate, _) {
                    //             return InkWell(
                    //               onTap: () async {
                    //                 int? selectedMonth = await showDialog(
                    //                   context: context,
                    //                   builder: (BuildContext context) {
                    //                     return AlertDialog(
                    //                       title: const Text("Select Month"),
                    //                       content: DropdownButton<int>(
                    //                         value: monthDate?.month ??
                    //                             DateTime.now().month,
                    //                         items:
                    //                         List.generate(12, (index) {
                    //                           return DropdownMenuItem<int>(
                    //                             value: index + 1,
                    //                             child: Text(
                    //                               DateFormat('MMMM').format(
                    //                                   DateTime(
                    //                                       DateTime.now()
                    //                                           .year,
                    //                                       index + 1,
                    //                                       1)),
                    //                             ),
                    //                           );
                    //                         }),
                    //                         onChanged: (int? value) {
                    //                           Navigator.pop(context, value);
                    //                         },
                    //                       ),
                    //                       actions: [
                    //                         TextButton(
                    //                           onPressed: () {
                    //                             Navigator.pop(context);
                    //                           },
                    //                           child: Text('Cancel'),
                    //                         ),
                    //                         TextButton(
                    //                           onPressed: () {
                    //                             Navigator.pop(
                    //                                 context,
                    //                                 monthDate?.month ??
                    //                                     DateTime.now()
                    //                                         .month);
                    //                           },
                    //                           child: Text('Select'),
                    //                         ),
                    //                       ],
                    //                     );
                    //                   },
                    //                 );
                    //
                    //                 if (selectedMonth != null) {
                    //                   DateTime selectedDate = DateTime(
                    //                     holidayBloc.year.value?.year ??
                    //                         DateTime.now().year,
                    //                     selectedMonth,
                    //                   );
                    //                   await holidayBloc.updateStartMonth(selectedDate);
                    //                   await holidayBloc.holidayList();
                    //                   print("$selectedDate");
                    //                 }
                    //               },
                    //               child: Container(
                    //                 height: 50,
                    //                 padding: const EdgeInsets.symmetric(
                    //                     horizontal: 20),
                    //                 decoration: BoxDecoration(
                    //                   color: Colors.grey[200],
                    //                   borderRadius:
                    //                   BorderRadius.circular(5),
                    //                 ),
                    //                 child: Row(
                    //                   children: [
                    //                     const Icon(PhosphorIcons.calendar),
                    //                     const SizedBox(width: 15),
                    //                     Text(
                    //                       monthDate == null
                    //                           ? DateFormat('MMMM').format(
                    //                           DateTime(
                    //                               DateTime.now().year,
                    //                               DateTime.now().month,
                    //                               1))
                    //                           : DateFormat('MMMM').format(
                    //                           DateTime(
                    //                               DateTime.now().year,
                    //                               monthDate.month,
                    //                               1)),
                    //                       style: const TextStyle(
                    //                         fontSize: 15,
                    //                         fontWeight: FontWeight.w500,
                    //                       ),
                    //                     ),
                    //                   ],
                    //                 ),
                    //               ),
                    //             );
                    //           },
                    //         ),
                    //       ],
                    //     ),
                    //   ],
                    // )
                    // // Padding(
                    // //   padding: const EdgeInsets.all(8.0),
                    // //   child: Row(
                    // //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    // //     children: [
                    // //       ValueListenableBuilder(
                    // //           valueListenable: holidayBloc.startYear,
                    // //           builder: (context, DateTime? date, _) {
                    // //             return InkWell(
                    // //               // onTap: () async {
                    // //               //   DateTime? dt = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now().subtract(Duration(days: 15)), lastDate:  DateTime.now().add(Duration(days: 30)),);
                    // //               //   if(dt!=null) {
                    // //               //     await holidayBloc.updateStartYear(dt);
                    // //               //   }
                    // //               // },
                    // //               onTap: () async {
                    // //                  selectedYear = await showDialog(
                    // //                   context: context,
                    // //                   builder: (BuildContext context) {
                    // //                     return AlertDialog(
                    // //                       title: const Text("Select Year"),
                    // //                       content: DropdownButton<int>(
                    // //                         value: date?.year ?? DateTime.now().year,
                    // //                         items: List.generate(30, (index) {
                    // //                           return DropdownMenuItem<int>(
                    // //                             value: DateTime.now().year - 0 + index,
                    // //                             child: Text((DateTime.now().year - 0 + index).toString()),
                    // //                           );
                    // //                         }),
                    // //                         onChanged: (int? value) {
                    // //                           Navigator.pop(context, value);
                    // //                         },
                    // //                       ),
                    // //                       actions: [
                    // //                         TextButton(
                    // //                           onPressed: () {
                    // //                             Navigator.pop(context);
                    // //                           },
                    // //                           child: Text('Cancel'),
                    // //                         ),
                    // //                         TextButton(
                    // //                           onPressed: () {
                    // //                             Navigator.pop(context, date?.year ?? DateTime.now().year);
                    // //                           },
                    // //                           child: Text('Select'),
                    // //                         ),
                    // //                       ],
                    // //                     );
                    // //                   },
                    // //                 );
                    // //
                    // //                 if (selectedYear != null) {
                    // //                   DateTime selectedDate = DateTime(selectedYear!);
                    // //                   await holidayBloc.updateStartYear(selectedDate);
                    // //                   print("$selectedDate");
                    // //                 }
                    // //               },
                    // //
                    // //               child: Container(
                    // //                 height: 50,
                    // //                 padding: const EdgeInsets.symmetric(horizontal: 20),
                    // //                 decoration: BoxDecoration(
                    // //                   color: Colors.grey[100],
                    // //                   borderRadius: BorderRadius.circular(5),
                    // //                 ),
                    // //                 child: Row(
                    // //                   children: [
                    // //                     const Icon(PhosphorIcons.clock),
                    // //                     const SizedBox(width: 15),
                    // //                     Text(date==null ?  DateFormat('yyyy').format(DateTime.now()) : DateFormat('yyyy').format(date), style: const TextStyle(
                    // //                       fontSize: 15,
                    // //                       fontWeight: FontWeight.w500,
                    // //                     ),),
                    // //                   ],
                    // //                 ),
                    // //               ),
                    // //             );
                    // //           }
                    // //       ),
                    // //       SizedBox(
                    // //         width: MediaQuery.of(context).size.width*0.4,
                    // //         child: DropdownButtonFormField<String>(
                    // //           icon: const Icon(
                    // //             Icons.keyboard_arrow_down_sharp,
                    // //             color: Colors.grey,
                    // //           ),
                    // //           iconSize: 24,
                    // //           elevation: 16,
                    // //           style: const TextStyle(color: Colors.black, fontSize: 15),
                    // //           decoration: InputDecoration(
                    // //             filled: true,
                    // //             fillColor: Colors.grey[200],
                    // //             enabledBorder: OutlineInputBorder(
                    // //               borderSide: const BorderSide(color: Color(0xffF4F5F7)),
                    // //               borderRadius: BorderRadius.circular(8),
                    // //             ),
                    // //             focusedBorder: OutlineInputBorder(
                    // //               borderSide: const BorderSide(color: Color(0xffF2F2F2)),
                    // //               borderRadius: BorderRadius.circular(8),
                    // //             ),
                    // //             contentPadding: const EdgeInsets.symmetric(
                    // //                 vertical: 12, horizontal: 10),
                    // //             hintText: "${DateFormat.MMMM().format(DateTime.now())}",
                    // //             hintStyle: TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 15,fontWeight: FontWeight.w500),
                    // //           ),
                    // //           onChanged: (String? data) {
                    // //             var year = selectedYear==null?DateTime.now().year:selectedYear;
                    // //
                    // //             holidayBloc.holidayList(data!, year.toString());
                    // //             setState(() {
                    // //               check = data;
                    // //             });
                    // //           },
                    // //           items: holidayBloc.months.map<DropdownMenuItem<String>>((value) {
                    // //             return DropdownMenuItem<String>(
                    // //               value: value['value'].toString(),
                    // //               child: Text(value['month'].toString(),style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w500),),
                    // //             );
                    // //           }).toList(),
                    // //         ),
                    // //       ),
                    // //
                    // //     ],
                    // //   ),
                    // // )
                    //
                    //     :condition == '2'?
                    // ValueListenableBuilder(
                    //   valueListenable: holidayBloc.calendar,
                    //   builder: (context, calendarFormatValue, child) {
                    //     return ValueListenableBuilder(
                    //       valueListenable: holidayBloc.holidayData,
                    //       builder: (BuildContext context, List<Holiday> value, Widget? child) {
                    //         Map<DateTime, List<dynamic>> eventsList = {};
                    //         final events = LinkedHashMap(
                    //           equals: isSameDay,
                    //           // hashCode: getHashCode,
                    //         )..addAll(eventsList);
                    //         List _getEventsForDay(DateTime day) {
                    //           return events[day] ?? [];
                    //         }
                    //         return TableCalendar(
                    //           eventLoader: (day) {
                    //           return _getEventsForDay(day);
                    //           },
                    //           firstDay: DateTime.utc(DateTime.now().year, 01, 01),
                    //           lastDay: DateTime.utc(DateTime.now().year, 12, 31),
                    //           focusedDay: holidayBloc.focusDay,
                    //           currentDay:   DateTime.now(),
                    //           headerStyle: const HeaderStyle(
                    //             formatButtonVisible: false,
                    //           ),
                    //           calendarStyle: const CalendarStyle(
                    //             weekendTextStyle: TextStyle(color: Colors.red),
                    //           ),
                    //           daysOfWeekStyle: const DaysOfWeekStyle(
                    //             weekendStyle: TextStyle(color: Colors.red),
                    //           ),
                    //           startingDayOfWeek: StartingDayOfWeek.monday,
                    //           calendarFormat: calendarFormatValue,
                    //           onPageChanged: (focusedDay) {
                    //             if(focusedDay.month != month){
                    //               print(holidayBloc.focusDay);
                    //               month = focusedDay.month;
                    //               holidayBloc.focusDay = focusedDay;
                    //               holidayBloc.holidayList();
                    //               // holidayBloc.eventsList("${holidayBloc.focusDay.month}",
                    //               //     "${holidayBloc.focusDay.year}");
                    //             }
                    //           },
                    //           onFormatChanged: (format) {
                    //             if (value != format) {
                    //               holidayBloc.calendar.value = format;
                    //             }
                    //           },
                    //           availableCalendarFormats: const {
                    //             CalendarFormat.month: 'Month',
                    //             CalendarFormat.week: 'Weeks'
                    //           },
                    //         );
                    //       },
                    //     );
                    //   },
                    // ):
                    // ValueListenableBuilder(
                    //   valueListenable: holidayBloc.calendar,
                    //   builder: (context, calendarFormatValue, child) {
                    //     return ValueListenableBuilder(
                    //       valueListenable: holidayBloc.holidayData,
                    //       builder: (BuildContext context, List<Holiday> value, Widget? child) {
                    //         Map<DateTime, List<dynamic>> eventsList = {};
                    //         final events = LinkedHashMap(
                    //           equals: isSameDay,
                    //           // hashCode: getHashCode,
                    //         )..addAll(eventsList);
                    //         List _getEventsForDay(DateTime day) {
                    //           return events[day] ?? [];
                    //         }
                    //         return TableCalendar(
                    //           eventLoader: (day) {
                    //             return _getEventsForDay(day);
                    //           },
                    //           firstDay: DateTime.utc(DateTime.now().year, 01, 01),
                    //           lastDay: DateTime.utc(DateTime.now().year, 12, 31),
                    //           focusedDay: holidayBloc.focusDay,
                    //           currentDay:   DateTime.now(),
                    //           headerStyle: const HeaderStyle(
                    //             formatButtonVisible: false,
                    //           ),
                    //           calendarStyle: const CalendarStyle(
                    //             weekendTextStyle: TextStyle(color: Colors.red),
                    //           ),
                    //           daysOfWeekStyle: const DaysOfWeekStyle(
                    //             weekendStyle: TextStyle(color: Colors.red),
                    //           ),
                    //           startingDayOfWeek: StartingDayOfWeek.monday,
                    //           calendarFormat: calendarFormatValue,
                    //           onPageChanged: (focusedDay) {
                    //             if(focusedDay.month != month){
                    //               print(holidayBloc.focusDay);
                    //               month = focusedDay.month;
                    //               holidayBloc.focusDay = focusedDay;
                    //               holidayBloc.holidayList();
                    //               // holidayBloc.eventsList("${holidayBloc.focusDay.month}",
                    //               //     "${holidayBloc.focusDay.year}");
                    //             }
                    //           },
                    //           onFormatChanged: (format) {
                    //             if (value != format) {
                    //               holidayBloc.calendar.value = format;
                    //             }
                    //           },
                    //           availableCalendarFormats: const {
                    //             CalendarFormat.month: 'Month',
                    //             CalendarFormat.week: 'Weeks'
                    //           },
                    //         );
                    //       },
                    //     );
                    //   },
                    // ),
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
