import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../bloc/task_bloc.dart';
import '../../data/repository/task_repo.dart';
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
    bloc.getAllTaskCategoryData();
    bloc.getAllProjectsData();
    bloc.getAllDepartmentData();
    bloc.getAllTaskLabelData();
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
                                Text("Task Category", style: TextStyle(fontSize: 13)),
                                Text("*", style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),)
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          ValueListenableBuilder(
                            valueListenable: bloc.allTaskCategory,
                            builder: (context, allTaskCategory, child) {
                              if(allTaskCategory == null){
                                return AppDropdown(
                                  items: const [],
                                  onChanged: (value) {
                                    bloc.taskCategory.value = value.toString();
                                    bloc.getAllProjectsData();
                                  },
                                  value: null,
                                  hintText: "Select",
                                );
                              }
                            return AppDropdown(
                                items: allTaskCategory.map((e) => DropdownMenuItem(value: e['id'].toString(),child: Text(e['name']),)).toList(),
                                onChanged: (value) {
                                  bloc.taskCategory.value = value.toString();
                                  bloc.getAllProjectsData();
                                }, 
                                value: bloc.taskCategory.value, 
                                hintText: "Select",
                              validator: (value) {
                                if(value == null){
                                  return "Please Select Category Task";
                                }
                                return null;
                              },
                            );
                          },),
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
                          ValueListenableBuilder(
                            valueListenable: bloc.allProjectsData,
                            builder: (context, allProjectsData, child) {
                              if(allProjectsData == null){
                                return AppDropdown(
                                  items: const [],
                                  onChanged: (value) {
                                    bloc.project.value = value;
                                  },
                                  value: null,
                                  hintText: "Select",
                                );
                              }
                              return AppDropdown(
                                items: allProjectsData.map((e) => DropdownMenuItem(value: e['id'].toString(),child: Text(e['name'].toString()),)).toList(),
                                onChanged: (value) {
                                  bloc.project.value = value;
                                  bloc.getEmployeesDataByProjectId(value.toString());
                                },
                                value: bloc.project.value,
                                hintText: "Select",
                                validator: (value) {
                                  if(value == null){
                                    return "Please Select Project";
                                  }
                                  return null;
                                },
                              );
                            },),
                          ValueListenableBuilder(
                            valueListenable: bloc.project,
                            builder: (context, project, child) {
                              if(project == null){
                                return Offstage();
                              }
                            return Column(
                              children: [
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
                                ValueListenableBuilder(
                                  valueListenable: bloc.allEmployeesData,
                                  builder: (context, allEmployeesData, child) {
                                    if(allEmployeesData == null){
                                      return AppDropdown(
                                        items: const [],
                                        onChanged: (value) {
                                          bloc.employee.value = value.toString();
                                        },
                                        value: null,
                                        hintText: "Select",
                                      );
                                    }
                                    return AppDropdown(
                                      items: allEmployeesData.map((e) => DropdownMenuItem(value: e['id'].toString(),child: Text(e['user_details']['name'].toString()),)).toList(),
                                      onChanged: (value) {
                                        bloc.employee.value = value.toString();
                                      },
                                      value: bloc.employee.value,
                                      hintText: "Select",
                                    );
                                  },),
                                const SizedBox(
                                  height: 20,
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Row(
                                    children: [
                                      Text("Helper", style: TextStyle(fontSize: 13)),
                                      Text("*", style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),)
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 5),
                                ValueListenableBuilder(
                                  valueListenable: bloc.allEmployeesData,
                                  builder: (context, allEmployeesData, child) {
                                    if(allEmployeesData == null){
                                      return AppDropdown(
                                        items: const [],
                                        onChanged: (value) {
                                          bloc.helper.value = value.toString();
                                        },
                                        value: null,
                                        hintText: "Select",
                                      );
                                    }
                                    return AppDropdown(
                                      items: allEmployeesData.map((e) => DropdownMenuItem(value: e['id'].toString(),child: Text(e['user_details']['name'].toString()),)).toList(),
                                      onChanged: (value) {
                                        bloc.helper.value = value.toString();
                                      },
                                      value: bloc.helper.value,
                                      hintText: "Select",
                                    );
                                  },),
                              ],
                            );
                          },),
                          const SizedBox(
                            height: 20,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Row(
                              children: [
                                Text("Department", style: TextStyle(fontSize: 13)),
                                Text("*", style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),)
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          ValueListenableBuilder(
                            valueListenable: bloc.allDepartmentData,
                            builder: (context, allDepartmentData, child) {
                              if(allDepartmentData == null){
                                return AppDropdown(
                                  items: const [],
                                  onChanged: (value) {
                                    bloc.department.value = value.toString();
                                  },
                                  value: null,
                                  hintText: "Select",
                                );
                              }
                              return AppDropdown(
                                items: allDepartmentData.map((e) => DropdownMenuItem(value: e['id'].toString(),child: Text(e['name']),)).toList(),
                                onChanged: (value) {
                                  bloc.department.value = value.toString();
                                },
                                value: bloc.department.value,
                                hintText: "Select",
                                validator: (value) {
                                  if(value == null){
                                    return "Please Select Department";
                                  }
                                  return null;
                                },
                              );
                            },),
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
                              builder: (context, date, _) {
                                return InkWell(
                                  onTap: () async {
                                    DateTime? dt = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate:  DateTime(3000));
                                    if(dt!=null) {
                                      bloc.startDate.value = dt.toString().split(" ").first.split("-").reversed.join("-");
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
                                        Text(date ?? "Select Date", style: const TextStyle(
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
                            valueListenable: bloc.dueDate,
                            builder: (context, dueDate, child) {
                            return AppDropdown(
                                items: const [
                                  DropdownMenuItem(value: "yes",child: Text("Yes")),
                                  DropdownMenuItem(value: "no",child: Text("No")),
                                ],
                                onChanged: (value) {
                                  bloc.dueDate.value = value;
                                },
                                value: bloc.dueDate.value,
                                hintText: "Select due date",
                                validator: (value) {
                                  if(value == null){
                                    return "Please select due date";
                                  }
                                  return null;
                                },
                            );
                          },),
                          ValueListenableBuilder(
                            valueListenable: bloc.dueDate,
                            builder: (context, dueDate, child) {
                              if(dueDate == null){
                                return Offstage();
                              }
                              if(dueDate == "yes"){
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    const SizedBox(height: 20),
                                    const Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Text("End Date", style: TextStyle(fontSize: 13)),
                                    ),
                                    const SizedBox(height: 5),
                                    ValueListenableBuilder(
                                        valueListenable: bloc.endDate,
                                        builder: (context, date, _) {
                                          return InkWell(
                                            onTap: () async {
                                              DateTime? dt = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate:  DateTime(3000),);
                                              if(dt!=null) {
                                                bloc.endDate.value = dt.toString().split(" ").first.split("-").reversed.join("-");
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
                                                  Text(date ?? "Select Date", style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                  ),),
                                                ],
                                              ),
                                            ),
                                          );
                                        }
                                    ),
                                  ],
                                );
                              }
                              return Offstage();
                            },),
                          const SizedBox(height: 20),
                          AppTextField(
                            controller: bloc.duration,
                            title: "Duration (In Minutes)",
                            hint: "Duration",
                            validate: true,
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 20),
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
                          ValueListenableBuilder(
                            valueListenable: bloc.allTaskLabelData,
                            builder: (context, allTaskLabelData, child) {
                              if(allTaskLabelData == null){
                                return AppDropdown(
                                  items: const [],
                                  onChanged: (value) {
                                    bloc.taskLabel.value = value.toString();
                                  },
                                  value: null,
                                  hintText: "Select",
                                );
                              }
                              return AppDropdown(
                                items: allTaskLabelData.map((e) => DropdownMenuItem(value: e['id'].toString(),child: Text(e['name']),)).toList(),
                                onChanged: (value) {
                                  bloc.taskLabel.value = value.toString();
                                },
                                value: bloc.taskLabel.value,
                                hintText: "Select",
                                validator: (value) {
                                  if(value == null){
                                    return "Please select task label";
                                  }
                                  return null;
                                },
                              );
                            },),
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
                          ValueListenableBuilder(
                            valueListenable: bloc.priority,
                            builder: (context, priority, child) {
                            return AppDropdown(
                              items: const [
                                DropdownMenuItem(value: "medium",child: Text("Medium")),
                                DropdownMenuItem(value: "high",child: Text("High")),
                                DropdownMenuItem(value: "veryhigh",child: Text("Very High")),
                                DropdownMenuItem(value: "low",child: Text("Low")),
                              ],
                              onChanged: (value) {
                                bloc.priority.value = value;
                              },
                              value: bloc.priority.value,
                              hintText: "Select",
                              validator: (value) {
                                if(value == null){
                                  return "Please Select Priority";
                                }
                                return null;
                              },
                            );
                          },),

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
                          ValueListenableBuilder(
                            valueListenable: bloc.status,
                            builder: (context, status, child) {
                              return AppDropdown(
                                items: const [
                                  DropdownMenuItem(value: "complete",child: Text("Complete")),
                                  DropdownMenuItem(value: "incomplete",child: Text("Incomplete")),
                                  DropdownMenuItem(value: "doing",child: Text("Doing")),
                                ],
                                onChanged: (value) {
                                  bloc.status.value = value;
                                },
                                value: bloc.status.value,
                                hintText: "Select",
                                validator: (value) {
                                  if(value == null){
                                    return "Please Select Status";
                                  }
                                  return null;
                                },
                              );
                            },),
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
                          ValueListenableBuilder(
                            valueListenable: bloc.billing,
                            builder: (context, billing, child) {
                            return AppDropdown(
                              items: const [
                                DropdownMenuItem(value: "yes",child: Text("Yes")),
                                DropdownMenuItem(value: "no",child: Text("No")),
                              ],
                              onChanged: (value) {
                                bloc.billing.value = value;
                              },
                              value: bloc.billing.value,
                              hintText: "Select",
                              validator: (value) {
                                if(value == null){
                                  return "Please Select Billing";
                                }
                                return null;
                              },
                            );
                          },),
                          ValueListenableBuilder(
                            valueListenable: bloc.billing,
                            builder: (context, billing, child) {
                              if(billing == null){
                                return Offstage();
                              }
                              if(billing == "yes"){
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    const SizedBox(height: 20),
                                    AppTextField(
                                        controller: bloc.amount,
                                        title: "Amount",
                                      validate: true,
                                    ),
                                  ],
                                );
                              }
                              return Offstage();
                            },),
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
                          ValueListenableBuilder(
                            valueListenable: bloc.repeatType,
                            builder: (context, repeatType, child) {
                              return AppDropdown(
                                items: const [
                                  DropdownMenuItem(value: "year",child: Text("Year")),
                                  DropdownMenuItem(value: "month",child: Text("Month")),
                                  DropdownMenuItem(value: "weeks",child: Text("Weeks")),
                                  DropdownMenuItem(value: "days",child: Text("Days")),
                                ],
                                onChanged: (value) {
                                  bloc.repeatType.value = value;
                                },
                                value: bloc.repeatType.value,
                                hintText: "Select",
                                validator: (value) {
                                  if(value == null){
                                    return "Please Select Repeat Type";
                                  }
                                  return null;
                                },
                              );
                            },),
                          ValueListenableBuilder(
                            valueListenable: bloc.repeatType,
                            builder: (context, repeatType, child) {
                              if(repeatType == null){
                                return Offstage();
                              }
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const SizedBox(height: 20),
                                  AppTextField(
                                    controller: bloc.timesOfRepeat,
                                    title: "Times of repeat",
                                    validate: true,
                                    keyboardType: TextInputType.number,
                                  ),
                                  const SizedBox(height: 20),
                                  AppTextField(
                                    controller: bloc.repeatCycle,
                                    title: "Repeat Cycle",
                                    validate: true,
                                    keyboardType: TextInputType.number,
                                  ),
                                ],
                              );
                            },),
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
                          ValueListenableBuilder(
                            valueListenable: bloc.dependent,
                            builder: (context, dependent, child) {
                            return AppDropdown(
                              items: const [
                                // DropdownMenuItem(value: "yes",child: Text("Yes")),
                                DropdownMenuItem(value: "no",child: Text("No")),
                              ],
                              onChanged: (value) {
                                bloc.dependent.value = value;
                              },
                              value: bloc.dependent.value,
                              hintText: "Select",
                              validator: (value) {
                                if(value == null){
                                  return "Please Select Dependent";
                                }
                                return null;
                              },
                            );
                          },),
                          const SizedBox(
                            height: 20,
                          ),
                          AppButton(
                            title: "Submit",
                            onTap: () {
                              if (formKey.currentState!.validate()) {
                                bloc.addTask(context);
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
