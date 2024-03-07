import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:office/bloc/expense_bloc.dart';
import 'package:office/data/repository/expense_repo.dart';
import 'package:office/ui/expense/add_expense.dart';
import 'package:office/ui/expense/expense_details.dart';
import 'package:office/utils/constants.dart';
import 'package:office/utils/message_handler.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:office/ui/widget/app_bar.dart';

import '../holiday/allHolidayScreen.dart';

class ExpenseList extends StatefulWidget {
  final dynamic expanseAllow;
  final String userType;
  const ExpenseList({Key? key, required this.expanseAllow, required this.userType}) : super(key: key);

  @override
  State<ExpenseList> createState() => _ExpenseListState();
}

class _ExpenseListState extends State<ExpenseList> {
  late ExpenseBloc bloc;
  ValueNotifier<CalendarFormat> calendar = ValueNotifier(CalendarFormat.week);
  int month = DateTime.now().month;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc = ExpenseBloc(context.read<ExpenseRepository>());
    bloc.msgController!.stream.listen((event) {
      AppMessageHandler().showSnackBar(context, event);
    });
    bloc.getActiveExpenseTypeData(widget.expanseAllow,widget.userType).then((value){
      bloc.getExpenseData(value);
    });
    bloc.fetchUserDetail();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Column(
        children: [
          Stack(
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
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AddExpense(bloc: bloc,)));
                  },
                  child: const CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 15,
                    child: Icon(
                      Icons.add,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async{
                bloc.allExpenseData.value = null;
                bloc.getExpenseData(bloc.expenseType.value!);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Expanded(
                    child: ValueListenableBuilder(
                      valueListenable: bloc.allExpenseData,
                      builder: (context, allExpenseData, child) {
                        if(allExpenseData == null){
                          return SizedBox(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        if(allExpenseData.isEmpty){
                          return Center(
                            child: Text("No data available"),
                          );
                        }
                        return ListView.builder(
                            itemCount: allExpenseData.length,
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
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Row(
                                          children: [
                                            const Expanded(child: Row()),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                                              decoration:  BoxDecoration(
                                                // color:index==1?Color(0xFFD41817):Color(0xFF3CEB43),
                                                color:allExpenseData[index]['paid'].toString()== "yes"?Color(0xFF3CEB43):Color(0xFFD41817),
                                                borderRadius: const BorderRadius.all(Radius.circular(5)),
                                              ),
                                              child: Text(
                                                // index==1?"Rejected":"Approved",
                                                allExpenseData[index]['paid'].toString()== "yes"?"Approved":"Rejected",
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
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                allExpenseData[index]['description'] ?? "",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              allExpenseData[index]['amount'].toString(),
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10,),
                                        Text(
                                          // "Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipi.Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipi. Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipi.Neque porro quisquam.",
                                          "Created at : ${DateFormat.yMMMd().format(DateTime.parse(allExpenseData[index]['created_at']))}",
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
                        );
                      },),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: 50,
            width: 50,
            child: FloatingActionButton.extended(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(300.0))
                ),
                onPressed: () async{
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.white,
                    builder: (context) {
                      return Container(
                        padding: EdgeInsets.all(10),
                        width: double.infinity,
                        child: ValueListenableBuilder(
                          valueListenable: bloc.allExpenseTypeData,
                          builder: (context, allExpenseTypeData, child) {
                            if(allExpenseTypeData == null){
                              return SizedBox(
                                  height : 200,
                                  child: Center(child: SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                  )),
                              );
                            }
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: allExpenseTypeData.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                  bloc.allExpenseData.value = null;
                                  bloc.expenseType.value = allExpenseTypeData[index]["id"].toString();
                                  bloc.getExpenseData(allExpenseTypeData[index]["id"].toString());
                                },
                                child: ValueListenableBuilder(
                                  valueListenable: bloc.expenseType,
                                  builder: (context, expenseType, child) {
                                    return Container(
                                      margin: EdgeInsets.all(5),
                                      padding : EdgeInsets.symmetric(horizontal: 10,vertical: 3),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              allExpenseTypeData[index]["name"],
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: expenseType == allExpenseTypeData[index]["id"].toString()?Colors.white:Colors.black,
                                              )),
                                          expenseType == allExpenseTypeData[index]["id"].toString()?Icon(PhosphorIcons.check_circle_fill,color: Colors.white):Offstage(),
                                        ],
                                      ),
                                      decoration: BoxDecoration(
                                          color: expenseType == allExpenseTypeData[index]["id"].toString()? Colors.green: Colors.white,
                                          borderRadius: BorderRadius.circular(5)
                                      ),
                                    );
                                  },),
                              );
                            },
                          );
                        },)
                      );
                    },);
                },
                backgroundColor: const  Color(0xFF009FE3),
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
                      Center(
                        // padding: EdgeInsets.only(right: 5.0),
                        child: Icon(
                          Icons.change_circle,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      // Text(
                      //   "Lead",
                      //   style: TextStyle(color: Colors.white),
                      // )
                    ],
                  ),
                )),
          ),
          const SizedBox(height: 10,)
        ],
      ),
    );
  }
}
