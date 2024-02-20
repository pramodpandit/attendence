import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:provider/provider.dart';

import '../../../bloc/project_bloc.dart';
import '../../../data/repository/project_repo.dart';

class ProjectComments extends StatefulWidget {
  final data;
  const ProjectComments({Key? key, this.data}) : super(key: key);

  @override
  State<ProjectComments> createState() => _ProjectCommentsState(data);
}

class _ProjectCommentsState extends State<ProjectComments> {
  final data;
  _ProjectCommentsState(this.data);
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
      resizeToAvoidBottomInset: true,
      body: ValueListenableBuilder(
        valueListenable: bloc.projectcomment,
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
                return Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${data['first_name']} ${data['l_name']}",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Container(
                              child: Html(
                                data:
                                "${data['comment']}",
                                style: {
                                  "body": Style(
                                      color: Colors.black54,
                                      fontWeight:
                                      FontWeight.w400,
                                      display: Display.inline,
                                      fontSize: FontSize(12),
                                      textAlign:
                                      TextAlign.start),
                                  "p": Style(
                                      color: Colors.black54,
                                      display: Display.inline,
                                      fontSize: FontSize(12),
                                      textAlign:
                                      TextAlign.start),
                                },
                              ),
                            ),

                          ],
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
