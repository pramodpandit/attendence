import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../bloc/project_bloc.dart';
import '../../../data/repository/project_repo.dart';
import '../../profile/menus/basic_info.dart';

class ProjectTask extends StatefulWidget {
  final data;
  const ProjectTask({Key? key, this.data}) : super(key: key);

  @override
  State<ProjectTask> createState() => _ProjectTaskState();
}

class _ProjectTaskState extends State<ProjectTask> {
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
            ValueListenableBuilder(
              valueListenable: bloc.projectTask,
              builder: (context, projectTask, child) {
                if(projectTask ==null){
                  return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: Center(child: CircularProgressIndicator()));
                }
                if(projectTask.isEmpty){
                  return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: Center(child: Text("No data available")));
                }
                return  Padding(
                  padding: const EdgeInsets.only(
                      left: 5, right: 5, top: 10, bottom: 10),
                  child: ListView.builder(
                      itemCount: projectTask.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.only(top: 10),
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context,index){
                        var data = projectTask[index];
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
                                      child:  Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 10,),
                                          Expanded(
                                            child: Text(
                                              "${data['title']}",
                                              // "The prevalence of trauma related disorders in children and adolescents affected by forest fires.",
                                              style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black
                                              ),
                                            ),
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
                                          Html(
                                            data: data['description'],
                                            // data:"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                                            // data:notes[index].description ?? "",
                                            style: {
                                              "body": Style(
                                                  color: Colors.black,
                                                  fontWeight:
                                                  FontWeight.w500,
                                                  fontFamily: "Poppins",
                                                  display: Display.inline,
                                                  fontSize: FontSize(11),
                                                  textAlign: TextAlign.start
                                              ),
                                              "p": Style(
                                                  color: Colors.black,
                                                  fontWeight:
                                                  FontWeight.w500,
                                                  // padding: EdgeInsets.zero,
                                                  fontFamily: "Poppins",
                                                  display: Display.inline,
                                                  fontSize: FontSize(11),
                                                  textAlign: TextAlign.start
                                              ),
                                            },
                                          ),
                                          SizedBox(height: 10,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Text("${data['status']}",
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
                );
              },),

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
