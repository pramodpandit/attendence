import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../bloc/project_bloc.dart';
import '../../../bloc/task_bloc.dart';
import '../../../data/repository/project_repo.dart';
import '../../../data/repository/task_repo.dart';
import '../../../utils/message_handler.dart';
import 'add_pages/task_add_files.dart';

class TaskFile extends StatefulWidget {
  final int id;
  const TaskFile({Key? key,required this.id}) : super(key: key);

  @override
  State<TaskFile> createState() => _TaskFileState();
}

class _TaskFileState extends State<TaskFile> {
  late taskBloc bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc =taskBloc(context.read<TaskRepositary>(), );
    bloc.fetchTaskDetails(widget.id!,'task_file_details');
    bloc.msgController?.stream.listen((event) {
      AppMessageHandler().showSnackBar(context, event);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ValueListenableBuilder(
              valueListenable: bloc.allTaskData,
              builder: (context, taskfile, child) {
                if(taskfile ==null){
                  return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: Center(child: CircularProgressIndicator()));
                }
                if(taskfile.isEmpty){
                  return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: Center(child: Text("No data available")));
                }
                return  Padding(
                  padding: const EdgeInsets.only(
                      left: 25, right: 25, top: 10, bottom: 10),
                  child: ListView.builder(
                      padding: EdgeInsets.only(top: 10),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: taskfile.length,
                      itemBuilder: (context, index) {
                        var data = taskfile[index];
                        return Container(
                          width: 1.sw,
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                spreadRadius: 1,
                                blurRadius: 3,
                                color: Colors.black.withOpacity(0.1),
                              )
                            ],
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "${data['title']}",
                                    // "${document[index].name}",
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight:
                                        FontWeight.w600,
                                        fontSize: 11,
                                        fontFamily: "Poppins"),
                                  ),
                                  Spacer(),
                                  ValueListenableBuilder(
                                    valueListenable: bloc.isLoadingDownload,
                                    builder: (context, downloadLoading, child) {
                                      return  GestureDetector(
                                        child: Container(
                                          padding: EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(100),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                    spreadRadius: 0,
                                                    blurRadius: 3,
                                                    color: Colors.black.withOpacity(0.2)
                                                )
                                              ]
                                          ),
                                          child: data['file'] ==null || data['file'] == ''?Offstage():InkWell(
                                            onTap: () async{
                                              bloc.isLoadingDownload.value = index;
                                              FileDownloader.downloadFile(url: 'https://freeze.talocare.co.in/public/${data['file']}',name: data['file'].toString().split('/').last,onDownloadCompleted: (path) {
                                                bloc.showMessage(MessageType.success('File Downloaded'));
                                                bloc.isLoadingDownload.value = -1;
                                              },
                                              );
                                            },
                                            child: downloadLoading == index?SizedBox(width: 20,height:20,child: CircularProgressIndicator()): Icon(
                                              Icons.download,
                                              color: Colors.black,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),

                            ],
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
            width: 130,
            child: FloatingActionButton.extended(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0))
                ),
                onPressed: () async{
                  //Navigator.push(context, MaterialPageRoute(builder: (context)=>TaskAddFiles(taskId: widget.id, bloc: bloc,),));
                  var result =await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Provider.value(
                        value: bloc,
                        child: TaskAddFiles( taskId: widget.id, bloc: bloc,),
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
                        "Upload File",
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
