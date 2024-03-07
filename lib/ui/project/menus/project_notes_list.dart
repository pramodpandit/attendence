import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../bloc/project_bloc.dart';
import '../../../data/repository/project_repo.dart';
import 'Add_project/Add_Notes.dart';

class ProjectNotesList extends StatefulWidget {
  final data;
  const ProjectNotesList({Key? key, this.data}) : super(key: key);

  @override
  State<ProjectNotesList> createState() => _ProjectNotesListState(data);
}

class _ProjectNotesListState extends State<ProjectNotesList> {
  final data;
  _ProjectNotesListState(this.data);

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
    return  Scaffold(
      body: SingleChildScrollView(
        child: ValueListenableBuilder(
          valueListenable: bloc.projectNotes,
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
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5,vertical:0),
              child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount:projectNotes.length,
                  padding: EdgeInsets.only(top: 10),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    var data = projectNotes[index];
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${DateFormat.yMMMd().format(DateTime.parse(data['created_at']))}",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 8
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      "Created By: ${data['mamber_name']}",
                                      style: const TextStyle(
                                          color: Colors.black54,
                                          fontSize: 10
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              // const Text(
                              //   "Web Development",
                              //   textAlign: TextAlign.left,
                              //   style: TextStyle(
                              //     fontWeight: FontWeight.w700,
                              //   ),
                              // ),
        
                              const SizedBox(height: 5,),
                              Html(
                                data: data['notes'],
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
                              const SizedBox(height: 15,)
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            );
          },),
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
                              child: Add_Notes( projectid: widget.data['id'],branch_id: widget.data['business_address'],)
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
