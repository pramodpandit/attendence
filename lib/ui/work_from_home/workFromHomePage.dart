import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:office/bloc/leave_bloc.dart';
import 'package:office/bloc/work_from_home_bloc.dart';
import 'package:office/data/model/LeaveRecord.dart';
import 'package:office/data/repository/leave_repository.dart';
import 'package:office/data/repository/work_from_home_repository.dart';
import 'package:office/ui/leave/apply_leave.dart';
import 'package:office/ui/leave/leave_policy.dart';
import 'package:office/ui/leave/leaves_detail.dart';
import 'package:office/ui/leave/leaves_page.dart';
import 'package:office/ui/work_from_home/apply_work_from_home.dart';
import 'package:office/ui/work_from_home/work_from_home_detail.dart';
import 'package:office/ui/widget/app_bar.dart';
import 'package:office/ui/widget/loading_widget.dart';
import 'package:office/ui/work_from_home/work_from_home_more_details.dart';
import 'package:office/utils/constants.dart';
import 'package:office/utils/enums.dart';
import 'package:office/utils/message_handler.dart';
import 'package:provider/provider.dart';

class WorkFromHomePage extends StatefulWidget {
  const WorkFromHomePage({Key? key}) : super(key: key);

  @override
  State<WorkFromHomePage> createState() => _WorkFromHomePageState();
}

class _WorkFromHomePageState extends State<WorkFromHomePage> {
  late WorkFromHomeBloc bloc;

