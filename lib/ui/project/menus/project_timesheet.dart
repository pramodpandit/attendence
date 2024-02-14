import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../profile/menus/basic_info.dart';

class ProjectTimeSheet extends StatefulWidget {
  const ProjectTimeSheet({Key? key}) : super(key: key);

  @override
  State<ProjectTimeSheet> createState() => _ProjectTimeSheetState();
}

class _ProjectTimeSheetState extends State<ProjectTimeSheet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded  (
            child: ListView.builder(
                physics: const ScrollPhysics(),
                itemCount:10,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 3,
                                spreadRadius: 2)
                          ],
                          color: Colors.white,
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                        ),
                        child:  Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 5,),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Aarvy Office",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 10,),
                            Dash(
                              dashColor: Colors.grey.withOpacity(0.3),
                              dashGap: 3,
                              length: 320.w,
                            ),
                            const SizedBox(height: 10,),
                            const DetailsContainer(
                              title:"63454533",
                              //"${details["first_name"]!=null?details["first_name"]:""} ${details["middle_name"]!=null?details["middle_name"]:""} ${details["last_name"]!=null?details["last_name"]:""}",
                              heading: 'Employee', isHtml: false,
                            ),
                            Dash(
                              dashColor: Colors.grey.withOpacity(0.3),
                              dashGap: 3,
                              length: 320.w,
                            ),
                            const SizedBox(height: 10,),
                            const DetailsContainer(
                              title:"2023-06-15",
                              //"${details["first_name"]!=null?details["first_name"]:""} ${details["middle_name"]!=null?details["middle_name"]:""} ${details["last_name"]!=null?details["last_name"]:""}",
                              heading: 'Start Time', isHtml: false,
                            ),
                            Dash(
                              dashColor: Colors.grey.withOpacity(0.3),
                              dashGap: 3,
                              length: 320.w,
                            ),
                            const SizedBox(height: 10,),
                            const DetailsContainer(
                              title:"2023-06-15",
                              //"${details["first_name"]!=null?details["first_name"]:""} ${details["middle_name"]!=null?details["middle_name"]:""} ${details["last_name"]!=null?details["last_name"]:""}",
                              heading: 'End Time', isHtml: false,
                            ),
                            Dash(
                              dashColor: Colors.grey.withOpacity(0.3),
                              dashGap: 3,
                              length: 320.w,
                            ),
                            const SizedBox(height: 10,),
                            const DetailsContainer(
                              title:"yes",
                              //"${details["first_name"]!=null?details["first_name"]:""} ${details["middle_name"]!=null?details["middle_name"]:""} ${details["last_name"]!=null?details["last_name"]:""}",
                              heading: 'Memo', isHtml: false,
                            ),
                            Dash(
                              dashColor: Colors.grey.withOpacity(0.3),
                              dashGap: 3,
                              length: 320.w,
                            ),
                            const SizedBox(height: 10,),
                            const DetailsContainer(
                              title:"",
                              //"${details["first_name"]!=null?details["first_name"]:""} ${details["middle_name"]!=null?details["middle_name"]:""} ${details["last_name"]!=null?details["last_name"]:""}",
                              heading: 'Hour Logged', isHtml: false,
                            ),
                            Dash(
                              dashColor: Colors.grey.withOpacity(0.3),
                              dashGap: 3,
                              length: 320.w,
                            ),
                            const SizedBox(height: 10,),
                            const DetailsContainer(
                              title:"",
                              //"${details["first_name"]!=null?details["first_name"]:""} ${details["middle_name"]!=null?details["middle_name"]:""} ${details["last_name"]!=null?details["last_name"]:""}",
                              heading: 'Action', isHtml: false,
                            ),
                            const SizedBox(height: 10,),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: 40,
            width: 130,
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
                        "TimeSheet",
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
