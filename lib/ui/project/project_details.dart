import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:office/ui/project/menus/project_comment.dart';
import 'package:office/ui/project/menus/project_credentials.dart';
import 'package:office/ui/project/menus/project_files.dart';
import 'package:office/ui/project/menus/project_links.dart';
import 'package:office/ui/project/menus/project_members.dart';
import 'package:office/ui/project/menus/project_notes_list.dart';
import 'package:office/ui/project/menus/project_overview.dart';
import 'package:office/ui/project/menus/project_task.dart';
import 'package:office/ui/project/menus/project_timesheet.dart';
import 'package:office/ui/project/projectScreen.dart';
import 'package:provider/provider.dart';

import '../../bloc/project_bloc.dart';
import '../../data/model/user.dart';
import '../../data/repository/project_repo.dart';
import '../widget/stack_user_list.dart';

class ProjectDetails extends StatefulWidget {
  final User user;
  final data;
  const ProjectDetails({Key? key, this.data, required this.user}) : super(key: key);

  @override
  State<ProjectDetails> createState() => _ProjectDetailsState(data,user);
}

class _ProjectDetailsState extends State<ProjectDetails> {
  final User user;
  final dataa;
  _ProjectDetailsState(this.dataa, this.user);
  ValueNotifier<int> selectedMenuIndex = ValueNotifier(0);
  List<String> projectMenus = [
    "Overview",
    "Task",
    "Files",
    "Comment",
    // "Timesheet",
    "Notes",
    "Credentials",
    "Links",
    "Members"
  ];
  List<Widget> projectMenusWidgets = [

  ];
  List imageList =[];



  selectMenu(int index){
    selectedMenuIndex.value =index;
  }
  late ProjectBloc bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    projectMenusWidgets=[
     ProjectOverview(data: dataa,user: user,),
      ProjectTask(data:dataa),
      ProjectFiles(data: dataa),
      ProjectComments(data: dataa),
      // const ProjectTimeSheet(),
      ProjectNotesList(data:dataa),
      ProjectCredentialList(data:dataa),
      ProjectLinks(data: dataa),
      ProjectMembers(data: dataa,)
    ];
    bloc = ProjectBloc(context.read<ProjectRepository>());
    bloc.fetchProjectsDetails(widget.data['id']);
    imageList = dataa["user_pic"]["user_p"];
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
                      "Project Details",
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
                          const SizedBox(height: 10,),
                          Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${widget.data['name']}',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Icon(PhosphorIcons.trend_up,size: 16,),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text('${widget.data['status']}',style: TextStyle(fontSize: 11,color: Colors.green.shade400),)
                                    ],
                                  ),
                                  const SizedBox(height: 5,),
                                  Row(
                                    children: [
                                      const Icon(PhosphorIcons.timer,size: 16,),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text('${DateFormat.yMMMM().format(DateTime.parse(widget.data['created_date']))}',style: TextStyle(fontSize: 11,color: Colors.redAccent.withOpacity(0.9)),)
                                    ],
                                  ),
                                  const SizedBox(height: 8,),
                                   StackedUserList(
                                    totalUser: imageList.length,
                                    users: imageList.map((e) => 'https://freeze.talocare.co.in/public/$e').toList(),
                                    numberOfUsersToShow: imageList.length<5?imageList.length:5,
                                    avatarSize: 18,
                                  )
                                ],
                              ),
                              const Spacer(),
                              DashedCircularProgressBar.square(
                                dimensions: 80,
                                progress: double.parse(widget.data["progress"].toString()),
                                startAngle: 225,
                                sweepAngle: 270,
                                foregroundColor: Colors.blue,
                                backgroundColor: Color(0xffeeeeee),
                                foregroundStrokeWidth: 10,
                                backgroundStrokeWidth: 10,
                                animation: true,
                                seekSize: 8,
                                seekColor: Colors.white,
                                child: Center(child: Text('${widget.data['progress'].toString()}%',
                                  style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),)),
                              ),
                            ],
                          ),
                          const Divider(),
                           const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TaskContent(tittle: '15', icon: Icons.offline_bolt_outlined,),
                              TaskContent(tittle: '5', icon: Icons.error_outline,color: Colors.blue,),
                              TaskContent(tittle: '5', icon: Icons.check_circle_outline,color: Colors.green,),
                              TaskContent(tittle: '5', icon: Icons.cancel_outlined,color: Colors.red,),
                            ],
                          ),
                          const SizedBox(height: 10,)
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
