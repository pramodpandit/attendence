import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../bloc/profile_bloc.dart';
import '../../../bloc/project_bloc.dart';
import '../../../bloc/task_bloc.dart';
import '../../../data/model/user.dart';
import '../../../data/repository/profile_repo.dart';
import '../../../data/repository/project_repo.dart';
import '../../../data/repository/task_repo.dart';
import '../../profile/menus/basic_info.dart';

class TaskOverView extends StatefulWidget {
  final int  id;

  const TaskOverView({Key? key,   required this.id}) : super(key: key);

  @override
  State<TaskOverView> createState() => _TaskOverViewState();
}

class _TaskOverViewState extends State<TaskOverView> {


  late taskBloc bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc =taskBloc(context.read<TaskRepositary>(), );
    bloc.fetchTaskDetails(widget.id!,'user');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30,),
            ValueListenableBuilder(
              valueListenable: bloc.data,
              builder: (context, allTaskData, child) {
                if(allTaskData ==null){
                  return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: Center(child: CircularProgressIndicator()));
                }
                if(allTaskData.isEmpty){
                  return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: Center(child: Text("No data available")));
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
                        ],
                      ),
                      const SizedBox(height: 10,),
                      DetailsContainer(
                        title:"${allTaskData['project_name']}",
                        //"${details["first_name"]!=null?details["first_name"]:""} ${details["middle_name"]!=null?details["middle_name"]:""} ${details["last_name"]!=null?details["last_name"]:""}",
                        heading: 'Project Name', isHtml: false,
                      ),
                      Dash(
                        dashColor: Colors.grey.withOpacity(0.3),
                        dashGap: 3,
                        length: 340.w,
                      ),
                      const SizedBox(height: 10,),
                      DetailsContainer(
                        title:"${allTaskData['priority']}",
                        //"${details["first_name"]!=null?details["first_name"]:""} ${details["middle_name"]!=null?details["middle_name"]:""} ${details["last_name"]!=null?details["last_name"]:""}",
                        heading: 'Priority ', isHtml: false,
                      ),
                      Dash(
                        dashColor: Colors.grey.withOpacity(0.3),
                        dashGap: 3,
                        length: 340.w,
                      ),
                      const SizedBox(height: 10,),
                      DetailsContainer(
                        title:"${allTaskData['first_name']??''} ${allTaskData['last_name']??''}",
                        //"${details["first_name"]!=null?details["first_name"]:""} ${details["middle_name"]!=null?details["middle_name"]:""} ${details["last_name"]!=null?details["last_name"]:""}",
                        heading: 'Assigned To', isHtml: false,
                      ),
                      allTaskData['deadline'].toString() =='yes'?
                      Dash(
                        dashColor: Colors.grey.withOpacity(0.3),
                        dashGap: 3,
                        length: 340.w,
                      ):Offstage(),
                      const SizedBox(height: 10,),

                      DetailsContainer(
                        title:"${allTaskData['task_label_name']}",
                        //"${details["first_name"]!=null?details["first_name"]:""} ${details["middle_name"]!=null?details["middle_name"]:""} ${details["last_name"]!=null?details["last_name"]:""}",
                        heading: 'Label', isHtml: false,
                      ),

                      Dash(
                        dashColor: Colors.grey.withOpacity(0.3),
                        dashGap: 3,
                        length: 340.w,
                      ),
                      const SizedBox(height: 10,),
                      DetailsContainer(
                        title:"${allTaskData['task_category_name']}",
                        //"${details["first_name"]!=null?details["first_name"]:""} ${details["middle_name"]!=null?details["middle_name"]:""} ${details["last_name"]!=null?details["last_name"]:""}",
                        heading: 'Category', isHtml: false,
                      ),
                      Dash(
                        dashColor: Colors.grey.withOpacity(0.3),
                        dashGap: 3,
                        length: 340.w,
                      ),
                      const SizedBox(height: 10,),
                      DetailsContainer(
                        title: allTaskData['description']??'',
                        heading: 'Description', isHtml: false,
                      ),
                      Dash(
                        dashColor: Colors.grey.withOpacity(0.3),
                        dashGap: 3,
                        length: 340.w,
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
