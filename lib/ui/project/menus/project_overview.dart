import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../profile/menus/basic_info.dart';

class ProjectOverview extends StatefulWidget {
  const ProjectOverview({Key? key}) : super(key: key);

  @override
  State<ProjectOverview> createState() => _ProjectOverviewState();
}

class _ProjectOverviewState extends State<ProjectOverview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
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
                            fontSize: 15
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Dash(
                    dashColor: Colors.grey.withOpacity(0.3),
                    dashGap: 3,
                    length: 340.w,
                  ),
                  const SizedBox(height: 10,),
                  const DetailsContainer(
                    title:"63454533",
                    //"${details["first_name"]!=null?details["first_name"]:""} ${details["middle_name"]!=null?details["middle_name"]:""} ${details["last_name"]!=null?details["last_name"]:""}",
                    heading: 'Short Code', isHtml: false,
                  ),
                  Dash(
                    dashColor: Colors.grey.withOpacity(0.3),
                    dashGap: 3,
                    length: 340.w,
                  ),
                  const SizedBox(height: 10,),
                  const DetailsContainer(
                    title:"2023-06-15",
                    //"${details["first_name"]!=null?details["first_name"]:""} ${details["middle_name"]!=null?details["middle_name"]:""} ${details["last_name"]!=null?details["last_name"]:""}",
                    heading: 'Start date', isHtml: false,
                  ),
                  Dash(
                    dashColor: Colors.grey.withOpacity(0.3),
                    dashGap: 3,
                    length: 340.w,
                  ),
                  const SizedBox(height: 10,),
                  const DetailsContainer(
                    title:"yes",
                    //"${details["first_name"]!=null?details["first_name"]:""} ${details["middle_name"]!=null?details["middle_name"]:""} ${details["last_name"]!=null?details["last_name"]:""}",
                    heading: 'Deadline Status', isHtml: false,
                  ),
                  Dash(
                    dashColor: Colors.grey.withOpacity(0.3),
                    dashGap: 3,
                    length: 340.w,
                  ),
                  const SizedBox(height: 10,),
                  const DetailsContainer(
                    title:"2023-06-22",
                    //"${details["first_name"]!=null?details["first_name"]:""} ${details["middle_name"]!=null?details["middle_name"]:""} ${details["last_name"]!=null?details["last_name"]:""}",
                    heading: 'Deadline Date', isHtml: false,
                  ),
                  Dash(
                    dashColor: Colors.grey.withOpacity(0.3),
                    dashGap: 3,
                    length: 340.w,
                  ),
                  const SizedBox(height: 10,),
                  const DetailsContainer(
                    title:"Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipi.Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipi. Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur",
                    heading: 'Project Summary', isHtml: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
