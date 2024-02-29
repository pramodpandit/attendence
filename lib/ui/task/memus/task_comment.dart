import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:provider/provider.dart';

import '../../../bloc/project_bloc.dart';
import '../../../bloc/task_bloc.dart';
import '../../../data/repository/project_repo.dart';
import '../../../data/repository/task_repo.dart';
import '../../../utils/message_handler.dart';
import 'add_pages/task_add_comment.dart';

class TaskComment extends StatefulWidget {
  final int id;
  const TaskComment({Key? key, required this.id}) : super(key: key);

  @override
  State<TaskComment> createState() => _ProjectCommentsState();
}

class _ProjectCommentsState extends State<TaskComment> {

  late taskBloc bloc;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc =taskBloc(context.read<TaskRepositary>(), );
    bloc.fetchTaskDetails(widget.id!,'task_comment');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: ValueListenableBuilder(
        valueListenable: bloc.allTaskData,
        builder: (context, projectComment, child) {
          if(projectComment ==null){
            return SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: Center(child: CircularProgressIndicator()));
          }
          if(projectComment.isEmpty){
            return SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: Center(child: Text("No data available")));
          }
          return   Padding(
            padding: const EdgeInsets.only(left: 15,right: 20),
            child: ListView.builder(
              itemCount: projectComment.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                var data = projectComment[index];
                return  Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          child: Html(
                            data:
                            "${data['comment']}",
                            style: {
                              "body": Style(
                                  color: Colors.black,
                                  fontWeight:
                                  FontWeight.w400,
                                  display: Display.inline,
                                  fontSize: FontSize(14),
                                  textAlign:
                                  TextAlign.start),
                              "p": Style(
                                  color: Colors.black,
                                  display: Display.inline,
                                  fontSize: FontSize(14),
                                  textAlign:
                                  TextAlign.start),
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: 40,
            width: 110,
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
                        child:  TaskAddComment(taskId: widget.id, bloc: bloc,),
                      ),
                    ),
                  );
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
                        "Comment",
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
