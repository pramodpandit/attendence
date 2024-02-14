import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:office/ui/project/menus/logs.dart';

import '../profile/menus/basic_info.dart';
import '../project/menus/project_files.dart';
import '../project/menus/project_links.dart';
import '../project/menus/project_members.dart';
import '../project/menus/project_notes_list.dart';
import '../project/menus/project_overview.dart';

class LeadDetails extends StatefulWidget {
  const LeadDetails({Key? key}) : super(key: key);

  @override
  State<LeadDetails> createState() => _LeadDetailsState();
}

class _LeadDetailsState extends State<LeadDetails> {
  ValueNotifier<int> selectedMenuIndex = ValueNotifier(0);
  List<String> projectMenus = [
    "Overview",
    "Files",
    "Notes",
    "Links",
    "Members",
    "Logs/Follow"
  ];
  List<Widget> projectMenusWidgets = [
    const ProjectOverview(),
    const ProjectFiles(),
    const ProjectNotesList(),
    const ProjectLinks(),
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
                height: 190,
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
                      "Lead Details",
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
                      height: 120,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 25),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 0,
                                blurRadius: 5,
                                color: Colors.black.withOpacity(0.1))
                          ]),
                      // ignore: prefer_const_constructors
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5,),
                          const SizedBox(height: 10,),
                          const DetailsContainer(
                            title:"Jay singh",
                            //"${details["first_name"]!=null?details["first_name"]:""} ${details["middle_name"]!=null?details["middle_name"]:""} ${details["last_name"]!=null?details["last_name"]:""}",
                            heading: 'Created By', isHtml: false,
                          ),
                          Dash(
                            dashColor: Colors.grey.withOpacity(0.3),
                            dashGap: 3,
                            length: 270.w,
                          ),
                          const SizedBox(height: 10,),
                          const DetailsContainer(
                            title:"2023-06-15",
                            //"${details["first_name"]!=null?details["first_name"]:""} ${details["middle_name"]!=null?details["middle_name"]:""} ${details["last_name"]!=null?details["last_name"]:""}",
                            heading: 'Created At', isHtml: false,
                          ),
                          Dash(
                            dashColor: Colors.grey.withOpacity(0.3),
                            dashGap: 3,
                            length: 270.w,
                          ),
                          const SizedBox(height: 10,),
                          const DetailsContainer(
                            title:"Jay",
                            //"${details["first_name"]!=null?details["first_name"]:""} ${details["middle_name"]!=null?details["middle_name"]:""} ${details["last_name"]!=null?details["last_name"]:""}",
                            heading: 'Client Name', isHtml: false,
                          ),
                          Dash(
                            dashColor: Colors.grey.withOpacity(0.3),
                            dashGap: 3,
                            length: 270.w,
                          ),
                          const SizedBox(height: 10,),
                          const DetailsContainer(
                            title:"Open",
                            //"${details["first_name"]!=null?details["first_name"]:""} ${details["middle_name"]!=null?details["middle_name"]:""} ${details["last_name"]!=null?details["last_name"]:""}",
                            heading: 'Status', isHtml: false,
                          ),
                        ],
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
