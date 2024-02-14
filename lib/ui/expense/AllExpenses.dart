import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../bloc/holiday_bloc.dart';
import '../../data/repository/holiday_repo.dart';
import 'expense_details.dart';

class AllExpenses extends StatefulWidget {
  const AllExpenses({Key? key}) : super(key: key);

  @override
  State<AllExpenses> createState() => _AllExpensesState();
}

class _AllExpensesState extends State<AllExpenses> {
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
                  "All Expenses",
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
                                      value: DateTime.now().year - 15 + index,
                                      child: Text((DateTime.now().year - 15 + index).toString()),
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
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
