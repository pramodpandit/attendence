import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:office/bloc/bloc.dart';
import 'package:office/data/model/api_response.dart';
import 'package:office/data/repository/task_repo.dart';
import 'package:office/ui/task/task_screen.dart';
import 'package:office/utils/message_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/model/Task_list.dart';
import '../utils/message_handler.dart';

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

  ValueNotifier<List?> allTaskData = ValueNotifier(null);
  ValueNotifier data = ValueNotifier(null);
  ValueNotifier<int> isLoadingDownload = ValueNotifier(-1);

  fetchTaskDetails(int id,String common) async{
    try{
      // isUserDetailLoad.value = true;
      var result = await _repo.fetchAllTaskDetail(id);
      if(result.status && result.data != null){
        data.value = result.data['totaldata']['task_details']['user'];
       allTaskData.value =( result.data['totaldata']['task_details'][common]as List).reversed.toList();
        print('task detail data: ${allTaskData.value}');
      }
    }catch (e, s) {
      print(e);
      print(s);
    }
  }
  TextEditingController fileName = TextEditingController();
  TextEditingController filepath = TextEditingController();
  File? image;
  ValueNotifier<bool> addfileLoading = ValueNotifier(false);
  StreamController<String?> fileStream = StreamController.broadcast();

  Future<void> addFiles(int id,String private,) async {
    try {

      SharedPreferences _pref = await SharedPreferences.getInstance();

      Map<String, dynamic> data = {
        "user_id": _pref.getString('uid'),
        "task_id":id,
        "file_name":fileName.text,
        "privates":private,
        "files": await MultipartFile.fromFile(image!.path,
             filename: image!.path.split('/').last)
      };
      addfileLoading.value = true;
      var result = await _repo.Add('tasks/add_files',data,true);
      if(result.status == true){
        fileStream.sink.add('streamFiles');
      }else{
        showMessage(MessageType.error("Something went wrong"));
      }

    } catch (e, s) {
      debugPrint("$e");
      debugPrint("$s");
    } finally {
      addfileLoading.value = false;
    }
  }

  TextEditingController comment = TextEditingController();
  ValueNotifier<bool> addcommentLoading = ValueNotifier(false);
  StreamController<String?> commentStream= StreamController.broadcast();

  Future<void> addComment(int id,String private,) async {
    try {

      SharedPreferences _pref = await SharedPreferences.getInstance();

      Map<String, dynamic> data = {
        "user_id": _pref.getString('uid'),
        "task_id":id,
        "comment":comment.text,
        "privates":private,
      };
      addcommentLoading.value = true;
      var result = await _repo.Add('tasks/post-add-comment',data,false);
      if(result.status == true){
        commentStream.sink.add('commentStream');
      }else{
        showMessage(MessageType.error("Something went wrong"));
      }

    } catch (e, s) {
      debugPrint("$e");
      debugPrint("$s");
    } finally {
      addcommentLoading.value = false;
    }
  }

  TextEditingController notes = TextEditingController();
  ValueNotifier<bool> addnotesLoading = ValueNotifier(false);
  StreamController<String?> notesStream= StreamController.broadcast();

  Future<void> addNotes(int id,String private,) async {
    try {
      SharedPreferences _pref = await SharedPreferences.getInstance();
      Map<String, dynamic> data = {
        "user_id": _pref.getString('uid'),
        "task_id":id,
        "title":notes.text,
        "private":private,
      };
      addnotesLoading.value = true;
      var result = await _repo.Add('tasks/add_notes',data,false);
      if(result.status == true){
        notesStream.sink.add('notesStream');
      }else{
        showMessage(MessageType.error("Something went wrong"));
      }
    } catch (e, s) {
      debugPrint("$e");
      debugPrint("$s");
    } finally {
      addnotesLoading.value = false;
    }
  }
  ValueNotifier<List?> employelist = ValueNotifier(null);
  ValueNotifier<String?> updateemployelist = ValueNotifier(null);

  fetchexpensePaymentType() async{
    try{
      // isUserDetailLoad.value = true;
      var result = await _repo.getemployeedata();
      if(result.status && result.data != null){
        employelist.value = result.data["data1"];
        print("the all projects are : ${employelist.value}");
      }
    }catch (e, s) {
      print(e);
      print(s);
    }
  }
  TextEditingController HourLogged = TextEditingController();
  TextEditingController memo = TextEditingController();
  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay.now();
  ValueNotifier<bool> addtimesheetLoading = ValueNotifier(false);
  StreamController<String?> timesheetStream= StreamController.broadcast();

  Future<void> addTimeSheet(int id,) async {
    try {
      SharedPreferences _pref = await SharedPreferences.getInstance();
      Map<String, dynamic> data = {
        "user_id": _pref.getString('uid'),
        "task_id":id,
        "employee_id":updateemployelist.value,
        "start_time":'${startTime.hour}:${startTime.minute}:00',
        "end_time":'${endTime.hour}:${endTime.minute}:00',
        "hours_logged":HourLogged.text,
        "memo":memo.text
      };
      addtimesheetLoading.value = true;
      var result = await _repo.Add('tasks/add_timesheet',data,false);
      if(result.status == true){
        timesheetStream.sink.add('timesheetStream');
      }else{
        showMessage(MessageType.error("Something went wrong"));
      }
    } catch (e, s) {
      debugPrint("$e");
      debugPrint("$s");
    } finally {
      addtimesheetLoading.value = false;
    }
  }

}