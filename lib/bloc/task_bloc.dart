import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:office/bloc/bloc.dart';
import 'package:office/ui/task/task_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/model/Task_list.dart';
import '../data/repository/task_repo.dart';
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
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  ValueNotifier<DateTime?> startDate = ValueNotifier(DateTime.now());
  updateDateStart(DateTime value) => startDate.value = value;
  ValueNotifier<DateTime?> endDate = ValueNotifier(DateTime.now());
  updateEndDate(DateTime value) => endDate.value = value;

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
        print('task detail data: ${data.value}');
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
}