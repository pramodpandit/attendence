import 'package:flutter/material.dart';
import 'package:office/bloc/bloc.dart';
import 'package:office/data/repository/project_repo.dart';

class ProjectBloc extends Bloc {

  final ProjectRepository repo;

  ProjectBloc(this.repo);

  ValueNotifier<String> selectedProjects = ValueNotifier("doing");
  ValueNotifier<List?> allProjects = ValueNotifier(null);
  ValueNotifier allprojectDetail = ValueNotifier(null);
  ValueNotifier<List?> projectNotes = ValueNotifier(null);
  ValueNotifier<List?> projectfile = ValueNotifier(null);
  ValueNotifier<List?> projectlink = ValueNotifier(null);
  ValueNotifier<List?> projectmember = ValueNotifier(null);
  ValueNotifier<List?> projectcredentails = ValueNotifier(null);
  ValueNotifier<List?> projectcomment = ValueNotifier(null);

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
  fetchProjectsDetails(int type) async{
    try{
      // isUserDetailLoad.value = true;
      var result = await repo.fetchAllProjectsDetail(type);
      if(result.status && result.data != null){
        allprojectDetail.value = result.data["data"]["project_details"];
        projectNotes.value = result.data["data"]["project_notes"];
        projectfile.value = result.data["data"]["project_file"];
        projectlink.value = result.data["data"]["project_links"];
        projectmember.value = result.data["data"]["project_members"];
        projectcredentails.value = result.data["data"]["project_credentials"];
        projectcomment.value = result.data["data"]["project_comment"];
        print("the all projects are : ${allprojectDetail.value}");
      }
    }catch (e, s) {
      print(e);
      print(s);
    }
  }
}
