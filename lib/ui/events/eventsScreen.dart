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
import 'package:office/utils/message_handler.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:url_launcher/url_launcher.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  late HolidayEventBloc holidayBloc;
  int month = DateTime.now().month;
  var condition;
  int? selectedYear;

  @override
  void initState() {
    holidayBloc = HolidayEventBloc(context.read<HolidayEventRepository>());
    super.initState();
    holidayBloc.eventsList();
    holidayBloc.msgController?.stream.listen((event) {
      AppMessageHandler().showSnackBar(context, event);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: const MyAppBar(title: 'Events'),
      // backgroundColor: Colors.blueAccent,
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
                  "Events",
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
          //           builder: (context) => const AllEventScreen()));
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
                    // condition=='1'?
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
                            valueListenable: holidayBloc.year,
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
                                    await holidayBloc.updateYear(selectedDate);
                                    await holidayBloc.eventsList();
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
                          valueListenable: holidayBloc.month,
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
                                  await holidayBloc.updateMonth(selectedDate);
                                  await holidayBloc.eventsList();
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
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //     children: [
                    //       ValueListenableBuilder(
                    //           valueListenable: holidayBloc.startEventYear,
                    //           builder: (context, DateTime? date, _) {
                    //             return InkWell(
                    //               onTap: () async {
                    //                 selectedYear = await showDialog(
                    //                   context: context,
                    //                   builder: (BuildContext context) {
                    //                     return AlertDialog(
                    //                       title: const Text("Select Year"),
                    //                       content: DropdownButton<int>(
                    //                         value: date?.year ?? DateTime.now().year,
                    //                         items: List.generate(30, (index) {
                    //                           return DropdownMenuItem<int>(
                    //                             value: DateTime.now().year - 15 + index,
                    //                             child: Text((DateTime.now().year - 15 + index).toString()),
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
                    //                             Navigator.pop(context, date?.year ?? DateTime.now().year);
                    //                           },
                    //                           child: Text('Select'),
                    //                         ),
                    //                       ],
                    //                     );
                    //                   },
                    //                 );
                    //
                    //                 if (selectedYear != null) {
                    //                   DateTime selectedDate = DateTime(selectedYear!);
                    //                   await holidayBloc.updateStartEventYear(selectedDate);
                    //                   print("$selectedDate");
                    //                 }
                    //               },
                    //
                    //               child: Container(
                    //                 height: 50,
                    //                 padding: const EdgeInsets.symmetric(horizontal: 20),
                    //                 decoration: BoxDecoration(
                    //                   color: Colors.grey[100],
                    //                   borderRadius: BorderRadius.circular(5),
                    //                 ),
                    //                 child: Row(
                    //                   children: [
                    //                     const Icon(PhosphorIcons.clock),
                    //                     const SizedBox(width: 15),
                    //                     Text(date==null ?  DateFormat('yyyy').format(DateTime.now()) : DateFormat('yyyy').format(date), style: const TextStyle(
                    //                       fontSize: 15,
                    //                       fontWeight: FontWeight.w500,
                    //                     ),),
                    //                   ],
                    //                 ),
                    //               ),
                    //             );
                    //           }
                    //       ),
                    //       SizedBox(
                    //         width: MediaQuery.of(context).size.width * 0.4,
                    //         child: DropdownButtonFormField<String>(
                    //           icon: const Icon(
                    //             Icons.keyboard_arrow_down_sharp,
                    //             color: Colors.grey,
                    //           ),
                    //           iconSize: 24,
                    //           elevation: 16,
                    //           style: const TextStyle(color: Colors.black, fontSize: 15),
                    //           decoration: InputDecoration(
                    //             filled: true,
                    //             fillColor: Colors.grey[200],
                    //             enabledBorder: OutlineInputBorder(
                    //               borderSide: const BorderSide(color: Color(0xffF4F5F7)),
                    //               borderRadius: BorderRadius.circular(8),
                    //             ),
                    //             focusedBorder: OutlineInputBorder(
                    //               borderSide: const BorderSide(color: Color(0xffF2F2F2)),
                    //               borderRadius: BorderRadius.circular(8),
                    //             ),
                    //             contentPadding: const EdgeInsets.symmetric(
                    //                 vertical: 12, horizontal: 10),
                    //             hintText: "${DateFormat.MMMM().format(DateTime.now())}",
                    //             hintStyle: TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 15,fontWeight: FontWeight.w500),
                    //           ),
                    //           onChanged: (String? data) {
                    //             var year = selectedYear == null?DateTime.now().year:selectedYear;
                    //             holidayBloc.eventsList(data!, year.toString());
                    //           },
                    //           items: holidayBloc.months.map<DropdownMenuItem<String>>((value) {
                    //             return DropdownMenuItem<String>(
                    //               value: value['value'].toString(),
                    //               child: Text(value['month'].toString(),style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w500),),
                    //             );
                    //           }).toList(),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // )

                    //     :condition =='2'?
                    // ValueListenableBuilder(
                    //   valueListenable: holidayBloc.calendar,
                    //   builder: (context, calendarFormatValue, child) {
                    //     return ValueListenableBuilder(
                    //       valueListenable: holidayBloc.holidayData,
                    //       builder:
                    //           (BuildContext context, List<Holiday> value, Widget? child) {
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
                    //           currentDay: DateTime.now(),
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
                    //             if (focusedDay.month != month) {
                    //               print(holidayBloc.focusDay);
                    //               month = focusedDay.month;
                    //               holidayBloc.focusDay = focusedDay;
                    //               holidayBloc.eventsList();
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
                    //       builder:
                    //           (BuildContext context, List<Holiday> value, Widget? child) {
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
                    //           currentDay: DateTime.now(),
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
                    //             if (focusedDay.month != month) {
                    //               print(holidayBloc.focusDay);
                    //               month = focusedDay.month;
                    //               holidayBloc.focusDay = focusedDay;
                    //               holidayBloc.eventsList();
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
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: Container(
                        // padding: const EdgeInsets.only(bottom: 20),
                        color: Colors.grey.shade100.withOpacity(0.5),
                        // child: TabBarView(
                        //   children: [
                        child: ValueListenableBuilder(
                          valueListenable: holidayBloc.isEventLoading,
                          builder: (BuildContext context, bool isLoading, Widget? child) {
                            return ValueListenableBuilder(
                              valueListenable: holidayBloc.eventsData,
                              builder: (BuildContext context, List<Events> event,
                                  Widget? child) {
                                if (isLoading) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                if (event.isEmpty) {
                                  return Center(
                                    child: Text(
                                      "No events this month.",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                      ),
                                    ),
                                  );
                                }
                                return ListView.builder(
                                  physics: const ScrollPhysics(),
                                  itemCount: event.length,
                                  itemBuilder: (_, index) {
                                    return EventsList(index: index, data: event,bloc: holidayBloc,);
                                  },
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

class EventsList extends StatelessWidget {
  final HolidayEventBloc bloc;
  final int index;
  final List<Events> data;
  const EventsList({required this.index, required this.data, super.key, required this.bloc});

  @override
  Widget build(BuildContext context) {
    String? forEmp = data[index].forEmployee;
    bool isEqual = false;
    DateTime startDate =
        DateTime.parse("${data[index].startDate} ${data[index].startTime}");
    DateTime endDate = DateTime.parse("${data[index].endDate}");

    if (DateFormat.yMd().format(startDate) ==
        DateFormat.yMd().format(endDate)) {
      isEqual = true;
    }

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    )),
                child: Image.network(
                  "https://freeze.talocare.co.in/public/${data[index].file}" ?? "",
                  fit: BoxFit.fill,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "${data[index].name}",
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Html(
                  data: '${data[index].description}',
                  style: {
                    "body": Style(
                      color: Colors.black87,
                      // fontWeight: FontWeight.w500,
                      fontFamily: "Poppins",
                      display: Display.inline,
                      // fontSize: FontSize(13),
                    ),
                    "p": Style(
                      color: Colors.black87,
                      padding: HtmlPaddings.zero,
                      margin: Margins.zero,
                      // fontWeight: FontWeight.w500,
                      fontFamily: "Poppins",
                      display: Display.inline,
                      // fontSize: FontSize(13),
                    ),
                  },
                ),
              ),
              // EventContent(
              //   icon: PhosphorIcons.users,
              //   tittle: forEmp == 'all'
              //       ? 'For Everyone'
              //       : forEmp == 'department'
              //           ? "For Department"
              //           : forEmp == 'employee'
              //               ? 'For Particular Employee'
              //               : '', isHtml: false,
              // ),
              // const SizedBox(
              //   height: 10,
              // ),
              const SizedBox(
                height: 5,
              ),
              EventContent(
                icon: PhosphorIcons.link,
                tittle: "${data[index].link}",
                color: Colors.blue,
                isHtml: false,
                /*onTap: () async {
                  if (await canLaunchUrlString("${data[index].link}")) {
                    await launchUrlString("${data[index].link}");
                  }
                },*/
                onTap: () async {
                  final Uri url = Uri.parse(
                      '${data[index].link}');
                  try {
                    await launchUrl(url);
                  } catch (e) {
                    bloc.showMessage(MessageType.error('${data[index].link} does not exist'));

                    // ScaffoldMessenger.of(context)
                    //     .showSnackBar(SnackBar(
                    //     content: Text(
                    //         '${data[index].link} does not exist')));
                  }
                },
              ),
              EventContent(
                icon: PhosphorIcons.map_pin,
                tittle: "${data[index].location}",
                isHtml: true,
                color: Colors.blue,
                onTap: () async {
                  final Uri url = Uri.parse(
                      '${data[index].location}');
                  try {
                    await launchUrl(url);
                  } catch (e) {
                    bloc.showMessage(MessageType.error('This url does not exist'));
                    // ScaffoldMessenger.of(context)
                    //     .showSnackBar(SnackBar(
                    //     content: Text(
                    //         '${data[index].location} does not exist')));
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: [
                    const Icon(
                      PhosphorIcons.calendar,
                      size: 22,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      "${DateFormat.d().add_MMM().format(startDate)}, ${DateFormat.jm().format(startDate)}",
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    if (isEqual != true)
                      const Icon(
                        PhosphorIcons.calendar,
                        size: 22,
                      ),
                    const SizedBox(
                      width: 5,
                    ),
                    if (isEqual != true)
                      Text(
                        DateFormat.d().add_MMM().add_y().format(endDate),
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}

class EventContent extends StatelessWidget {
  const EventContent(
      {super.key,
      required this.icon,
      required this.tittle,
      required this.isHtml,
      this.onTap,
      this.color});
  final IconData icon;
  final String tittle;
  final bool isHtml;
  final VoidCallback? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 22,
            ),
            const SizedBox(
              width: 5,
            ),
            if (isHtml)
              Expanded(
                child:/* Html(
                  data: tittle,
                  style: {
                    "body": Style(
                      // padding: EdgeInsets.zero,
                      margin: Margins.zero,
                    ),
                  },
                ),*/
                Html(
                  data: tittle,
                  // data: "${noticeBoards[index].description}",
                  style: {
                    "body": Style(
                      color: color ?? Colors.black,
                      // fontWeight: FontWeight.w500,
                      fontFamily: "Poppins",
                      display: Display.inline,
                      // fontSize: FontSize(13),
                    ),
                    "p": Style(
                      color: color ?? Colors.black,
                      padding: HtmlPaddings.zero,
                      margin: Margins.zero,
                      // fontWeight: FontWeight.w500,
                      fontFamily: "Poppins",
                      display: Display.inline,
                      // fontSize: FontSize(13),
                    ),
                  },
                ),
              )
            else
              Expanded(
                child: Text(
                  tittle,
                  maxLines: 2,
                  overflow:TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: color ?? Colors.black,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
