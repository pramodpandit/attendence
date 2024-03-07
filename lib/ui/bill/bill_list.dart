import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../bloc/e_bill_bloc.dart';
import '../../data/model/e_bill_model.dart';
import '../../data/repository/e_bill_repo.dart';

class BillList extends StatefulWidget {
  const BillList({Key? key}) : super(key: key);

  @override
  State<BillList> createState() => _BillListState();
}

class _BillListState extends State<BillList> {
  late EBillBloc bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc =EBillBloc(context.read<EBillRepository>());
    bloc.fetchEBill();
    bloc.fetchBillList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            height: 100,
            width: 1.sw,
            decoration: const BoxDecoration(
                color: Color(0xFF009FE3),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 56,
                ),
                Text(
                  "Bill List",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
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
                child: Icon(
                  Icons.arrow_back,
                  size: 18,
                ),
              ),
            ),
          ),
          Positioned(
            top: 56,
            right: 10,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const CircleAvatar(
                backgroundColor: Colors.white,
                radius: 15,
                child: Icon(
                  PhosphorIcons.export,
                  size: 18,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              children: [
                const SizedBox(
                  height: 100,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                    "Select Month",
                                    style: const TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                ValueListenableBuilder(
                                  valueListenable: bloc.month,
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
                                            bloc.year.value?.year ??
                                                DateTime.now().year,
                                            selectedMonth,
                                          );
                                          await bloc.updateMonth(selectedDate);
                                          await bloc.fetchBillList();
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
                                    valueListenable: bloc.year,
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
                                            await bloc.updateYear(selectedDate);
                                            await bloc.fetchBillList();
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
                          ],
                        ),
                        const SizedBox(height: 20,),
                        ValueListenableBuilder(
                            valueListenable: bloc.eBill,
                             builder: (context, List<EBill>eBill,__) {

                               if (eBill.isEmpty) {
                                 return const Center(
                                   child: Column(
                                     children: [
                                       SizedBox(height: 50),
                                       Text(
                                         "No data Found",
                                         style: TextStyle(color: Colors.black),
                                       ),
                                     ],
                                   ),
                                 );
                               }
                               return ValueListenableBuilder(
                                 valueListenable: bloc.ebillList,
                                 builder: (context, ebilllistdata, child) {
                                   if(ebilllistdata ==null){
                                     return Center(child: CircularProgressIndicator(),);
                                   }
                                   if (ebilllistdata!.isEmpty) {
                                     return CircularProgressIndicator();
                                   }
                                   return

                                     Scrollbar(
                                       thumbVisibility: true,
                                       thickness: 4,
                                       controller: bloc.scrollController,
                                       child: SingleChildScrollView(
                                         scrollDirection: Axis.horizontal,
                                         controller: bloc.scrollController,
                                         child: Table(
                                           border: TableBorder.all(),
                                           defaultColumnWidth: const FixedColumnWidth(
                                               100),
                                           children: [
                                             TableRow(
                                                 decoration: BoxDecoration(
                                                   border: Border.all(
                                                       color: Colors.black),
                                                 ),
                                                 children: [
                                                   const Padding(
                                                     padding: EdgeInsets.all(5.0),
                                                     child: Text("Date",
                                                       style: TextStyle(
                                                           color: Colors.blue,
                                                           fontWeight: FontWeight
                                                               .w600),),
                                                   ),
                                                   for (var type in eBill)
                                                     Padding(
                                                       padding: const EdgeInsets
                                                           .all(5.0),
                                                       child: Text(
                                                         "${type.name}",
                                                         style: const TextStyle(
                                                             color: Colors.blue,
                                                             fontWeight: FontWeight
                                                                 .w600),
                                                       ),
                                                     ),
                                                 ]
                                             ),

                                             ...ebilllistdata.map((item) {
                                               return TableRow(
                                                   decoration: BoxDecoration(
                                                       border: Border.all(
                                                           color: Colors.black)
                                                   ),
                                                   children: [
                                                     Padding(
                                                       padding: EdgeInsets.all(5.0),
                                                       child: Text(
                                                         DateFormat("dd-MM-yyyy")
                                                             .format(DateTime.parse(
                                                             item['f_date']!)),
                                                         style: const TextStyle(
                                                             color: Color(
                                                                 0xff20263c),
                                                             fontWeight: FontWeight
                                                                 .w600),),
                                                     ),
                                                     for (var type in eBill)
                                                       Padding(
                                                         padding: EdgeInsets.all(
                                                             5.0),
                                                         child: Text(
                                                           // Check if water ID and type ID are the same, then show quantity
                                                           (item['e_type'] ==
                                                               "${type.id}")
                                                               ? item['t_reading']?? ""
                                                               : "",
                                                           style: const TextStyle(
                                                               color: Color(
                                                                   0xff20263c),
                                                               fontWeight: FontWeight
                                                                   .w600),
                                                         ),
                                                       ),
                                                   ]
                                               );
                                             }).toList()
                                           ],
                                         ),
                                       )
                                   );
                                 },


                               );
                             }
                        )
                      ],
                    ),
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
