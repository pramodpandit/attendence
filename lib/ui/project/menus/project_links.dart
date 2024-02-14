import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class ProjectLinks extends StatefulWidget {
  const ProjectLinks({Key? key}) : super(key: key);

  @override
  State<ProjectLinks> createState() => _ProjectLinksState();
}

class _ProjectLinksState extends State<ProjectLinks> {
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
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.only(top: 10),
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
                              blurRadius: 3,
                              spreadRadius: 1,
                              color: Colors.black.withOpacity(0.2))
                        ],
                        // border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Google",
                                // "${document[index].name}",
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    fontFamily: "Poppins"),
                              ),
                              Spacer(),
                              Text(
                                DateFormat.yMMMMd().format(DateTime.now()),
                                style: const TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    fontFamily: "Poppins"),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipi.Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipi",
                            //  "${document[index].other}",
                            style: const TextStyle(
                                color: Colors.black45,
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
                                fontFamily: "Poppins"),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                // onTap: () async {
                                //   final Uri url = Uri.parse(
                                //       '${links[index].links}');
                                //   try {
                                //     await launchUrl(url);
                                //   } catch (e) {
                                //     ScaffoldMessenger.of(context)
                                //         .showSnackBar(SnackBar(
                                //         content: Text(
                                //             '${links[index].links} does not exist')));
                                //   }
                                // },
                                child: Container(
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(100),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                              spreadRadius: 0,
                                              blurRadius: 3,
                                              color: Colors.black.withOpacity(0.2))
                                        ]),
                                    child: const Icon(
                                      PhosphorIcons.link_bold,
                                      color: Colors.black,
                                      size: 20,
                                    )),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: Text("https://www.google.co.in/"),
                              )
                            ],
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
            width: 90,
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
                        "Links",
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
