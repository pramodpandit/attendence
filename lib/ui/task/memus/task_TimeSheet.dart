import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../bloc/project_bloc.dart';
import '../../../bloc/task_bloc.dart';
import '../../../data/repository/project_repo.dart';
import '../../../data/repository/task_repo.dart';
import 'add_pages/task_add_timesheet.dart';

class TaskTimesheet extends StatefulWidget {
  final int id;
  const TaskTimesheet({Key? key, required this.id}) : super(key: key);

  @override
  State<TaskTimesheet> createState() => _TaskTimesheetListState();
}

class _TaskTimesheetListState extends State<TaskTimesheet> {


  late taskBloc bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc =taskBloc(context.read<TaskRepositary>(), );
    bloc.fetchTaskDetails(widget.id!,'task_timesheet');
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ValueListenableBuilder(
              valueListenable: bloc.allTaskData,
              builder: (context, projectNotes, child) {
                if(projectNotes ==null){
                  return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: Center(child: CircularProgressIndicator()));
                }
                if(projectNotes.isEmpty){
                  return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: Center(child: Text("No data available")));
                }
                return Container(
                  height: MediaQuery.of(context).size.height,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15,vertical:0),
                    child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount:projectNotes.length,
                        padding: EdgeInsets.only(top: 10),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var data = projectNotes[index];
                          var startTime =data['start_time'].toString().split(':');
                          var endTime =data['end_time'].toString().split(':');
                          return  Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            child:ListTile(
                              title:Text('${data['first_name']??''} ${data['last_name']??''}',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14),),
                              subtitle:   Container(
                                child: Html(
                                  data:
                                  "${data['memo']??''}",
                                  style: {
                                    "body": Style(
                                        color: Colors.black,
                                        fontWeight:
                                        FontWeight.w500,
                                        display: Display.inline,
                                        fontSize: FontSize(16),
                                        textAlign:
                                        TextAlign.start),
                                    "p": Style(
                                        color: Colors.black,
                                        display: Display.inline,
                                        fontSize: FontSize(16),
                                        textAlign:
                                        TextAlign.start),
                                  },
                                ),
                              ),
                              leading:CircleAvatar(
                                child: Icon(Icons.person),
                              ),
                              trailing: Text('${startTime[0]}:${startTime[1]} - ${endTime[0]}:${endTime[1]}',style: TextStyle(fontSize: 10),),
                            )
                          );
                        }),
                  ) ,
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
                  var result =await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => Provider.value(
                              value: bloc,
                              child: TaskAddTimeSheet(taskId: widget.id, bloc: bloc,)
                          )));
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
                        "Notes",
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
