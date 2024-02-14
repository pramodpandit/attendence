import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:office/bloc/leads_bloc.dart';
import 'package:office/ui/widget/app_bar.dart';
import 'package:provider/provider.dart';

import '../../bloc/task_bloc.dart';
import '../../data/repository/task_repo.dart';
import '../../utils/constants.dart';
import '../widget/app_button.dart';
import '../widget/app_dropdown.dart';
import '../widget/app_text_field.dart';

class addTask extends StatefulWidget {
  const addTask({Key? key}) : super(key: key);

  @override
  State<addTask> createState() => _addTask();
}

class _addTask extends State<addTask> {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late taskBloc bloc;
  @override
  void initState() {
    bloc = taskBloc(context.read<TaskRepositary>());
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
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 56,),
                Text(
                  "Add Task",
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
                          const Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Row(
                              children: [
                                Text("Category", style: TextStyle(fontSize: 13)),
                                Text("*", style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),)
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          DropdownButtonFormField<String>(
                            icon: const Icon(
                              Icons.keyboard_arrow_down_sharp,
                              color: Colors.grey,
                            ),
                            iconSize: 24,
                            elevation: 16,
                            style: const TextStyle(color: Colors.black, fontSize: 15),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey[200],
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Color(0xffF4F5F7)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Color(0xffF2F2F2)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 10),
                              hintText: "Select",
                              hintStyle:
                              TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 15,fontWeight: FontWeight.w500),
                            ),
                            onChanged: (String? data) {
                              bloc.selectStatus(data!);
                            },
                            items: bloc.TaskCategory.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value,style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w500),),
                              );
                            }).toList(),
                          ),

                          const SizedBox(
                            height: 20,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Row(
                              children: [
                                Text("Project", style: TextStyle(fontSize: 13)),
                                Text("*", style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),)
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          DropdownButtonFormField<String>(
                            icon: const Icon(
                              Icons.keyboard_arrow_down_sharp,
                              color: Colors.grey,
                            ),
                            iconSize: 24,
                            elevation: 16,
                            style: const TextStyle(color: Colors.black, fontSize: 15),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey[200],
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Color(0xffF4F5F7)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Color(0xffF2F2F2)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 10),
                              hintText: "Select",
                              hintStyle:
                              TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 15,fontWeight: FontWeight.w500),
                            ),
                            onChanged: (String? data) {
                              bloc.selectProject(data!);
                            },
                            items: bloc.Project.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value,style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w500),),
                              );
                            }).toList(),
                          ),

                          const SizedBox(
                            height: 20,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Row(
                              children: [
                                Text("Deparment", style: TextStyle(fontSize: 13)),
                                Text("*", style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),)
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          DropdownButtonFormField<String>(
                            icon: const Icon(
                              Icons.keyboard_arrow_down_sharp,
                              color: Colors.grey,
                            ),
                            iconSize: 24,
                            elevation: 16,
                            style: const TextStyle(color: Colors.black, fontSize: 15),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey[200],
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Color(0xffF4F5F7)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Color(0xffF2F2F2)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 10),
                              hintText: "Select",
                              hintStyle:
                              TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 15,fontWeight: FontWeight.w500),
                            ),
                            onChanged: (String? data) {
                              bloc.selectDepartment(data!);
                            },
                            items: bloc.Department.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value,style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w500),),
                              );
                            }).toList(),
                          ),

                          const SizedBox(
                            height: 20,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Row(
                              children: [
                                Text("Employee", style: TextStyle(fontSize: 13)),
                                Text("*", style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),)
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          DropdownButtonFormField<String>(
                            icon: const Icon(
                              Icons.keyboard_arrow_down_sharp,
                              color: Colors.grey,
                            ),
                            iconSize: 24,
                            elevation: 16,
                            style: const TextStyle(color: Colors.black, fontSize: 15),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey[200],
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Color(0xffF4F5F7)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Color(0xffF2F2F2)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 10),
                              hintText: "Select",
                              hintStyle:
                              TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 15,fontWeight: FontWeight.w500),
                            ),
                            onChanged: (String? data) {
                              bloc.selectEmployee(data!);
                            },
                            items: bloc.Employee.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value,style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w500),),
                              );
                            }).toList(),
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          AppTextField(
                            controller: bloc.title,
                            title: "Title",
                            validate: true,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text("Start Date", style: TextStyle(fontSize: 13)),
                          ),
                          const SizedBox(height: 5),
                          ValueListenableBuilder(
                              valueListenable: bloc.startDate,
                              builder: (context, DateTime? date, _) {
                                return InkWell(
                                  onTap: () async {
                                    DateTime? dt = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now().subtract(Duration(days: 15)), lastDate:  DateTime.now().add(Duration(days: 30)),);
                                    if(dt!=null) {
                                      await bloc.updateDateStart(dt);
                                    }
                                  },
                                  child: Container(
                                    height: 50,
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(PhosphorIcons.clock),
                                        const SizedBox(width: 15),
                                        Text(date==null ?  DateFormat('MMM dd, yyyy').format(DateTime.now()) : DateFormat('MMM dd, yyyy').format(date), style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),),
                                      ],
                                    ),
                                  ),
                                );
                              }
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text("Due Date", style: TextStyle(fontSize: 13)),
                          ),
                          const SizedBox(height: 5),
                          ValueListenableBuilder(
                              valueListenable: bloc.endDate,
                              builder: (context, DateTime? date, _) {
                                return InkWell(
                                  onTap: () async {
                                    DateTime? dt = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now().subtract(Duration(days: 15)), lastDate:  DateTime.now().add(Duration(days: 30)),);
                                    if(dt!=null) {
                                      await bloc.updateEndDate(dt);
                                    }
                                  },
                                  child: Container(
                                    height: 50,
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(PhosphorIcons.clock),
                                        const SizedBox(width: 15),
                                        Text(date==null ?  DateFormat('MMM dd, yyyy').format(DateTime.now()) : DateFormat('MMM dd, yyyy').format(date), style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),),
                                      ],
                                    ),
                                  ),
                                );
                              }
                          ),
                          AppTextField(
                            controller: bloc.description,
                            title: "Description",
                            validate: true,
                            maxLines: 4,
                            keyboardType: TextInputType.text,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Row(
                              children: [
                                Text("Task Label", style: TextStyle(fontSize: 13)),
                                Text("*", style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),)
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          DropdownButtonFormField<String>(
                            icon: const Icon(
                              Icons.keyboard_arrow_down_sharp,
                              color: Colors.grey,
                            ),
                            iconSize: 24,
                            elevation: 16,
                            style: const TextStyle(color: Colors.black, fontSize: 15),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey[200],
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Color(0xffF4F5F7)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Color(0xffF2F2F2)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 10),
                              hintText: "Select",
                              hintStyle:
                              TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 15,fontWeight: FontWeight.w500),
                            ),
                            onChanged: (String? data) {
                              bloc.selectEmployee(data!);
                            },
                            items: bloc.Employee.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value,style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w500),),
                              );
                            }).toList(),
                          ),

                          const SizedBox(
                            height: 20,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Row(
                              children: [
                                Text("Priority", style: TextStyle(fontSize: 13)),
                                Text("*", style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),)
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          DropdownButtonFormField<String>(
                            icon: const Icon(
                              Icons.keyboard_arrow_down_sharp,
                              color: Colors.grey,
                            ),
                            iconSize: 24,
                            elevation: 16,
                            style: const TextStyle(color: Colors.black, fontSize: 15),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey[200],
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Color(0xffF4F5F7)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Color(0xffF2F2F2)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 10),
                              hintText: "Select",
                              hintStyle:
                              TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 15,fontWeight: FontWeight.w500),
                            ),
                            onChanged: (String? data) {
                              bloc.selectEmployee(data!);
                            },
                            items: bloc.Employee.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value,style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w500),),
                              );
                            }).toList(),
                          ),

                          const SizedBox(
                            height: 20,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Row(
                              children: [
                                Text("Status", style: TextStyle(fontSize: 13)),
                                Text("*", style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),)
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          DropdownButtonFormField<String>(
                            icon: const Icon(
                              Icons.keyboard_arrow_down_sharp,
                              color: Colors.grey,
                            ),
                            iconSize: 24,
                            elevation: 16,
                            style: const TextStyle(color: Colors.black, fontSize: 15),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey[200],
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Color(0xffF4F5F7)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Color(0xffF2F2F2)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 10),
                              hintText: "Select",
                              hintStyle:
                              TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 15,fontWeight: FontWeight.w500),
                            ),
                            onChanged: (String? data) {
                              bloc.selectEmployee(data!);
                            },
                            items: bloc.Employee.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value,style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w500),),
                              );
                            }).toList(),
                          ),

                          const SizedBox(
                            height: 20,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Row(
                              children: [
                                Text("Billing", style: TextStyle(fontSize: 13)),
                                Text("*", style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),)
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          DropdownButtonFormField<String>(
                            icon: const Icon(
                              Icons.keyboard_arrow_down_sharp,
                              color: Colors.grey,
                            ),
                            iconSize: 24,
                            elevation: 16,
                            style: const TextStyle(color: Colors.black, fontSize: 15),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey[200],
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Color(0xffF4F5F7)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Color(0xffF2F2F2)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 10),
                              hintText: "Select",
                              hintStyle:
                              TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 15,fontWeight: FontWeight.w500),
                            ),
                            onChanged: (String? data) {
                              bloc.selectEmployee(data!);
                            },
                            items: bloc.Employee.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value,style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w500),),
                              );
                            }).toList(),
                          ),

                          const SizedBox(
                            height: 20,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Row(
                              children: [
                                Text("Repeat Type", style: TextStyle(fontSize: 13)),
                                Text("*", style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),)
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          DropdownButtonFormField<String>(
                            icon: const Icon(
                              Icons.keyboard_arrow_down_sharp,
                              color: Colors.grey,
                            ),
                            iconSize: 24,
                            elevation: 16,
                            style: const TextStyle(color: Colors.black, fontSize: 15),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey[200],
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Color(0xffF4F5F7)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Color(0xffF2F2F2)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 10),
                              hintText: "Select",
                              hintStyle:
                              TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 15,fontWeight: FontWeight.w500),
                            ),
                            onChanged: (String? data) {
                              bloc.selectEmployee(data!);
                            },
                            items: bloc.Employee.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value,style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w500),),
                              );
                            }).toList(),
                          ),

                          const SizedBox(
                            height: 20,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Row(
                              children: [
                                Text("Dependent", style: TextStyle(fontSize: 13)),
                                Text("*", style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),)
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          DropdownButtonFormField<String>(
                            icon: const Icon(
                              Icons.keyboard_arrow_down_sharp,
                              color: Colors.grey,
                            ),
                            iconSize: 24,
                            elevation: 16,
                            style: const TextStyle(color: Colors.black, fontSize: 15),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey[200],
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Color(0xffF4F5F7)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Color(0xffF2F2F2)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 10),
                              hintText: "Select",
                              hintStyle:
                              TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 15,fontWeight: FontWeight.w500),
                            ),
                            onChanged: (String? data) {
                              bloc.selectEmployee(data!);
                            },
                            items: bloc.Employee.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value,style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w500),),
                              );
                            }).toList(),
                          ),

                          const SizedBox(
                            height: 20,
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
    );
  }
}
