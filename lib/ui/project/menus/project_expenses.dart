import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import '../../../bloc/project_bloc.dart';
import '../../../data/repository/project_repo.dart';
import '../../../utils/message_handler.dart';
import 'Add_project/Add_Expenses.dart';
import 'Add_project/Add_Files.dart';

class ProjectExpenses extends StatefulWidget {
  final data;
  const ProjectExpenses({Key? key, this.data}) : super(key: key);

  @override
  State<ProjectExpenses> createState() => _ProjectExpensesState(data);
}

class _ProjectExpensesState extends State<ProjectExpenses> {
  final data;
  _ProjectExpensesState(this.data);
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
              valueListenable: bloc.projectexpenses,
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
                            children: [
                              const SizedBox(height: 10,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      "${data['item_name']}",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "₹${data['price']}",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10,),
                              Html(data: data['description']),
                              Row(
                                children: [
                                  const Expanded(child: Row()),
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
                                          child:data['file']==null || data['file'] ==''?Offstage(): InkWell(
                                            onTap: () async{
                                              bloc.isLoadingDownload.value = index;
                                                FileDownloader.downloadFile(url: 'https://freeze.talocare.co.in/public/${data['file']}',name: data['file'].toString().split('/').last,onDownloadCompleted: (path) {
                                                bloc.showMessage(MessageType.success('File Downloaded'));
                                                bloc.isLoadingDownload.value = -1;
                                              },
                                              );
                                            },
                                            child: downloadLoading == index? SizedBox(width: 20,height:20,child: CircularProgressIndicator()): Icon(
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
                              10.height,
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
                        child: Add_Expenses(branch_id: widget.data['business_address'],projectid:widget.data['id']),
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
                        "Expenses",
                        style: TextStyle(color: Colors.white,fontSize: 12),
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
