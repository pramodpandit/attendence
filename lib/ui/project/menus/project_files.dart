import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../bloc/project_bloc.dart';
import '../../../data/repository/project_repo.dart';
import '../../../utils/message_handler.dart';
import 'Add_project/Add_Files.dart';

class ProjectFiles extends StatefulWidget {
  final data;
  const ProjectFiles({Key? key, this.data}) : super(key: key);

  @override
  State<ProjectFiles> createState() => _ProjectFilesState(data);
}

class _ProjectFilesState extends State<ProjectFiles> {
  final data;
  _ProjectFilesState(this.data);
  late ProjectBloc bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc = ProjectBloc(context.read<ProjectRepository>());
    bloc.fetchProjectsDetails(widget.data['id']);
    bloc.msgController?.stream.listen((event) {
      AppMessageHandler().showSnackBar(context, event);
    });
  }
 // var downloadLoading = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ValueListenableBuilder(
              valueListenable: bloc.projectfile,
              builder: (context, projectFile, child) {
                if(projectFile ==null){
                  return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: Center(child: CircularProgressIndicator()));
                }
                if(projectFile.isEmpty){
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
                      itemCount: projectFile.length,
                      itemBuilder: (context, index) {
                        var data = projectFile[index];
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
                                          child: InkWell(
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
                              // const SizedBox(
                              //   height: 10,
                              // ),
                              // Text(
                              //   "Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipi.Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipi",
                              //   style: const TextStyle(
                              //       color: Colors.black45,
                              //       fontWeight:
                              //       FontWeight.w600,
                              //       fontSize: 11,
                              //       fontFamily: "Poppins"),
                              // ),
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
                  var result =await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Provider.value(
                        value: bloc,
                        child: Add_Files(branch_id: widget.data['business_address'],projectid:widget.data['id']),
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
