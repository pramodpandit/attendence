import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../bloc/project_bloc.dart';
import '../../../data/repository/project_repo.dart';
import '../../../utils/message_handler.dart';

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
  }

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
                                  GestureDetector(
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
                                         // String url = "https://freeze.talocare.co.in/${data['file']}";


                                     // try {
                                               // showLoadingDialog(context);
                                      // Saved with this method.
                                      //         var imageId =
                                      // await ImageDownloader.downloadImage("https://freeze.talocare.co.in/${data['file']}");
                                      // if (imageId == null) {
                                      // return;
                                      // }
                                      // // Below is a method of obtaining saved image information.
                                      // var fileName = await ImageDownloader.findName(imageId);
                                      // var path = await ImageDownloader.findPath(imageId);
                                      // var size = await ImageDownloader.findByteSize(imageId);
                                      // var mimeType = await ImageDownloader.findMimeType(imageId);
                                      // Navigator.pop(context);
                                      //   bloc.showMessage(MessageType.info('Image downloaded'));
                                      // } on PlatformException catch (error) {
                                      // print(error);
                                      // }
                                      },
                                        child: const Icon(
                                          Icons.download,
                                          color: Colors.black,
                                          size: 20,
                                        ),
                                      ),
                                    ),
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
