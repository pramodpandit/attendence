import 'package:flutter/material.dart';
import 'package:office/bloc/bloc.dart';
import 'package:office/data/repository/project_repo.dart';

class ProjectBloc extends Bloc {
  final ProjectRepository repo;

  ProjectBloc(this.repo);

  ValueNotifier<String> selectedProjects = ValueNotifier("todo");
  ValueNotifier<List?> allProjects = ValueNotifier(null);

  fetchProjects(String type) async{
    try{
      // isUserDetailLoad.value = true;
      var result = await repo.fetchAllProjects();
      if(result.status && result.data != null){
        allProjects.value = result.data["data"]["project"][type];
        print("the all projects are : ${allProjects.value}");
      }
    }catch (e, s) {
      print(e);
      print(s);
    }
  }
}
