import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:office/ui/project/menus/logs.dart';
import 'package:office/ui/project/menus/project_files.dart';
import 'package:office/ui/project/menus/project_overview.dart';

import '../project/menus/project_comment.dart';
import '../project/menus/project_credentials.dart';
import '../project/menus/project_links.dart';
import '../project/menus/project_members.dart';
import '../project/menus/project_notes_list.dart';

class TaskDetails extends StatefulWidget {
  const TaskDetails({Key? key}) : super(key: key);

  @override
  State<TaskDetails> createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {
  ValueNotifier<int> selectedMenuIndex = ValueNotifier(0);
  List<String> projectMenus = [
    "Overview",
    "Files",
    "Links",
    "Comment",
    "Notes",
    "Credentials",
    "Members",
    "Logs/Follow"
  ];
  List<Widget> projectMenusWidgets = [
    const ProjectOverview(),
    const ProjectFiles(),
    const ProjectLinks(),
    const ProjectComments(),
    const ProjectNotesList(),
    const ProjectCredentialList(),
    const ProjectMembers(),
    const Logs(),
  ];

  selectMenu(int index){
    selectedMenuIndex.value =index;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 130,
                width: 1.sw,
                decoration: const BoxDecoration(
                    color: Color(0xFF009FE3),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30))
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 56,),
                    Text(
                      "Task Details",
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
              Center(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 105,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  blurRadius: 3,
                                  spreadRadius: 2)
                            ],
                            borderRadius: const BorderRadius.all(Radius.circular(10.0))
                        ),
                        child: IntrinsicHeight(
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.transparent,
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 10,),
                                      Row(mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text("In Process",
                                            style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.blue
                                            ),),
                                        ],),
                                      Expanded(
                                        child: Text(
                                          "UI/UX Team Huddle",
                                          // "The prevalence of trauma related disorders in children and adolescents affected by forest fires.",
                                          style: TextStyle(
                                              fontFamily: "Poppins",
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black
                                          ),),
                                      ),
                                      SizedBox(height: 10,),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            height: 55,
            padding: const EdgeInsets.only(top: 18),
            child: ValueListenableBuilder(
                valueListenable:selectedMenuIndex,
                builder: (context, snapshot, __) {
                  return ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      scrollDirection: Axis.horizontal,
                      itemCount: projectMenus.length,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                selectMenu(index);
                                // userDetailsNotifier.selectMenu(index);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: selectedMenuIndex.value ==
                                        index
                                        ? const Color(0xFF009FE3)
                                        : Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(
                                        10.0)),
                                child: Text(
                                  projectMenus[index],
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Poppins",
                                      color: selectedMenuIndex.value ==
                                          index
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            )
                          ],
                        );
                      });
                }
            ),
          ),
          Expanded(
            child: Container(
              width: 1.sw,
              height: 0.8.sh,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ValueListenableBuilder(
                valueListenable: selectedMenuIndex,
                builder: (BuildContext context, int index, Widget? child) {
                  // print(index);
                  return projectMenusWidgets[index];
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
