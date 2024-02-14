import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../profile/menus/basic_info.dart';

class ProjectTask extends StatefulWidget {
  const ProjectTask({Key? key}) : super(key: key);

  @override
  State<ProjectTask> createState() => _ProjectTaskState();
}

class _ProjectTaskState extends State<ProjectTask> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
                itemCount: 10,
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 10),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context,index){
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
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
                          borderRadius: const BorderRadius.only(topRight: Radius.circular(10.0),bottomRight:Radius.circular(10.0),)
                      ),
                      child: IntrinsicHeight(
                        child: Row(
                          children: [
                            Container(
                              width: 3,
                              decoration: const BoxDecoration(
                                  color:Color(0xFF009FE3),
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0),bottomLeft:Radius.circular(10.0))
                              ),
                            ),
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
                                    Text(
                                      "11:00 Am - 12:00 Pm",
                                      // "The prevalence of trauma related disorders in children and adolescents affected by forest fires.",
                                      style: TextStyle(
                                          fontSize: 8,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black54
                                      ),),
                                    SizedBox(height: 10,),
                                    Text(
                                      // "11:00 Am - 12:00 Pm",
                                      "The prevalence of trauma related disorders in children and adolescents affected by forest fires.",
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black54
                                      ),),
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
                                    SizedBox(height: 10,),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: 40,
            width: 90,
            child: FloatingActionButton.extended(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0))
                ),
                onPressed: () async{
                },
                backgroundColor: const  Color(0xFF009FE3),
                label: AnimatedSwitcher(
                  duration: const Duration(seconds: 1),
                  transitionBuilder: (Widget child, Animation<double> animation) =>
                      FadeTransition(
                        opacity: animation,
                        child: SizeTransition(
                          sizeFactor: animation,
                          axis: Axis.horizontal,
                          child: child,
                        ),
                      ),
                  child: const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 5.0),
                        child: Icon(
                          PhosphorIcons.plus_circle_fill,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Task",
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                )),
          ),
          SizedBox(height: 30,)
        ],
      ),
    );
  }
}
