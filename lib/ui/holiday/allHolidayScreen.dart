import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../bloc/holiday_bloc.dart';
import '../../data/model/holiday_model.dart';
import '../../data/repository/holiday_repo.dart';

class AllHoliday extends StatefulWidget {
  const AllHoliday({Key? key}) : super(key: key);

  @override
  State<AllHoliday> createState() => _AllHolidayState();
}

class _AllHolidayState extends State<AllHoliday> {
  late HolidayEventBloc holidayBloc;
  @override
  void initState() {
    holidayBloc = HolidayEventBloc(context.read<HolidayEventRepository>());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            child:const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                 SizedBox(height: 56,),
                Text(
                  "All Holidays",
                  textAlign: TextAlign.center,
                  style:TextStyle(
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                const SizedBox(height: 110,),
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
                                title: const Text("Select Year"),
                                content: DropdownButton<int>(
                                  value: date?.year ?? DateTime.now().year,
                                  items: List.generate(30, (index) {
                                    return DropdownMenuItem<int>(
                                      value: DateTime.now().year - 0 + index,
                                      child: Text((DateTime.now().year - 0 + index).toString()),
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
                                      Navigator.pop(context, date?.year ?? DateTime.now().year);
                                    },
                                    child: Text('Select'),
                                  ),
                                ],
                              );
                            },
                          );

                          if (selectedYear != null) {
                            DateTime selectedDate = DateTime(selectedYear);
                            await holidayBloc.updateStartYear(selectedDate);
                            print("$selectedDate");
                          }
                        },

                        child: Container(
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            children: [
                              const Icon(PhosphorIcons.clock),
                              const SizedBox(width: 15),
                              Text(date==null ?  DateFormat('yyyy').format(DateTime.now()) : DateFormat('yyyy').format(date), style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),),
                            ],
                          ),
                        ),
                      );
                    }
                ),
                Expanded(
                    child:  ValueListenableBuilder(
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
                                  "No holiday this year.",
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
                                return ListView.builder(
                                    itemCount: 10,
                                    padding: EdgeInsets.only(top: 10,bottom: 10),
                                    shrinkWrap: true,
                                    itemBuilder: (context,index){
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Container(
                                            margin: const EdgeInsets.symmetric(horizontal: 5),
                                            padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10,right: 10),
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
                                            child: const Row(
                                              children: [
                                                Column(
                                                  children: [
                                                    Text(
                                                      "Aug",
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                        fontWeight: FontWeight.w600,
                                                        fontFamily: 'Poppins',
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                                    Text(
                                                      "Fri",
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                        fontFamily: 'Poppins',
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                                    Text(
                                                      "03",
                                                      style: TextStyle(
                                                        fontSize: 19,
                                                        fontWeight: FontWeight.bold,
                                                        fontFamily: 'Poppins',
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 45, child: VerticalDivider()),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    "Diwali",
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )),
                                      );
                                    }
                                );
                              },
                            );
                          },
                        );
                      },
                    )
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
