import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:office/bloc/leads_bloc.dart';
import 'package:office/ui/widget/app_dropdown.dart';
import 'package:office/ui/widget/app_text_field.dart';

class AddLeadLogs extends StatefulWidget {
  final int leadId;
  final LeadsBloc bloc;
  const AddLeadLogs({super.key,required this.leadId,required this.bloc});

  @override
  State<AddLeadLogs> createState() => _AddLeadLogsState();
}

class _AddLeadLogsState extends State<AddLeadLogs> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.bloc.getAllProjectTypes();
    widget.bloc.getAllCurrencyData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: const MyAppBar(
      //   title: "Give Feedback",
      // ),
      body: SingleChildScrollView(
        child: Stack(
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
                    "Add Logs",
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
            Column(
              children: [
                const SizedBox(
                  height: 100,
                ),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 25),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppDropdown(
                            items: const [
                              DropdownMenuItem(value: "open", child: Text("Open")),
                              DropdownMenuItem(value: "dead", child: Text("Dead")),
                              DropdownMenuItem(value: "converted", child: Text("Converted")),
                            ],
                            onChanged: (value) {
                              widget.bloc.logStatus.value = value;
                            },
                            value: widget.bloc.logStatus.value,
                            hintText: "Select Status",
                        ),
                        ValueListenableBuilder(
                          valueListenable: widget.bloc.logStatus,
                          builder: (context, logStatus, child) {
                            if(logStatus == null) {
                              return Offstage();
                            }
                            if(logStatus == "open"){
                              return Column(
                                children: [
                                  const SizedBox(height: 10),
                                  InkWell(
                                    onTap: () {
                                      showDatePicker(context: context, firstDate: DateTime(2000), lastDate: DateTime(3000)).then((value){
                                        if(value != null){
                                          widget.bloc.nextFollowUpDate.text = value.toString().split(" ").first;
                                        }
                                      });
                                    },
                                    child: AppTextField(
                                      controller: widget.bloc.nextFollowUpDate,
                                      title: "Next Follow Up Date",
                                      showTitle: false,
                                      enabled: false,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  InkWell(
                                    onTap: () {
                                      showTimePicker(context: context, initialTime: TimeOfDay.now()).then((value){
                                        if(value != null){
                                          widget.bloc.nextFollowUpTime.text = DateFormat.jm().format(DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,value.hour,value.minute));
                                        }
                                      });
                                    },
                                    child: AppTextField(
                                      controller: widget.bloc.nextFollowUpTime,
                                      title: "Next Follow Up Time",
                                      showTitle: false,
                                      enabled: false,
                                    ),
                                  ),
                                ],
                              );
                            }
                            return Offstage();
                        },),
                        const SizedBox(height: 10),
                        AppTextField(
                            controller: widget.bloc.message,
                            title: "message",
                          maxLines: 3,
                          showTitle: false,
                        ),
                        ValueListenableBuilder(
                          valueListenable: widget.bloc.logStatus,
                          builder: (context, logStatus, child) {
                            if(logStatus == null) {
                              return Offstage();
                            }
                            if(logStatus == "converted"){
                              return Column(
                                children: [
                                  const SizedBox(height: 10),
                                  AppDropdown(
                                    items: const [
                                      DropdownMenuItem(value: "yes", child: Text("Yes")),
                                      DropdownMenuItem(value: "no", child: Text("No")),
                                    ],
                                    onChanged: (value) {
                                      widget.bloc.projectConvert.value = value;
                                    },
                                    value: widget.bloc.projectConvert.value,
                                    hintText: "Want to convert into a project",
                                  ),
                                ],
                              );
                            }
                            return Offstage();
                          },),
                        ValueListenableBuilder(
                          valueListenable: widget.bloc.projectConvert,
                          builder: (context, projectConvert, child) {
                            if(projectConvert == null) {
                              return Offstage();
                            }
                            if(projectConvert == "yes"){
                              return Column(
                                children: [
                                  const SizedBox(height: 10),
                                  AppDropdown(
                                    items: const [
                                      DropdownMenuItem(value: "specific", child: Text("Specific")),
                                      DropdownMenuItem(value: "everyone", child: Text("Everyone")),
                                    ],
                                    onChanged: (value) {
                                      widget.bloc.branch.value = value;
                                    },
                                    value: widget.bloc.branch.value,
                                    hintText: "Branch",
                                  ),
                           // one missing
                                  const SizedBox(height: 10),
                                  ValueListenableBuilder(
                                    valueListenable: widget.bloc.allProjectTypes,
                                    builder: (context, allProjectTypes, child) {
                                      if(allProjectTypes == null){
                                        return AppDropdown(
                                          items: const [],
                                          onChanged: (value) {
                                            widget.bloc.projectType.value = value;
                                          },
                                          value: null,
                                          hintText: "Project Type",
                                        );
                                      }
                                    return AppDropdown(
                                      items: allProjectTypes.map((e) => DropdownMenuItem<String>(child: Text(e['name']),value: e['id'].toString(),)).toList(),
                                      onChanged: (value) {
                                        widget.bloc.projectType.value = value;
                                        widget.bloc.shortCode.text = allProjectTypes.where((element) => element['id'].toString() == value.toString()).toList()[0]['short_code'];
                                      },
                                      value: widget.bloc.projectType.value,
                                      hintText: "Project Type",
                                    );
                                  },),
                                  const SizedBox(height: 10),
                                  AppTextField(
                                    controller: widget.bloc.shortCode,
                                    title: "Short code",
                                    showTitle: false,
                                  ),
                                  const SizedBox(height: 10),
                                  AppTextField(
                                    controller: widget.bloc.projectCode,
                                    title: "Project code",
                                    showTitle: false,
                                  ),
                                  const SizedBox(height: 10),
                                  InkWell(
                                    onTap: () {
                                      showDatePicker(context: context, firstDate: DateTime(2000),lastDate: DateTime(3000)).then((value){
                                        if(value != null){
                                          widget.bloc.startDate.text = value.toString().split(" ").first;
                                        }
                                      });
                                    },
                                    child: AppTextField(
                                      controller: widget.bloc.startDate,
                                      title: "Start date",
                                      showTitle: false,
                                      enabled: false,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  AppDropdown(
                                    items: const [
                                      DropdownMenuItem(value: "yes", child: Text("Yes")),
                                      DropdownMenuItem(value: "no", child: Text("No")),
                                    ],
                                    onChanged: (value) {
                                      widget.bloc.deadline.value = value;
                                    },
                                    value: widget.bloc.deadline.value,
                                    hintText: "Deadline",
                                  ),
                                  ValueListenableBuilder(
                                    valueListenable: widget.bloc.deadline,
                                    builder: (context, deadline, child) {
                                      if(deadline == null){
                                        return Offstage();
                                      }
                                      if(deadline == "yes"){
                                        return Column(
                                          children: [
                                            const SizedBox(height: 10),
                                            InkWell(
                                              onTap: () {
                                                showDatePicker(context: context, firstDate: DateTime(2000),lastDate: DateTime(3000)).then((value){
                                                  if(value != null){
                                                    widget.bloc.deadlineDate.text = value.toString().split(" ").first;
                                                  }
                                                });
                                              },
                                              child: AppTextField(
                                                controller: widget.bloc.deadlineDate,
                                                title: "Deadline date",
                                                showTitle: false,
                                                enabled: false,
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                      return Offstage();
                                  },),
                                  const SizedBox(height: 10),
                                  AppTextField(
                                      controller: widget.bloc.projectSummary,
                                      title: "Project summary",
                                    showTitle: false,
                                    maxLines: 4,
                                  ),
                                  const SizedBox(height: 10),
                                  AppTextField(
                                    controller: widget.bloc.notes,
                                    title: "Notes",
                                    showTitle: false,
                                    maxLines: 4,
                                  ),
                                ],
                              );
                            }
                            return Offstage();
                          },),
                      ]
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
