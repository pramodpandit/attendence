import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:office/ui/task/task_details.dart';
import 'package:provider/provider.dart';

import '../../bloc/task_bloc.dart';
import '../../data/repository/task_repo.dart';
import 'add_task.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({Key? key}) : super(key: key);

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  late taskBloc bloc;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc = taskBloc(context.read<TaskRepositary>(), );
    super.initState();
    bloc.fetchTaskData("doing");
    // _scrollController.addListener(_loadMoreData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 100,
                width: 1.sw,
                decoration: const BoxDecoration(
                    color: Color(0xFF009FE3),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20))
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 56,),
                    Text(
                      "Task",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20
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
              Positioned(
                top: 56,
                right: 10,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => Provider.value(
                          value: bloc,
                          child: const addTask(),
                        )
                    ));
                  },
                  child: const CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 15,
                    child: Icon(Icons.add, size: 18,),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                bloc.allFetchedTaskData.value = null;
                bloc.fetchTaskData("doing");
              },
              child: Container(
                width: 1.sw,
                height: 0.8.sh,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ValueListenableBuilder(
                  valueListenable: bloc.allFetchedTaskData,
                  builder: (context, allFetchedTaskData, child) {
                    if(allFetchedTaskData == null){
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    if(allFetchedTaskData.isEmpty){
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('No Task Available!',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                          ],
                        ),
                      );
                    }
                  return ListView.builder(
                      itemCount: allFetchedTaskData.length,
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemBuilder: (context,index){
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>TaskDetails(data:allFetchedTaskData[index],)));
                            },
                            child: Padding(
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
                                                  "${allFetchedTaskData[index]['title']}",
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
                                              Container(
                                                // color: Colors.black,
                                                // padding: const EdgeInsets.only(
                                                //     left: 20,
                                                //     right: 20,
                                                //     top: 30,
                                                //     bottom: 10),
                                                child: Html(
                                                  // data:"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                                                  data:
                                                  "${allFetchedTaskData[index]['description']}",
                                                  style: {
                                                    "body": Style(
                                                        color: Colors.black,
                                                        fontWeight:
                                                        FontWeight.w600,

                                                        display: Display.inline,
                                                        fontSize: FontSize(10),
                                                        textAlign:
                                                        TextAlign.start),
                                                    "p": Style(
                                                        color: Colors.black,

                                                        display: Display.inline,
                                                        fontSize: FontSize(10),
                                                        textAlign:
                                                        TextAlign.start),
                                                  },
                                                ),
                                              ),
                                              SizedBox(height: 10,),
                                              Row(mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Text("${allFetchedTaskData[index]['status']}",
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
                            ),
                          );
                      });
                },)
              ),
            ),
          )

        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: 50,
            width: 50,
            child: FloatingActionButton.extended(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(300.0))
                ),
                onPressed: () async{
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.white,
                    builder: (context) {
                      List taskTypeData = [
                        {"title": "All", "value": "total"},
                        {"title": "Doing", "value": "doing"},
                        {"title": "incomplete", "value": "incomplete"},
                        {"title": "Complete", "value": "complete"},
                      ];
                      return Container(
                        padding: EdgeInsets.all(10),
                        width: double.infinity,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: taskTypeData.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                                bloc.allFetchedTaskData.value = null;
                                bloc.taskStatus.value = taskTypeData[index]["value"];
                                bloc.fetchTaskData(taskTypeData[index]["value"]);
                              },
                              child: ValueListenableBuilder(
                                valueListenable: bloc.taskStatus,
                                builder: (context, type, child) {
                                  return Container(
                                    margin: EdgeInsets.all(5),
                                    padding : EdgeInsets.symmetric(horizontal: 10,vertical: 3),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            taskTypeData[index]["title"],
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: type == taskTypeData[index]["value"]?Colors.white:Colors.black,
                                            )),
                                        type == taskTypeData[index]["value"]?Icon(PhosphorIcons.check_circle_fill,color: Colors.white):Offstage(),
                                      ],
                                    ),
                                    decoration: BoxDecoration(
                                        color: type == taskTypeData[index]["value"]? Colors.green: Colors.white,
                                        borderRadius: BorderRadius.circular(5)
                                    ),
                                  );
                                },),
                            );
                          },
                        ),
                      );
                    },);
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (_) => Provider.value(
                  //         value: bloc,
                  //         child: const AddLead(),
                  //       )),
                  // );
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
                      Center(
                        // padding: EdgeInsets.only(right: 5.0),
                        child: Icon(
                          Icons.filter_alt,
                          color: Colors.white,
                        ),
                      ),
                      // Text(
                      //   "Lead",
                      //   style: TextStyle(color: Colors.white),
                      // )
                    ],
                  ),
                )),
          ),
          const SizedBox(height: 10,)
        ],
      ),
    );
  }
}