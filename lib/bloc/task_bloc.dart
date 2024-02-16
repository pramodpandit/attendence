import 'package:flutter/material.dart';
import 'package:office/bloc/bloc.dart';
import 'package:office/ui/task/task_screen.dart';

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
}