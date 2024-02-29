import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:office/bloc/bloc.dart';
import 'package:office/data/model/api_response.dart';
import 'package:office/ui/task/task_screen.dart';
import 'package:office/utils/message_handler.dart';

import '../data/model/Task_list.dart';
import '../data/repository/task_repo.dart';

class taskBloc extends Bloc{

  late TaskRepositary _repo;
  taskBloc(this._repo, );
  ValueNotifier<int> selectedMenuIndex = ValueNotifier(0);
  List<String> taskMenus = [
    "All",
    "Pending",
    "Ongoing",
    "Completed",
  ];
  List<Widget> profileMenusWidgets = [
    const AllTask(),
    const pendingTask(),
    const ongoingTask(),
    const completedTask(),
  ];
  ValueNotifier<bool> isUserDetailLoad = ValueNotifier(false);
  List<TaskData> feedbackData = [];
  List<TaskData> ongoing = [];
  fetchTaskData() async{
    try{
      isUserDetailLoad.value = true;
      var result = await _repo.getTaskData();
      if(result.status && result.data != null){
        feedbackData = result.data!.reversed.toList();

      }
    }catch (e, s) {
      print(e);
      print(s);
    }finally{
      isUserDetailLoad.value = false;
    }
  }

  List<String> TaskCategory = [
    'Open',
    'Dead',
    'Converted',
  ];
  selectStatus(data) {
    TaskCategory = data;
  }
  List<String> Project = [
    'Open',
    'Dead',
    'Converted',
  ];
  selectProject(data) {
    Project = data;
  }
  List<String> Department = [
    'Open',
    'Dead',
    'Converted',
  ];
  selectDepartment(data) {
    Project = data;
  }
  List<String> Employee = [
    'Open',
    'Dead',
    'Converted',
  ];
  selectEmployee(data) {
    Project = data;
  }

// add task
//   all data
  ValueNotifier<List?> allTaskCategory = ValueNotifier(null);
  ValueNotifier<List?> allProjectsData = ValueNotifier(null);
  ValueNotifier<List?> allEmployeesData = ValueNotifier(null);
  ValueNotifier<List?> allDepartmentData = ValueNotifier(null);
  ValueNotifier<List?> allTaskLabelData = ValueNotifier(null);
//   all data end
  ValueNotifier<String?> taskCategory = ValueNotifier(null);
  ValueNotifier<String?> project = ValueNotifier(null);
  ValueNotifier<String?> employee = ValueNotifier(null);
  ValueNotifier<String?> department = ValueNotifier(null);
  TextEditingController title = TextEditingController();
  ValueNotifier<String?> startDate = ValueNotifier(null);
  ValueNotifier<String?> dueDate = ValueNotifier(null);
  ValueNotifier<String?> endDate = ValueNotifier(null);
  TextEditingController duration = TextEditingController();
  TextEditingController description = TextEditingController();
  ValueNotifier<String?> taskLabel = ValueNotifier(null);
  ValueNotifier<String?> priority = ValueNotifier(null);
  ValueNotifier<String?> status = ValueNotifier(null);
  ValueNotifier<String?> billing = ValueNotifier(null);
  TextEditingController amount = TextEditingController();
  ValueNotifier<String?> repeatType = ValueNotifier(null);
  TextEditingController timesOfRepeat = TextEditingController();
  TextEditingController repeatCycle = TextEditingController();
  ValueNotifier<String?> dependent = ValueNotifier(null);
  ValueNotifier<String?> projectTasks = ValueNotifier(null);

  getAllTaskCategoryData () async{
    try{
      ApiResponse2 res = await _repo.fetchAllTaskCategoryData();
      allTaskCategory.value = res.data;
    }catch(e){
      allTaskCategory.value = [];
      showMessage(const MessageType.error("Some error occurred! Please try again!"));
    }
  }
  getAllProjectsData () async{
    try{
      ApiResponse2 res = await _repo.fetchAllProjectsData();
      allProjectsData.value = res.data;
    }catch(e){
      allProjectsData.value = [];
      showMessage(const MessageType.error("Some error occurred! Please try again!"));
    }
  }
  getEmployeesDataByProjectId (String projectId) async{
    try{
      ApiResponse2 res = await _repo.fetchEmployeesDataByProjectId(projectId);
      employee.value = null;
      allEmployeesData.value = res.data;
    }catch(e){
      employee.value = null;
      allEmployeesData.value = [];
      showMessage(const MessageType.error("Some error occurred! Please try again!"));
    }
  }
  getAllDepartmentData () async{
    try{
      ApiResponse2 res = await _repo.fetchAllDepartmentData();
      allDepartmentData.value = res.data;
    }catch(e){
      allDepartmentData.value = [];
      showMessage(const MessageType.error("Some error occurred! Please try again!"));
    }
  }
  getAllTaskLabelData () async{
    try{
      ApiResponse2 res = await _repo.fetchAllTaskLabelData();
      allTaskLabelData.value = res.data;
    }catch(e){
      allTaskLabelData.value = [];
      showMessage(const MessageType.error("Some error occurred! Please try again!"));
    }
  }

  addTask() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    Map<String,dynamic> data = {
      "user_id" : pref.getString("uid"),
      "t_cat_id" : taskCategory.value,
      "project_id" : project.value,
      "employee_id" : employee.value,
      "department_id" : department.value,
      "title" : title.text,
      "start_date" : startDate.value,
      "due_date" : dueDate.value,
      "duration" : duration.text,
      "description" : description.text,
      "t_label_id" : taskLabel.value,
      "priority" : priority.value,
      "status" : status.value,
      "billing" : billing.value,
      "repeatType" : repeatType.value,
      "depentent" : dependent.value,
    };
    if(dueDate.value == "yes"){
      data.addAll({
        "due_date1" : endDate.value,
      });
    }
    if(billing.value == "yes"){
      data.addAll({
        "amount" : amount.text
      });
    }
    if(repeatType.value != null){
      data.addAll({
        "time_of_recept" : timesOfRepeat.text,
        "recept_cycle" : repeatCycle.text
      });
    }
    try{
      ApiResponse2 res = await _repo.addTaskFunction(data);
      if(res.status){
        print(res.data);
      }
    }catch(e){
      print(e);
    }
  }

}