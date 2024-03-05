import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:office/bloc/expense_bloc.dart';
import 'package:office/ui/widget/app_bar.dart';
import 'package:office/ui/widget/app_button.dart';
import 'package:office/ui/widget/app_dropdown.dart';
import 'package:office/ui/widget/app_text_field.dart';

class AddExpense extends StatefulWidget {
  ExpenseBloc bloc;
  AddExpense({Key? key,required this.bloc}) : super(key: key);

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
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
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 56,),
                Text(
                  "Add Expenses",
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
          Column(
            children: [
              const SizedBox(height: 90,),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 40),
                    child: Form(
                      key: widget.bloc.formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              SizedBox(width: 10),
                              Text("Expense type"),
                              Text("*",style: TextStyle(color: Colors.red),)
                            ],
                          ),
                          const SizedBox(height: 10),
                          ValueListenableBuilder(
                            valueListenable: widget.bloc.allExpenseTypeData,
                            builder: (context, allExpenseTypeData, child) {
                              if(allExpenseTypeData == null){
                                return AppDropdown(
                                  items: const [],
                                  onChanged: (value) {

                                  },
                                  value: null,
                                  hintText: "Expense type",
                                );
                              }
                            return AppDropdown(
                              items: allExpenseTypeData.map((e) => DropdownMenuItem<String>(value: e['id'].toString(),child: Text(e['name']))).toList(),
                              onChanged: (value) {
                                widget.bloc.expense.value = value.toString();
                              },
                              value: widget.bloc.expense.value,
                              hintText: "Expense type",
                            );
                          },),
                          const SizedBox(
                            height: 20,
                          ),
                          const Row(
                            children: [
                              SizedBox(width: 10),
                              Text("Select Date"),
                              Text("*",style: TextStyle(color: Colors.red),)
                            ],
                          ),
                          const SizedBox(height: 10),
                          InkWell(
                            onTap: () async {
                              await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(3000),
                              ).then((value) {
                                if(value != null){
                                  widget.bloc.date.value = value.toString().split(" ").first;
                                }
                              });
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
                                  Icon(PhosphorIcons.clock),
                                  SizedBox(width: 15),
                                  ValueListenableBuilder(
                                    valueListenable: widget.bloc.date,
                                    builder: (context, date, child) {
                                    return Text(
                                      date ?? "Select Date",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    );
                                  },),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          AppTextField(
                            controller: widget.bloc.description,
                            title: "Description",
                            validate: true,
                            maxLines: 5,
                            inputAction: TextInputAction.done,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          AppTextField(
                            controller: widget.bloc.amount,
                            title: "Amount",
                            validate: true,
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ValueListenableBuilder(
                            valueListenable: widget.bloc.isAddLoading,
                            builder: (context, isAddLoading, child) {
                            return AppButton(
                              title: "Submit",
                              loading: isAddLoading,
                              onTap: () {
                                if (widget.bloc.formKey.currentState!.validate()) {
                                  widget.bloc.addExpense(context);
                                }
                              },
                              margin: EdgeInsets.zero,
                              // loading: loading,
                            );
                          },)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      /*SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                    // controller: bloc.tittleController,
                    decoration: const InputDecoration(
                      // filled: true,
                      fillColor: Color(0xffffffff),
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      hintText: "Add Title",
                      focusColor: Colors.white,
                      counterStyle: TextStyle(color: Colors.white),
                      hintStyle: TextStyle(
                          color: Color(0xff777777),
                          fontWeight: FontWeight.w700,
                          fontFamily: "Poppins"),
                    ),
                    textAlign: TextAlign.left,
                    validator: (value) {
                      if (value.toString().isEmpty) {
                        return "Title is required";
                      }
                      return null;
                    },
                    onTap: () {},
                  ),
                  Text(
                    DateFormat.yMMMMd().format(DateTime.now()),
                    textAlign: TextAlign.start,
                    style: const TextStyle(color: Colors.black54, fontSize: 9),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    maxLines: null,
                    // controller: bloc.descriptionController,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.black54),
                    decoration: const InputDecoration(
                      // filled: true,
                      fillColor: Color(0xffffffff),
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      hintText: "Entre Total Expense Amount",
                      focusColor: Colors.white,
                      counterStyle: TextStyle(color: Colors.white),
                      hintStyle: TextStyle(
                          color: Color(0xff777777),
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          fontFamily: "Poppins"),
                    ),
                    validator: (value) {
                      if (value.toString().isEmpty) {
                        return "Title is required";
                      }
                      return null;
                    },
                    onTap: () {},
                  ),
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    // controller: bloc.descriptionController,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Colors.black54),
                    decoration: const InputDecoration(
                      // filled: true,
                      fillColor: Color(0xffffffff),
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      hintText: "Add Description",
                      focusColor: Colors.white,
                      counterStyle: TextStyle(color: Colors.white),
                      hintStyle: TextStyle(
                          color: Color(0xff777777),
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          fontFamily: "Poppins"),
                    ),
                    validator: (value) {
                      if (value.toString().isEmpty) {
                        return "Title is required";
                      }
                      return null;
                    },
                    onTap: () {},
                  )
                ],
              ),
            )
          ],
        ),
      ),*/
      // floatingActionButton: Column(
      //   mainAxisAlignment: MainAxisAlignment.end,
      //   children: [
      //     SizedBox(
      //       height: 40,
      //       width: 100,
      //       child: FloatingActionButton.extended(
      //           shape: const RoundedRectangleBorder(
      //               borderRadius: BorderRadius.all(Radius.circular(5.0))
      //           ),
      //           onPressed: (){
      //
      //           },
      //           backgroundColor: const Color(0xFF009FE3),
      //           label: AnimatedSwitcher(
      //             duration: const Duration(seconds: 1),
      //             transitionBuilder: (Widget child, Animation<double> animation) =>
      //                 FadeTransition(
      //                   opacity: animation,
      //                   child: SizeTransition(
      //                     sizeFactor: animation,
      //                     axis: Axis.horizontal,
      //                     child: child,
      //                   ),
      //                 ),
      //             child: const Row(
      //               children: [
      //                 Padding(
      //                   padding: EdgeInsets.only(right: 5.0),
      //                   child: Icon(
      //                     Icons.save,
      //                     color: Colors.white,
      //                     size: 18,
      //                   ),
      //                 ),
      //                 Text(
      //                   "Save",
      //                   style: TextStyle(color: Colors.white,),
      //                 )
      //               ],
      //             ),
      //           )),
      //     ),
      //     const SizedBox(height: 30,)
      //   ],
      // ),
    );
  }
}
