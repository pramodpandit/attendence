import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:office/data/model/LeaveRecord.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../bloc/leave_bloc.dart';
import '../../../utils/message_handler.dart';
import '../../bloc/work_from_home_bloc.dart';
import '../../data/repository/work_from_home_repository.dart';
import '../widget/app_button.dart';
import '../widget/custom_button.dart';



import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:office/bloc/work_from_home_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/message_handler.dart';
import '../widget/app_button.dart';


class Workfmhr extends StatefulWidget {
  const Workfmhr({Key? key, required this.data,required this.responseButton}) : super(key: key);
  final Map data;
  final bool responseButton;

  @override
  State<Workfmhr> createState() => _WorkfmhrState();
}

class _WorkfmhrState extends State<Workfmhr> {
  late WorkFromHomeBloc bloc;
  String uid="";

  @override
  void initState() {
    bloc = context.read<WorkFromHomeBloc>();
    super.initState();
    init();
    bloc.msgController!.stream.listen((event) {
      AppMessageHandler().showSnackBar(context, event);
    });
    bloc.CancelStream.stream.listen((event) {
      if (event == 'Post') {
        bloc.getWorkFromHomeRecords();
        Navigator.pop(context);
        Navigator.pop(context);
      }
    });
  }
  init()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid=prefs.getString('uid')??"";
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: const MyAppBar(title: "Leave Details"),
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
                  "Work from home details",
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
          Column(
            children: [
              const SizedBox(
                height: 100,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                          padding: const EdgeInsets.only(
                              left: 25, right: 25, top: 10, bottom: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      widget.data['reason_title'] ?? "",
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: widget.data['status']! == "approve"
                                          ? Color(0xff4BCD36)
                                          : widget.data['status']! == "pending"
                                          ? Colors.yellow
                                          : Colors.red,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      widget.data['status'] == "pending"
                                          ? "Pending"
                                          : widget.data['status'] == "reject"
                                          ? "Rejected"
                                          : widget.data['status'] == "approve"
                                          ? "Approved"
                                          : "--",
                                      // data.status ?? "",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: widget.data['status']! == "pending"
                                              ? Colors.black
                                              : Colors.white),
                                    ),
                                  ),
                                ],
                              ),

                              IconTittle(
                                  icon: Icons.calendar_month,
                                  tittle: widget.data['end_date']==null?DateFormat.yMMMMd().format(DateTime.parse(widget.data['start_date'] ?? "")):
                                  '${DateFormat.yMMMMd().format(DateTime.parse(widget.data['start_date'] ?? ""))} to ${DateFormat.yMMMMd().format(DateTime.parse(widget.data['end_date'] ?? ""))}'),
                              if (widget.data['duration_type'] != null)
                                IconTittle(
                                  icon: Icons.merge_type,
                                  tittle: widget.data['duration_type'] ?? "",
                                ),
                              if (widget.data['approved_by'] != null)
                                IconTittle(
                                  icon: Icons.verified_user_outlined,
                                  tittle: widget.data['approved_by'] ?? "",
                                ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                widget.data['reason'] ?? "",
                                style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400),
                              ),
                              SizedBox(height: 10,),
                              widget.data['status'] == "pending"?
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  ValueListenableBuilder(
                                    valueListenable: bloc.isCancelLoading,
                                    builder: (context, value, child) {
                                      return OutlinedButton(
                                          style: ElevatedButton.styleFrom(side: BorderSide(color: Colors.red,width: 0),shape: BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(3)))),
                                          onPressed: (){
                                            // showDialog(context: context, builder: (context){
                                            //   return AlertDialog(
                                            //     title: Text('Remark'),
                                            //     content:  Container(
                                            //       height: 200,
                                            //       padding: const EdgeInsets.all(10),
                                            //       decoration: BoxDecoration(
                                            //           borderRadius: BorderRadius.circular(20.0),
                                            //           border: Border.all(
                                            //               width: 1, color: const Color(0xff777777))),
                                            //       child: TextFormField(
                                            //         style: const TextStyle(color: Colors.black),
                                            //         keyboardType: TextInputType.multiline,
                                            //         controller: bloc.remark,
                                            //         maxLines: null,
                                            //         decoration: const InputDecoration(
                                            //           border: InputBorder.none,
                                            //           hintText: "Write here...",
                                            //           focusColor: Colors.white,
                                            //           counterStyle: TextStyle(color: Colors.white),
                                            //           hintStyle: TextStyle(
                                            //               color: Color(0xff777777),
                                            //               fontSize: 12,
                                            //               fontWeight: FontWeight.w300,
                                            //               fontFamily: "Poppins"),
                                            //         ),
                                            //         onFieldSubmitted: (value) {
                                            //           bloc.remark.text = value;
                                            //         },
                                            //         validator: (value) {
                                            //           if (value.toString().isEmpty) {
                                            //             return "Please enter your remark.";
                                            //           }
                                            //           return null;
                                            //         },
                                            //       ),
                                            //     ),
                                            //     actions: [
                                            //       ValueListenableBuilder(
                                            //         valueListenable: bloc.isResponseApproveLoad,
                                            //         builder: (BuildContext context, bool loading,
                                            //             Widget? child) {
                                            //           return Row(
                                            //             mainAxisAlignment: MainAxisAlignment.center,
                                            //             children: [
                                            //               loading
                                            //                   ? CircularProgressIndicator()
                                            //                   : SizedBox(
                                            //                       width:MediaQuery.of(context).size.height*0.29,
                                            //                     child: CustomButton2(
                                            //                     onPressed: () {
                                            //                       if (formKey.currentState!.validate()) {
                                            //                         bloc.AddRemarkLeave(editData.id!.toInt());
                                            //                         bloc.CanelLeave(int.parse(widget.data.id.toString()));
                                            //                       }
                                            //                     },
                                            //                     tittle: 'Add Remark'),
                                            //                   ),
                                            //             ],
                                            //           );
                                            //         },
                                            //       ),
                                            //     ],
                                            //   );
                                            // });
                                            showdialogremark(1);
                                          }, child: Text('Reject',style: TextStyle(color: Colors.red),));
                                    },
                                  ),
                                  ValueListenableBuilder(
                                    valueListenable: bloc.isApprovedLoading,
                                    builder: (context, value, child) {
                                      return ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.green,
                                              side: BorderSide(color: Colors.green,width: 0),shape: BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(3)))),
                                          onPressed: (){
                                            showdialogremark(2);
                                            // bloc.ApprovedLeave(widget.data.id!.toInt());
                                          }, child: Text('Approved',style: TextStyle(color: Colors.white),));
                                    },
                                  ),
                                ],
                              ) :Container(
                                child:Row(
                                  children: [
                                    SizedBox(
                                        height:25,
                                        width: 25,
                                        child: Image.asset('images/img_2.png',color: Colors.grey,)),
                                    SizedBox(width: 10,),
                                    widget.data['remark'] == null ?Offstage(): Text(widget.data['remark'].toString())
                                  ],
                                ),
                              )
                            ],
                          )
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  void showdialogremark(int value1){
    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text('Remark'),
        content:  Container(
          height: 200,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(
                  width: 1, color: const Color(0xff777777))),
          child: TextFormField(
            style: const TextStyle(color: Colors.black),
            keyboardType: TextInputType.multiline,
            controller: bloc.remark,
            maxLines: null,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: "Write here...",
              focusColor: Colors.white,
              counterStyle: TextStyle(color: Colors.white),
              hintStyle: TextStyle(
                  color: Color(0xff777777),
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                  fontFamily: "Poppins"),
            ),
            onFieldSubmitted: (value) {
              bloc.remark.text = value;
            },
            validator: (value) {
              if (value.toString().isEmpty) {
                return "Please enter your remark.";
              }
              return null;
            },
          ),
        ),
        actions: [
          ValueListenableBuilder(
            valueListenable: bloc.isResponseApproveLoad,
            builder: (BuildContext context, bool loading,
                Widget? child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  loading
                      ? CircularProgressIndicator()
                      : SizedBox(
                    width:MediaQuery.of(context).size.height*0.29,
                    child: CustomButton2(
                        onPressed: () {
                          if (bloc.remark.text !='') {
                            bloc.AddRemarkLeave(widget.data['id']).then((data) {
                              if(data == true){
                                if(value1 == 1){
                                  bloc.CanelLeave(widget.data['id']);
                                }else if(value1 ==2){
                                  bloc.Approvedwfh(widget.data['id']);
                                }
                              }

                            });
                          }else{
                            bloc.showMessage(const MessageType.info("Please enter your remark"));
                          }
                        },
                        tittle: 'Add Remark'),
                  ),
                ],
              );
            },
          ),
        ],
      );
    });
  }
}

class IconTittle extends StatelessWidget {
  const IconTittle({Key? key, required this.tittle, required this.icon})
      : super(key: key);
  final String tittle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: Colors.grey.withOpacity(0.9),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(
              tittle,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey.withOpacity(0.9),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
