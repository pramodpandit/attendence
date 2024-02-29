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
    bloc.fetchTaskData();
    // _scrollController.addListener(_loadMoreData);
  }
  ValueNotifier<int> selectedMenuIndex = ValueNotifier(0);
  List<String> taskMenus = [
    "All",
    "Pending",
    "Ongoing",
    "Completed",
  ];
  selectMenu(int index){
    selectedMenuIndex.value =index;
  }
  List<Widget> profileMenusWidgets = [
    const AllTask(),
    const pendingTask(),
    const ongoingTask(),
    const completedTask(),
  ];


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
                      itemCount: taskMenus.length,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                selectMenu(index);
                                // userDetailsNotifier.selectMenu(index);
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right : 5),
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
                                  taskMenus[index],
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
                  return Provider.value(
                      value: index, child: profileMenusWidgets[index]);
                },
              ),
            ),
          )

        ],
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
                 Navigator.push(context, MaterialPageRoute(builder: (context)=>addTask()));
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
class AllTask extends StatefulWidget {
  const AllTask({super.key});

  @override
  State<AllTask> createState() => _AllTaskState();
}

class _AllTaskState extends State<AllTask> {
  late taskBloc bloc;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc = taskBloc(context.read<TaskRepositary>(), );
    super.initState();
    bloc.fetchTaskData();
    // _scrollController.addListener(_loadMoreData);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Expanded(
          child: ValueListenableBuilder(
            valueListenable: bloc.isUserDetailLoad,
            builder: (BuildContext context,bool isLoading,Widget? child){
              if(isLoading){
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.builder(
                  itemCount: bloc.feedbackData.length,
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemBuilder: (context,index){
                    var data = bloc.feedbackData[index];
                    if(bloc.feedbackData.isEmpty){
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
                    }else{
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>TaskDetails(data: data,)));
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
                                              "${data.title}",
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
                                              "${data.description}",
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
                                              Text("${data.status}",
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
                    }

                  });},
          ),
        )
    );
  }
}

class pendingTask extends StatefulWidget {
  const pendingTask({super.key});

  @override
  State<pendingTask> createState() => _pendingTaskState();
}

class _pendingTaskState extends State<pendingTask> {
  late taskBloc bloc;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc = taskBloc(context.read<TaskRepositary>(), );
    super.initState();
    bloc.fetchTaskData();
    // _scrollController.addListener(_loadMoreData);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:
      Expanded(
        child: ValueListenableBuilder(
            valueListenable: bloc.isUserDetailLoad,
            builder: (BuildContext context,bool isLoading,Widget? child){
            if(isLoading){
            return const Center(
            child: CircularProgressIndicator(),
            );
            }
         return ListView.builder(
              itemCount: bloc.feedbackData.length,
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemBuilder: (context,index){
                var data = bloc.feedbackData[index];
                if(data.status =='incomplete'){
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=> TaskDetails(data: data,)));
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
                                          "${data.title}",
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
                                          "${data.description}",
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
                                          Text("${data.status}",
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
                    )
                  );
                }else{
                  if(index == 0){
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('No Pending Task Available!',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                        ],
                      ),
                    );
                  }
                }

          });},
        ),
      )
    );
  }
}
class ongoingTask extends StatefulWidget {
  const ongoingTask({super.key});

  @override
  State<ongoingTask> createState() => _ongoingTaskState();
}

class _ongoingTaskState extends State<ongoingTask> {
  late taskBloc bloc;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc = taskBloc(context.read<TaskRepositary>(), );
    super.initState();
    bloc.fetchTaskData();
    // _scrollController.addListener(_loadMoreData);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: bloc.isUserDetailLoad,
            builder: (BuildContext context,bool isLoading,Widget? child){
              if(isLoading){
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.builder(
                  itemCount: bloc.feedbackData.length,
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemBuilder: (context,index){
                    var data = bloc.feedbackData[index];
                    if(data.status =='doing'){
                      return InkWell(
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>TaskDetails(data: data,)));
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
                                              "${data.title}",
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
                                              "${data.description}",
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
                                              Text("${data.status}",
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
                    }else{
                      if(index == 0 ){
                        return Container(
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('No Ongoing Task Available!',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                            ],
                          ),
                        );
                      }
                    }

                  });},
          ),
        )
    );
  }
}
class completedTask extends StatefulWidget {
  const completedTask({super.key});

  @override
  State<completedTask> createState() => _completedState();
}

class _completedState extends State<completedTask> {
  late taskBloc bloc;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc = taskBloc(context.read<TaskRepositary>(), );
    super.initState();
    bloc.fetchTaskData();
    // _scrollController.addListener(_loadMoreData);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: bloc.isUserDetailLoad,
            builder: (BuildContext context,bool isLoading,Widget? child){
              if(isLoading){
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.builder(
                  itemCount:  bloc.feedbackData.where((element) => element.status=="complete").toList().length,
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemBuilder: (context,index){
                    var data = bloc.feedbackData.where((element) => element.status=="complete").toList()[index];
                    if(data != null){
                      return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=> TaskDetails(data: data,)));
                          },
                          child:

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
                                                "${data.title}",
                                                style: TextStyle(
                                                    fontFamily: "Poppins",
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black
                                                ),),
                                            ),
                                            Text(
                                              "11:00 Am - 12:00 Pm",
                                              style: TextStyle(
                                                  fontSize: 8,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black54
                                              ),),
                                            SizedBox(height: 10,),
                                            Container(
                                              child: Html(
                                                // data:"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                                                data:
                                                "${data.description}"??'',
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
                                                Text("${data.status}",
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
                          )
                      );
                    }else{
                      return Container(
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('No Completed Task Available!',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                            ],
                          ),
                        );
                    }
                  });},
          ),
        )
    );
  }
}



