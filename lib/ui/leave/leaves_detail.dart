import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:office/data/model/LeaveRecord.dart';
import 'package:office/ui/widget/app_bar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../bloc/leave_bloc.dart';
import '../../utils/message_handler.dart';
import '../widget/app_button.dart';

class LeavesDetail extends StatefulWidget {
  const LeavesDetail({Key? key, required this.data,required this.responseButton}) : super(key: key);
  final LeaveRecord data;
  final bool responseButton;

  @override
  State<LeavesDetail> createState() => _LeavesDetailState();
}

class _LeavesDetailState extends State<LeavesDetail> {
  late LeaveBloc bloc;
  String uid="";


  @override
  void initState() {
    bloc = context.read<LeaveBloc>();
    super.initState();
    init();
    bloc.msgController!.stream.listen((event) {
      AppMessageHandler().showSnackBar(context, event);
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
                  "Leave Details",
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
                                    widget.data.reasonTitle ?? "",
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
                                    color: widget.data.status! == "approve"
                                        ? Color(0xff4BCD36)
                                        : widget.data.status! == "pending"
                                            ? Colors.yellow
                                            : Colors.red,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    widget.data.status == "pending"
                                        ? "Pending"
                                        : widget.data.status == "reject"
                                            ? "Rejected"
                                            : widget.data.status == "approve"
                                                ? "Approved"
                                                : "--",
                                    // data.status ?? "",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: widget.data.status! == "pending"
                                            ? Colors.black
                                            : Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            if (widget.data.leaveCategory != null)
                              IconTittle(
                                icon: Icons.category,
                                tittle: widget.data.leaveCategory ?? "",
                              ),
                            IconTittle(
                                icon: Icons.calendar_month,
                                tittle: widget.data.endDate != null
                                    ? "${widget.data.startDate==null?widget.data.startDate:DateFormat.yMMMMd().format(DateTime.parse(widget.data.startDate ?? ""))} To ${DateFormat.yMMMMd().format(DateTime.parse(widget.data.endDate ?? ""))}"
                                    :widget.data.endDate==null?widget.data.endDate.toString(): DateFormat.yMMMMd().format(DateTime.parse(
                                        widget.data.endDate ?? ""))),
                            if (widget.data.durationType != null)
                              IconTittle(
                                icon: Icons.merge_type,
                                tittle: widget.data.durationType ?? "",
                              ),
                            if (widget.data.approvedBy != null)
                              IconTittle(
                                icon: Icons.verified_user_outlined,
                                tittle: widget.data.approvedBy ?? "",
                              ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              widget.data.reason ?? "",
                              style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: widget.data.status! == "pending" && widget.responseButton==true  && uid!=widget.data.userId
          ? Row(
              children: [
                const SizedBox(
                  width: 5,
                ),
                ValueListenableBuilder(
                    valueListenable: bloc.isResponseApproveLoad,
                    builder: (context, bool loading, __) {
                      return Expanded(
                        child: AppButton(
                          title: "Approve",
                          loading: loading?true:false,
                          onTap: () {
                            print(
                                "leave id: ${widget.data.id}, status : approve");
                            bloc.respondLeaveRequest(
                                "${widget.data.id}", 'approve');
                          },
                          color: const Color(0xff4BCD36),
                          margin: EdgeInsets.zero,
                          // loading: loading,
                        ),
                      );
                    }),
                const SizedBox(
                  width: 5,
                ),
                ValueListenableBuilder(
                    valueListenable: bloc.isResponseRejectLoad,
                    builder: (context, bool loading, __) {
                      return Expanded(
                        child: AppButton(
                          title: "Reject",
                          loading: loading?true:false,
                          onTap: () {
                            print(
                                "leave id: ${widget.data.id}, status : reject");
                            bloc.respondLeaveRequest(
                                "${widget.data.id}", 'reject');
                          },
                          color:  Colors.red,
                          margin: EdgeInsets.zero,
                          // loading: loading,
                        ),
                      );
                    }),
                const SizedBox(
                  width: 5,
                ),
              ],
            )
          : const SizedBox(),
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
