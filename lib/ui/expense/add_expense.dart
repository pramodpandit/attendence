import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:office/ui/widget/app_bar.dart';
import 'package:office/ui/widget/app_button.dart';
import 'package:office/ui/widget/app_text_field.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({Key? key}) : super(key: key);

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController reason = TextEditingController();
  TextEditingController expense = TextEditingController();
  TextEditingController reasonTitle = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text(
      //     "Add Expenses",
      //     style: TextStyle(
      //         fontWeight: FontWeight.w600,
      //         fontSize: 20,
      //         letterSpacing: 0.5,
      //         color: Colors.black),
      //   ),
      //   centerTitle: true,
      //   leading: GestureDetector(
      //       onTap: () {
      //         Navigator.pop(context);
      //       },
      //       child: const Icon(
      //         PhosphorIcons.caret_left_bold,
      //         color: Colors.black,
      //       )),
      // ),
      // appBar: const MyAppBar(
      //   title: "Add Expenses",
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
              const SizedBox(height: 100,),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 40),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppTextField(
                            controller: reasonTitle,
                            title: "Title",
                            validate: true,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          AppTextField(
                            controller: reason,
                            title: "Description",
                            validate: true,
                            maxLines: 5,
                            inputAction: TextInputAction.done,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          AppTextField(
                            controller: reasonTitle,
                            title: "Expense Amount",
                            validate: true,
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () async {
                              DateTime? dt = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now().add(Duration(days: 30)),
                              );
                              if (dt != null) {
                                // bloc.updateStartDate(dt);
                              }
                            },
                            child: Container(
                              height: 50,
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Row(
                                children: [
                                  Icon(PhosphorIcons.clock),
                                  SizedBox(width: 15),
                                  Text(
                                    "Select Date",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          AppButton(
                            title: "Submit",
                            onTap: () {
                              if (formKey.currentState!.validate()) {
                                // bloc.addComplaint();
                              }
                            },
                            margin: EdgeInsets.zero,
                            // loading: loading,
                          )
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
