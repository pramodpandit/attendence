import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:office/ui/expense/add_expense.dart';
import 'package:office/ui/expense/expense_details.dart';
import 'package:office/utils/constants.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:office/ui/widget/app_bar.dart';

import '../holiday/allHolidayScreen.dart';

class ExpenseList extends StatefulWidget {
  const ExpenseList({Key? key}) : super(key: key);

  @override
  State<ExpenseList> createState() => _ExpenseListState();
}

class _ExpenseListState extends State<ExpenseList> {
  ValueNotifier<CalendarFormat> calendar = ValueNotifier(CalendarFormat.week);
  int month = DateTime.now().month;
  @override
  Widget build(BuildContext context) {
    return  RefreshIndicator(
      displacement: 200,
      backgroundColor: Colors.white,
      color: K.themeColorPrimary,
      strokeWidth: 3,
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      onRefresh: () async {
        await Future.delayed(const Duration(milliseconds: 1500));
      },
      child: Scaffold(
        // appBar: const MyAppBar(title: 'Expense'),
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
                    "Expense",
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
                  // Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (context) => const AllExpenses()));
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     /* const SizedBox(height: 70,),
                       const Padding(
                         padding: EdgeInsets.symmetric(horizontal: 15),
                         child: Text(
                           "Expense",
                           style: TextStyle(
                               fontWeight: FontWeight.w600,
                               fontSize: 20,
                               letterSpacing: 0.5,
                               color: Colors.black),
                         ),
                       ),*/
                       Padding(
                         padding: const EdgeInsets.symmetric(horizontal: 15),
                         child: ValueListenableBuilder(
                           valueListenable: calendar,
                           builder: (context, calendarFormatValue,__) {
                             return TableCalendar(
                               // eventLoader: (day) {
                               //   return _getEventsForDay(day);
                               // },
                               firstDay: DateTime.utc(DateTime.now().year, 01, 01),
                               lastDay: DateTime.utc(DateTime.now().year, 12, 31),
                               // focusedDay: holidayBloc.focusDay,
                               currentDay: DateTime.now(),
                               headerStyle: const HeaderStyle(
                                   formatButtonVisible: false,
                                   titleCentered: true,
                                 // rightChevronPadding: EdgeInsets.zero,
                                 // leftChevronPadding: EdgeInsets.zero
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
                                 // if(focusedDay.month != month){
                                 //   // print(holidayBloc.focusDay);
                                 //   month = focusedDay.month;
                                 //   holidayBloc.focusDay = focusedDay;
                                 //   holidayBloc.eventsList("${holidayBloc.focusDay.month}",
                                 //       "${holidayBloc.focusDay.year}");
                                 // }
                               },
                               onFormatChanged: (format) {
                                 calendar.value = format;
                               },
                               availableCalendarFormats: const {
                                 CalendarFormat.month: 'Month',
                                 CalendarFormat.week: 'Weeks'
                               }, focusedDay: DateTime.now(),
                             );
                           }
                         ),
                       ),
                       Expanded(
                         child: ListView.builder(
                           itemCount: 8,
                             padding: const EdgeInsets.only(top: 10),
                             shrinkWrap: true,
                             physics: const ScrollPhysics(),
                             itemBuilder: (context,index){
                               return GestureDetector(
                                 onTap: () {
                                   Navigator.of(context).push(MaterialPageRoute(
                                       builder: (context) => const ExpenseDetails()));
                                 },
                                 child: Padding(
                                   padding: const EdgeInsets.symmetric(horizontal: 15),
                                   child: Container(
                                     padding: const EdgeInsets.symmetric(horizontal: 10),
                                     margin: const EdgeInsets.only(bottom: 20),
                                     decoration: BoxDecoration(
                                       boxShadow: [
                                         BoxShadow(
                                             color: Colors.grey.withOpacity(0.2),
                                             blurRadius: 3,
                                             spreadRadius: 2)
                                       ],
                                       color: Colors.white,
                                       borderRadius: const BorderRadius.all(Radius.circular(10)),
                                     ),
                                     child:  Column(
                                       children: [
                                         Row(
                                           children: [
                                             const Expanded(child: Row()),
                                             Container(
                                               padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                                               decoration:  BoxDecoration(
                                                 color:index==1?Color(0xFFD41817):Color(0xFF3CEB43),
                                                 borderRadius: const BorderRadius.all(Radius.circular(5)),
                                               ),
                                               child: Text(
                                                 index==1?"Rejected":"Approved",
                                                 textAlign: TextAlign.center,
                                                 style: const TextStyle(
                                                   fontSize: 11,
                                                   color: Colors.white,
                                                 ),
                                               ),
                                             ),
                                           ],
                                         ),
                                         const SizedBox(height: 10,),
                                         const Row(
                                           mainAxisAlignment: MainAxisAlignment.start,
                                           crossAxisAlignment: CrossAxisAlignment.start,
                                           children: [
                                             Expanded(
                                               child: Text(
                                                 "Mobile App Design",
                                                 textAlign: TextAlign.left,
                                                 style: TextStyle(
                                                   fontWeight: FontWeight.w700,
                                                 ),
                                               ),
                                             ),
                                             Text(
                                               "₹15000",
                                               textAlign: TextAlign.left,
                                               style: TextStyle(
                                                 fontWeight: FontWeight.w700,
                                               ),
                                             ),
                                           ],
                                         ),
                                         const SizedBox(height: 10,),
                                         const Text(
                                           "Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipi.Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipi. Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipi.Neque porro quisquam.",
                                           textAlign: TextAlign.left,
                                           style: TextStyle(
                                             color: Colors.black54,
                                             fontWeight:
                                             FontWeight.w500,
                                             fontFamily: "Poppins",
                                             fontSize: 11
                                           ),
                                         ),
                                         const SizedBox(height: 20,),
                                       ],
                                     ),
                                   ),
                                 ),
                               );
                             }
                         ),
                       ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              height: 40,
              width: 100,
              child: FloatingActionButton.extended(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0))
                ),
                  onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const AddExpense()));
                  },
                  backgroundColor: const Color(0xFF009FE3),
                  label: AnimatedSwitcher(
                    duration: const Duration(seconds: 1),
                    transitionBuilder: (Widget child, Animation<double> animation) =>
                        FadeTransition(
                          opacity: animation,
                          child: SizeTransition(
                            sizeFactor: animation,
                            axis: Axis.horizontal,
                            child: child,
                          ),
                        ),
                    child: const Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 5.0),
                          child: Icon(
                            PhosphorIcons.plus_circle_fill,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                        Text(
                          "EXPENSE",
                          style: TextStyle(color: Colors.white,fontSize: 11),
                        )
                      ],
                    ),
                  )),
            ),
            const SizedBox(height: 30,)
          ],
        ),
      ),
    );
  }
}
