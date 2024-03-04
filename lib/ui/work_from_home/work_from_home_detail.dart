import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:office/bloc/work_from_home_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/repository/work_from_home_repository.dart';
import '../../utils/message_handler.dart';
import '../widget/app_button.dart';
import 'work_form_home_editwork.dart';

class WorkFromHomeDetail extends StatefulWidget {
  const WorkFromHomeDetail({Key? key, required this.data,required this.responseButton}) : super(key: key);
  final Map data;
  final bool responseButton;

  @override
  State<WorkFromHomeDetail> createState() => _WorkFromHomeDetailState();
}

class _WorkFromHomeDetailState extends State<WorkFromHomeDetail> {
  late WorkFromHomeBloc bloc;
  @override
  void initState() {
    bloc =context.read<WorkFromHomeBloc>();
    super.initState();
    bloc.CancelStream.stream.listen((event) {
      if (event == 'Post') {
        bloc.getWorkFromHomeRecords();
        Navigator.pop(context);
      }
    });
    bloc.msgController!.stream.listen((event) {
      AppMessageHandler().showSnackBar(context, event);
    });
  }
  void showDialogBoxcancel(){
    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text('Confirm',style: TextStyle(color: Colors.black),),
        content: Text('Are You Sure?',style: TextStyle(color: Colors.black),),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(onPressed: (){Navigator.pop(context);}, child: Text('No',style: TextStyle(color: Colors.black),)),
              ValueListenableBuilder(
                valueListenable: bloc.isCancelLoading,
                builder: (context, value, child) {
                  return ElevatedButton(
                      style:ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          shape: BeveledRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5))
                          )
                      ),
                      onPressed: (){
                        bloc.CanelLeave(widget.data['id']);
                        Navigator.pop(context);
                      }, child: Text('Yes',style: TextStyle(color: Colors.white),));
                },
              )
            ],
          )
        ],
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                               return SizedBox(
                                width: 100,
                                 child: OutlinedButton(
                                  style: ElevatedButton.styleFrom(side: BorderSide(color: Colors.red,width: 0),shape: BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(3)))),
                                   onPressed: (){
                                    showDialogBoxcancel();
                                 }, child: Text('Cancel',style: TextStyle(color: Colors.red),)),
                              );
                             },
                             ),
                            SizedBox(
                               width: 100,
                                 child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  side: BorderSide(color: Colors.green,width: 0),shape: BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(3)))),
                                   onPressed: (){
                                    Navigator.push(
                                   context,
                                    MaterialPageRoute(
                                     builder: (_) => Provider.value(
                                      value: bloc,
                                     child: EditworkPage(data: widget.data,),
                                     )),
                                    );
                                   }, child: Text('Edit',style: TextStyle(color: Colors.white),)),
                                 ),
                               ],
                               ):Container(
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
