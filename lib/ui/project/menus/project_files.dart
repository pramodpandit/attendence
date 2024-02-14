import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:office/ui/profile/menus/basic_info.dart';

class ProjectFiles extends StatefulWidget {
  const ProjectFiles({Key? key}) : super(key: key);

  @override
  State<ProjectFiles> createState() => _ProjectFilesState();
}

class _ProjectFilesState extends State<ProjectFiles> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.only(
                    left: 25, right: 25, top: 10, bottom: 10),
                child: ListView.builder(
                  padding: EdgeInsets.only(top: 10),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 10,
                    itemBuilder: (context, index) {
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
                                  "Addhaar Card",
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
                                    child: const Icon(
                                      Icons.download,
                                      color: Colors.black,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // const SizedBox(
                            //   height: 10,
                            // ),
                            Text(
                              "Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipi.Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipi",
                              style: const TextStyle(
                                  color: Colors.black45,
                                  fontWeight:
                                  FontWeight.w600,
                                  fontSize: 11,
                                  fontFamily: "Poppins"),
                            ),
                          ],
                        ),
                      );
                    }),
            )
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