  @override
  void initState() {
    bloc = WorkFromHomeBloc(context.read<WorkFromHomeRepository>());
    super.initState();
    bloc.msgController?.stream.listen((event) {
      AppMessageHandler().showSnackBar(context, event);
    });
    bloc.workFromHomeController.stream.listen((event) {
      if(event=="LEAVE_RESPONSE") {
        Navigator.pop(context);
        bloc.getWorkFromHomeRecords();
      }
    });
    // bloc.getLeaveCategory();
    bloc.getWorkFromHomeRecords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.97),
      // appBar: MyAppBar(
      //   title: "My Leaves",
      //   actions: [
      //     Container(
      //         margin: const EdgeInsets.only(right: 10),
      //         child: GestureDetector(
      //             onTap: () {
      //               Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const LeavePolicy()));
      //             }, child: const Icon(Icons.question_mark))),
      //   ],
      // ),
      body: Stack(
        children: [
          Container(
            height: 100,
            width: 1.sw,
            decoration: const BoxDecoration(
                color: Color(0xFF009FE3),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 56,
                ),
                Text(
                  "Work from home",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ],
            ),
          ),
          Positioned(
            top: 56,
            left: 10,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const CircleAvatar(
                backgroundColor: Colors.white,
                radius: 15,
                child: Icon(
                  Icons.arrow_back,
                  size: 18,
                ),
              ),
            ),
          ),
          // Positioned(
          //   top: 56,
          //   right: 10,
          //   child: GestureDetector(
          //     onTap: () {
          //       Navigator.of(context).push(MaterialPageRoute(
          //           builder: (context) => const LeavePolicy()));
          //     },
          //     child: const CircleAvatar(
          //       backgroundColor: Colors.white,
          //       radius: 15,
          //       child: Icon(
          //         Icons.question_mark,
          //         size: 18,
          //       ),
          //     ),
          //   ),
          // ),
          Column(
            children: [
              const SizedBox(
                height: 100,
              ),
              Expanded(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: ValueListenableBuilder(
                        valueListenable: bloc.workFromHomeRecords,
                        builder: (context, records, child) {
                          if(records.isEmpty){
                            return const DashedCircularProgressBar.square(
                              dimensions: 160,
                              progress: 0,
                              startAngle: 0,
                              sweepAngle: 360,
                              foregroundColor: Colors.blue,
                              backgroundColor: Color(0xffadacac),
                              foregroundStrokeWidth: 13,
                              backgroundStrokeWidth: 10,
                              animation: true,
                              seekSize: 16,
                              seekColor: Colors.white,
                              child: Center(
                                  child: Text(
                                    '0\nPending',
                                    style: TextStyle(
                                        fontSize: 14, fontWeight: FontWeight.w600),
                                    textAlign: TextAlign.center,
                                  )),
                            );
                          }
                        return DashedCircularProgressBar.square(
                          dimensions: 160,
                          progress: (records.where((element) => element['status']== 'pending').toList().length/records.length)*100,
                          startAngle: 0,
                          sweepAngle: 360,
                          foregroundColor: Colors.blue,
                          backgroundColor: Color(0xffadacac),
                          foregroundStrokeWidth: 13,
                          backgroundStrokeWidth: 10,
                          animation: true,
                          seekSize: 16,
                          seekColor: Colors.white,
                          child: Center(
                              child: Text(
                                '${records.where((element) => element['status']== 'pending').toList().length}\nPending',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600),
                                textAlign: TextAlign.center,
                              )),
                        );
                      },),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Provider.value(
                            value: bloc,
                            child: const ApplyWorkFromHome(),
                          ),
                        ));
                      },
                      child: const Text(
                        "Click for WFH request",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    // SizedBox(
                    //   height: 120,
                    //   child: ListView.builder(
                    //       itemCount: 4,
                    //       scrollDirection: Axis.horizontal,
                    //       itemBuilder: (context, index) {
                    //         return Container(
                    //           margin: const EdgeInsets.only(left: 15, right: 5),
                    //           child: const Column(
                    //             children: [
                    //               DashedCircularProgressBar.square(
                    //                 dimensions: 70,
                    //                 progress: 60,
                    //                 startAngle: 0,
                    //                 sweepAngle: 360,
                    //                 foregroundColor: Color(0xff4BCD36),
                    //                 backgroundColor: Color(0xffeeeeee),
                    //                 foregroundStrokeWidth: 7,
                    //                 backgroundStrokeWidth: 5,
                    //                 animation: true,
                    //                 seekSize: 8,
                    //                 seekColor: Colors.white,
                    //                 child: Center(
                    //                     child: Text(
                    //                       '04',
                    //                       style: TextStyle(
                    //                           fontSize: 14,
                    //                           fontWeight: FontWeight.w600),
                    //                     )),
                    //               ),
                    //               SizedBox(
                    //                 height: 5,
                    //               ),
                    //               Text(
                    //                 'Casual Leave',
                    //                 style: TextStyle(
                    //                     fontSize: 12,
                    //                     fontWeight: FontWeight.w600),
                    //               ),
                    //             ],
                    //           ),
                    //         );
                    //       }),
                    // ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Work from home details',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Provider.value(
                                    value: bloc,
                                    child: const WorkFromHomeMoreDetailPage(),
                                  )));
                            },
                            child: const Text(
                              'More Details',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ValueListenableBuilder(
                            valueListenable: bloc.workFromHomeState,
                            builder: (context, LoadingState state, _) {
                              if (state == LoadingState.loading) {
                                return const Column(
                                  children: [
                                    SizedBox(
                                      height: 50,
                                    ),
                                    Center(
                                      child: LoadingIndicator(
                                        color: K.themeColorPrimary,
                                      ),
                                    ),
                                  ],
                                );
                              }
                              if (state == LoadingState.error) {
                                return const Center(
                                  child: Text(
                                      "Some error occurred! Please try again!"),
                                );
                              }
                              if (state == LoadingState.networkError) {
                                return const Center(
                                  child: Text("No Internet Connection!"),
                                );
                              }
                              return ValueListenableBuilder(
                                  valueListenable: bloc.workFromHomeRecords,
                                  builder:
                                      (context, List workFromHomeRecords, _) {
                                    print("the main data ios : $workFromHomeRecords");
                                    if (workFromHomeRecords.isEmpty) {
                                      return const Center(
                                        child:
                                        Text("No Leave Record Available!"),
                                      );
                                    }
                                    return ListView.builder(
                                      itemCount: workFromHomeRecords.length,
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      physics: const ScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            // Navigator.of(context).push(
                                            //     MaterialPageRoute(
                                            //         builder: (context) =>
                                            //             LeavesDetail(
                                            //                 data: leaves[
                                            //                     index])));
                                            Navigator.of(context).push(MaterialPageRoute(
                                              builder: (context) => Provider.value(
                                                value: bloc,
                                                child: WorkFromHomeDetail(data: workFromHomeRecords[index],responseButton: false,),
                                              ),
                                            ));
                                          },
                                          child: Container(
                                            // color: Colors.grey,
                                            // color: Colors.grey.withOpacity(0.04),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5, vertical: 10),
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Flexible(
                                                      child: Text(
                                                        "Work from home applied from ${workFromHomeRecords[index]["start_date"] ==null?workFromHomeRecords[index]["start_date"]:DateFormat.yMMMMd().format(DateTime.parse(workFromHomeRecords[index]['start_date'] ?? ""))}",
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                          FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 8,
                                                          vertical: 6),
                                                      decoration: BoxDecoration(
                                                        color: workFromHomeRecords[index]['status']! ==
                                                            "approve"
                                                            ? const Color(
                                                            0xff4BCD36)
                                                            : workFromHomeRecords[index]['status']! ==
                                                            "pending"
                                                            ? Colors.yellow
                                                            : Colors.red,
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(8),
                                                      ),
                                                      child: Text(
                                                        workFromHomeRecords[index]['status']=="pending" ? "Pending" : workFromHomeRecords[index]['status']=="reject" ? "Rejected" : workFromHomeRecords[index]['status']=="approve" ? "Approved" : "--",
                                                        // leaves[index].status ==
                                                        //         "approve"
                                                        //     ? "Approve"
                                                        //     : leaves[index]
                                                        //                 .status ==
                                                        //             "pending"
                                                        //         ? "Pending"
                                                        //         : "Rejected",
                                                        // leaves[index].status ?? "",
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                            FontWeight.w500,
                                                            color: workFromHomeRecords[index]['status']! ==
                                                                "pending"
                                                                ? Colors.black
                                                                : Colors.white),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  workFromHomeRecords[index]['updated_date']==null?workFromHomeRecords[index]['start_date'].toString():
                                                  DateFormat(
                                                      'MMMM dd,yyyy hh:mm a')
                                                      .format(DateTime.parse(
                                                      workFromHomeRecords[index]['updated_date']??
                                                          ""))
                                                  ,
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                      FontWeight.w500,
                                                      color: Colors.grey),
                                                ),
                                                Divider(
                                                  color: Colors.grey
                                                      .withOpacity(0.3),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  });
                            }),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
