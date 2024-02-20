import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../bloc/profile_bloc.dart';
import '../../../bloc/project_bloc.dart';
import '../../../data/model/user.dart';
import '../../../data/repository/profile_repo.dart';
import '../../../data/repository/project_repo.dart';
import '../../profile/menus/basic_info.dart';

class ProjectOverview extends StatefulWidget {
  final data;
  final User user;
  const ProjectOverview({Key? key, this.data, required this.user}) : super(key: key);

  @override
  State<ProjectOverview> createState() => _ProjectOverviewState(data,user);
}

class _ProjectOverviewState extends State<ProjectOverview> {
  final data;
  final User user;
  _ProjectOverviewState(this.data, this.user);

  late ProjectBloc bloc;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc = ProjectBloc(context.read<ProjectRepository>());
    bloc.fetchProjectsDetails(widget.data['id']);


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30,),
        ValueListenableBuilder(
          valueListenable: bloc.allprojectDetail,
          builder: (context, allProjectData, child) {
            if(allProjectData ==null){
              return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Center(child: CircularProgressIndicator()));
            }
            if(allProjectData.isEmpty){
              return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Center(child: Text("No data available")));
            }
            if(widget.user.userType == 'Employee'){
              if(widget.user.departmenttype.toString() == 'marketing'){
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                        ],
                      ),
                      const SizedBox(height: 10,),
                      DetailsContainer(
                        title:"${allProjectData['short_code']}",
                        //"${details["first_name"]!=null?details["first_name"]:""} ${details["middle_name"]!=null?details["middle_name"]:""} ${details["last_name"]!=null?details["last_name"]:""}",
                        heading: 'Short Code', isHtml: false,
                      ),
                      Dash(
                        dashColor: Colors.grey.withOpacity(0.3),
                        dashGap: 3,
                        length: 340.w,
                      ),
                      const SizedBox(height: 10,),
                      DetailsContainer(
                        title:"${allProjectData['start_date']}",
                        //"${details["first_name"]!=null?details["first_name"]:""} ${details["middle_name"]!=null?details["middle_name"]:""} ${details["last_name"]!=null?details["last_name"]:""}",
                        heading: 'Start date', isHtml: false,
                      ),
                      Dash(
                        dashColor: Colors.grey.withOpacity(0.3),
                        dashGap: 3,
                        length: 340.w,
                      ),
                      const SizedBox(height: 10,),
                      DetailsContainer(
                        title:"${allProjectData['deadline']}",
                        //"${details["first_name"]!=null?details["first_name"]:""} ${details["middle_name"]!=null?details["middle_name"]:""} ${details["last_name"]!=null?details["last_name"]:""}",
                        heading: 'Deadline Status', isHtml: false,
                      ),
                      allProjectData['deadline'].toString() =='yes'?
                      Dash(
                        dashColor: Colors.grey.withOpacity(0.3),
                        dashGap: 3,
                        length: 340.w,
                      ):Offstage(),
                      const SizedBox(height: 10,),
                      allProjectData['deadline'].toString() =='yes'?
                      DetailsContainer(
                        title:"${allProjectData['deadline']}",
                        //"${details["first_name"]!=null?details["first_name"]:""} ${details["middle_name"]!=null?details["middle_name"]:""} ${details["last_name"]!=null?details["last_name"]:""}",
                        heading: 'Deadline Date', isHtml: false,
                      ):Offstage(),
                         allProjectData['marketing_field']==1?
                         Column(
                      children: [
                        Dash(
                          dashColor: Colors.grey.withOpacity(0.3),
                          dashGap: 3,
                          length: 340.w,
                        ),
                        const SizedBox(height: 10,),
                        DetailsContainer(
                          title:' ${allProjectData['currency_short_name']} ${allProjectData['amount']}',
                          heading: 'Amount', isHtml: true,
                        ),
                        Dash(
                          dashColor: Colors.grey.withOpacity(0.3),
                          dashGap: 3,
                          length: 340.w,
                        ),
                        const SizedBox(height: 10,),
                        DetailsContainer(
                          title:' ${allProjectData['tax_percentage']}%',
                          heading: 'Tax', isHtml: true,
                        ),
                      ],
                    ):Offstage(),
                      Dash(
                        dashColor: Colors.grey.withOpacity(0.3),
                        dashGap: 3,
                        length: 340.w,
                      ),
                      const SizedBox(height: 10,),
                      DetailsContainer(
                        title:"${allProjectData['deadline_date']}",
                        //"${details["first_name"]!=null?details["first_name"]:""} ${details["middle_name"]!=null?details["middle_name"]:""} ${details["last_name"]!=null?details["last_name"]:""}",
                        heading: 'Deadline Date', isHtml: false,
                      ),
                      Dash(
                        dashColor: Colors.grey.withOpacity(0.3),
                        dashGap: 3,
                        length: 340.w,
                      ),
                      const SizedBox(height: 10,),
                      DetailsContainer(
                        title: allProjectData['project_summary'],
                        heading: 'Project Summary', isHtml: true,
                      ),
                      Dash(
                        dashColor: Colors.grey.withOpacity(0.3),
                        dashGap: 3,
                        length: 340.w,
                      ),
                      const SizedBox(height: 10,),
                      DetailsContainer(
                        title: allProjectData['notes'],
                        heading: 'Notes', isHtml: true,
                      ),

                    ],
                  ),
                );
              }else{
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                        ],
                      ),

                      const SizedBox(height: 10,),
                      DetailsContainer(
                        title:"${allProjectData['short_code']}",
                        //"${details["first_name"]!=null?details["first_name"]:""} ${details["middle_name"]!=null?details["middle_name"]:""} ${details["last_name"]!=null?details["last_name"]:""}",
                        heading: 'Short Code', isHtml: false,
                      ),
                      Dash(
                        dashColor: Colors.grey.withOpacity(0.3),
                        dashGap: 3,
                        length: 340.w,
                      ),
                      const SizedBox(height: 10,),
                      DetailsContainer(
                        title:"${allProjectData['start_date']}",
                        //"${details["first_name"]!=null?details["first_name"]:""} ${details["middle_name"]!=null?details["middle_name"]:""} ${details["last_name"]!=null?details["last_name"]:""}",
                        heading: 'Start date', isHtml: false,
                      ),
                      Dash(
                        dashColor: Colors.grey.withOpacity(0.3),
                        dashGap: 3,
                        length: 340.w,
                      ),
                      const SizedBox(height: 10,),
                      DetailsContainer(
                        title:"${allProjectData['deadline']}",
                        //"${details["first_name"]!=null?details["first_name"]:""} ${details["middle_name"]!=null?details["middle_name"]:""} ${details["last_name"]!=null?details["last_name"]:""}",
                        heading: 'Deadline Status', isHtml: false,
                      ),
                      allProjectData['deadline'].toString() =='yes'?
                      Dash(
                        dashColor: Colors.grey.withOpacity(0.3),
                        dashGap: 3,
                        length: 340.w,
                      ):Offstage(),
                      const SizedBox(height: 10,),
                      allProjectData['deadline'].toString() =='yes'?
                      DetailsContainer(
                        title:"${allProjectData['deadline_date']}",
                        //"${details["first_name"]!=null?details["first_name"]:""} ${details["middle_name"]!=null?details["middle_name"]:""} ${details["last_name"]!=null?details["last_name"]:""}",
                        heading: 'Deadline Date', isHtml: false,
                      ):Offstage(),

                      Dash(
                        dashColor: Colors.grey.withOpacity(0.3),
                        dashGap: 3,
                        length: 340.w,
                      ),
                      const SizedBox(height: 10,),
                      DetailsContainer(
                        title: allProjectData['project_summary'],
                        heading: 'Project Summary', isHtml: true,
                      ),
                      Dash(
                        dashColor: Colors.grey.withOpacity(0.3),
                        dashGap: 3,
                        length: 340.w,
                      ),
                      const SizedBox(height: 10,),
                      DetailsContainer(
                        title: allProjectData['notes'],
                        heading: 'Notes', isHtml: true,
                      ),

                    ],
                  ),
                );
              }
            }else if(widget.user.userType.toString() =='Admin'){
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      ],
                    ),

                    const SizedBox(height: 10,),
                    DetailsContainer(
                      title:"${allProjectData['short_code']}",
                      //"${details["first_name"]!=null?details["first_name"]:""} ${details["middle_name"]!=null?details["middle_name"]:""} ${details["last_name"]!=null?details["last_name"]:""}",
                      heading: 'Short Code', isHtml: false,
                    ),
                    Dash(
                      dashColor: Colors.grey.withOpacity(0.3),
                      dashGap: 3,
                      length: 340.w,
                    ),
                    const SizedBox(height: 10,),
                    DetailsContainer(
                      title:"${allProjectData['start_date']}",
                      //"${details["first_name"]!=null?details["first_name"]:""} ${details["middle_name"]!=null?details["middle_name"]:""} ${details["last_name"]!=null?details["last_name"]:""}",
                      heading: 'Start date', isHtml: false,
                    ),
                    Dash(
                      dashColor: Colors.grey.withOpacity(0.3),
                      dashGap: 3,
                      length: 340.w,
                    ),
                    const SizedBox(height: 10,),
                    DetailsContainer(
                      title:"${allProjectData['deadline']}",
                      //"${details["first_name"]!=null?details["first_name"]:""} ${details["middle_name"]!=null?details["middle_name"]:""} ${details["last_name"]!=null?details["last_name"]:""}",
                      heading: 'Deadline Status', isHtml: false,
                    ),
                    allProjectData['deadline'].toString() =='yes'?
                    Dash(
                      dashColor: Colors.grey.withOpacity(0.3),
                      dashGap: 3,
                      length: 340.w,
                    ):Offstage(),
                    const SizedBox(height: 10,),
                    allProjectData['deadline'].toString() =='yes'?
                    DetailsContainer(
                      title:"${allProjectData['deadline']}",
                      //"${details["first_name"]!=null?details["first_name"]:""} ${details["middle_name"]!=null?details["middle_name"]:""} ${details["last_name"]!=null?details["last_name"]:""}",
                      heading: 'Deadline Date', isHtml: false,
                    ):Offstage(),
                    allProjectData['marketing_field']==1?
                    Column(
                      children: [
                        Dash(
                          dashColor: Colors.grey.withOpacity(0.3),
                          dashGap: 3,
                          length: 340.w,
                        ),
                        const SizedBox(height: 10,),
                        DetailsContainer(
                          title:' ${allProjectData['currency_short_name']} ${allProjectData['amount']}',
                          heading: 'Amount', isHtml: true,
                        ),
                        Dash(
                          dashColor: Colors.grey.withOpacity(0.3),
                          dashGap: 3,
                          length: 340.w,
                        ),
                        const SizedBox(height: 10,),
                        DetailsContainer(
                          title:' ${allProjectData['tax_percentage']}%',
                          heading: 'Tax', isHtml: true,
                        ),
                      ],
                    ):Offstage(),
                    Dash(
                      dashColor: Colors.grey.withOpacity(0.3),
                      dashGap: 3,
                      length: 340.w,
                    ),
                    const SizedBox(height: 10,),
                    DetailsContainer(
                      title:"${allProjectData['deadline_date']}",
                      //"${details["first_name"]!=null?details["first_name"]:""} ${details["middle_name"]!=null?details["middle_name"]:""} ${details["last_name"]!=null?details["last_name"]:""}",
                      heading: 'Deadline Date', isHtml: false,
                    ),
                    Dash(
                      dashColor: Colors.grey.withOpacity(0.3),
                      dashGap: 3,
                      length: 340.w,
                    ),
                    const SizedBox(height: 10,),
                    DetailsContainer(
                      title: allProjectData['project_summary'],
                      heading: 'Project Summary', isHtml: true,
                    ),
                    Dash(
                      dashColor: Colors.grey.withOpacity(0.3),
                      dashGap: 3,
                      length: 340.w,
                    ),
                    const SizedBox(height: 10,),
                    DetailsContainer(
                      title: allProjectData['notes'],
                      heading: 'Notes', isHtml: true,
                    ),

                  ],
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Text(
                      //   "${allProjectData['name']}",
                      //   style: TextStyle(
                      //       color: Colors.black,
                      //       fontWeight: FontWeight.bold,
                      //       fontSize: 15
                      //   ),
                      // )
                    ],
                  ),
                  // const SizedBox(height: 10,),
                  // Dash(
                  //   dashColor: Colors.grey.withOpacity(0.3),
                  //   dashGap: 3,
                  //   length: 340.w,
                  // ),
                  const SizedBox(height: 10,),
                  DetailsContainer(
                    title:"${allProjectData['short_code']}",
                    //"${details["first_name"]!=null?details["first_name"]:""} ${details["middle_name"]!=null?details["middle_name"]:""} ${details["last_name"]!=null?details["last_name"]:""}",
                    heading: 'Short Code', isHtml: false,
                  ),
                  Dash(
                    dashColor: Colors.grey.withOpacity(0.3),
                    dashGap: 3,
                    length: 340.w,
                  ),
                  const SizedBox(height: 10,),
                  DetailsContainer(
                    title:"${allProjectData['start_date']}",
                    //"${details["first_name"]!=null?details["first_name"]:""} ${details["middle_name"]!=null?details["middle_name"]:""} ${details["last_name"]!=null?details["last_name"]:""}",
                    heading: 'Start date', isHtml: false,
                  ),
                  Dash(
                    dashColor: Colors.grey.withOpacity(0.3),
                    dashGap: 3,
                    length: 340.w,
                  ),
                  const SizedBox(height: 10,),
                  DetailsContainer(
                    title:"${allProjectData['deadline']}",
                    //"${details["first_name"]!=null?details["first_name"]:""} ${details["middle_name"]!=null?details["middle_name"]:""} ${details["last_name"]!=null?details["last_name"]:""}",
                    heading: 'Deadline Status', isHtml: false,
                  ),
                  Dash(
                    dashColor: Colors.grey.withOpacity(0.3),
                    dashGap: 3,
                    length: 340.w,
                  ),
                  const SizedBox(height: 10,),
                  DetailsContainer(
                    title:"${allProjectData['deadline_date']}",
                    //"${details["first_name"]!=null?details["first_name"]:""} ${details["middle_name"]!=null?details["middle_name"]:""} ${details["last_name"]!=null?details["last_name"]:""}",
                    heading: 'Deadline Date', isHtml: false,
                  ),
                  Dash(
                    dashColor: Colors.grey.withOpacity(0.3),
                    dashGap: 3,
                    length: 340.w,
                  ),
                  const SizedBox(height: 10,),
                  DetailsContainer(
                    title: allProjectData['project_summary'],
                    heading: 'Project Summary', isHtml: true,
                  ),
                  Dash(
                    dashColor: Colors.grey.withOpacity(0.3),
                    dashGap: 3,
                    length: 340.w,
                  ),
                  const SizedBox(height: 10,),
                  DetailsContainer(
                    title: allProjectData['notes'],
                    heading: 'Notes', isHtml: true,
                  ),
                ],
              ),
            );
            },
        )
          ],
        ),
      ),
    );
  }
}
