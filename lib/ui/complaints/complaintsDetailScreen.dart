import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:intl/intl.dart';
import 'package:office/bloc/complaint_bloc.dart';
import 'package:office/data/model/complaint_list_model.dart';
import 'package:office/ui/widget/app_bar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/constants.dart';
import '../../utils/message_handler.dart';
import '../widget/app_button.dart';

class ComplaintRequestsDetails extends StatefulWidget {
  final ComplaintList complaint;
  final bool resolvedButton;
  const ComplaintRequestsDetails({Key? key, required this.complaint,required this.resolvedButton})
      : super(key: key);

  @override
  State<ComplaintRequestsDetails> createState() =>
      // ignore: no_logic_in_create_state
      _ComplaintRequestsDetailsState(complaint);
}

class _ComplaintRequestsDetailsState extends State<ComplaintRequestsDetails> {
  final ComplaintList complaint;
  late ComplaintBloc bloc;
  String uid="";
  int? uidValue;

  _ComplaintRequestsDetailsState(this.complaint);
  @override
  void initState() {
    bloc = context.read<ComplaintBloc>();
    super.initState();
    init();
    bloc.msgController!.stream.listen((event) {
      AppMessageHandler().showSnackBar(context, event);
    });
  }
  init()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid=prefs.getString('uid')??"";
    uidValue=int.tryParse(uid);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(title: 'Complaint Details'),
      backgroundColor: const Color(0xfff2f3f8),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(15.0),
                margin:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10))
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        Text(
                            DateFormat('EEE, d MMM y').format(
                                DateTime.parse("${complaint.createdDate}")),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black.withOpacity(0.7),
                              fontWeight: FontWeight.normal,
                            )),
                        Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6.0, vertical: 4.0),
                          decoration: BoxDecoration(
                            color: complaint.status == "inprocess"
                                ? Colors.green.withOpacity(0.5)
                                : Colors.red.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            complaint.status == "inprocess"
                                ? "In Process"
                                : "Resolved",
                            // '',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                                color: complaint.status == "inprocess"
                                    ? Colors.green
                                    : Colors.red),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text("${complaint.title}",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    Text(
                        complaint.compToValue == null
                            ? "${complaint.compTo}"
                            : "${complaint.firstName ?? ''} ${complaint.middleName ?? ''} ${complaint.lastName ?? ''}",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black.withOpacity(0.7),
                          fontWeight: FontWeight.normal,
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text("${complaint.desp}",
                          style: const TextStyle(
                            fontSize: 12,
                            color: K.textGrey,
                            fontWeight: FontWeight.normal,
                          )),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              if (complaint.response != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 20.0),
                  margin: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 5.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10))
                    ],
                  ),
                  child: Html(data: complaint.response),
                ),
              const SizedBox(
                height: 15,
              ),
              // fromRequests == "true" && complaint.status == "inprocess"
              //     ? Container(
              //         padding: const EdgeInsets.symmetric(
              //             horizontal: 15.0, vertical: 20.0),
              //         margin: const EdgeInsets.symmetric(
              //             vertical: 10.0, horizontal: 5.0),
              //         decoration: BoxDecoration(
              //           color: Colors.white,
              //           borderRadius: BorderRadius.circular(12.0),
              //           boxShadow: [
              //             BoxShadow(
              //                 color: Colors.grey.withOpacity(0.3),
              //                 blurRadius: 20,
              //                 offset: const Offset(0, 10))
              //           ],
              //         ),
              //         child: Column(
              //           children: [
              //             const Row(
              //               mainAxisAlignment: MainAxisAlignment.start,
              //               children: [
              //                 Text("Resolve",
              //                     style: TextStyle(
              //                         fontSize: 16,
              //                         fontWeight: FontWeight.w600,
              //                         fontFamily: "Poppins",
              //                         color: Color(0xFF253772))),
              //               ],
              //             ),
              //             const SizedBox(
              //               height: 12,
              //             ),
              //             TextFormField(
              //               style: const TextStyle(color: Colors.black),
              //               decoration: InputDecoration(
              //                 filled: true,
              //                 fillColor: const Color(0xffffffff),
              //                 errorBorder: OutlineInputBorder(
              //                   borderSide: BorderSide(
              //                       color: Colors.red.withOpacity(1)),
              //                   borderRadius: BorderRadius.circular(12),
              //                 ),
              //                 focusedErrorBorder: OutlineInputBorder(
              //                   borderSide: BorderSide(
              //                       color: Colors.red.withOpacity(1)),
              //                   borderRadius: BorderRadius.circular(12),
              //                 ),
              //                 contentPadding: const EdgeInsets.all(17.0),
              //                 focusedBorder: OutlineInputBorder(
              //                   borderSide: BorderSide(
              //                       color: const Color(0xff777777)
              //                           .withOpacity(0.8)),
              //                   borderRadius: BorderRadius.circular(12),
              //                 ),
              //                 enabledBorder: OutlineInputBorder(
              //                   borderSide: BorderSide(
              //                       color:
              //                           const Color(0xff777777).withOpacity(1)),
              //                   borderRadius: BorderRadius.circular(12),
              //                 ),
              //                 hintText: "Any message here..",
              //                 //filled: true,
              //                 // fillColor: const Color.fromRGBO(246, 246, 246, 1),
              //                 /*prefixIcon: Row(mainAxisSize: MainAxisSize.min,
              //               children: [
              //                 Padding(
              //                   padding: EdgeInsets.symmetric(horizontal: 14),
              //                   child: Image.asset("assets/images/lock.png",height: 21,width: 21,),
              //                 )
              //               ],),*/
              //                 focusColor: Colors.white,
              //                 counterStyle:
              //                     const TextStyle(color: Colors.white),
              //                 hintStyle: const TextStyle(
              //                     color: Colors.black,
              //                     fontSize: 12,
              //                     fontWeight: FontWeight.w400,
              //                     fontFamily: "Poppins"),
              //               ),
              //               validator: (value) {
              //                 if (value.toString().isEmpty) {
              //                   return "Message is required";
              //                 } else {}
              //               },
              //               onTap: () {},
              //             ),
              //             const SizedBox(
              //               height: 19,
              //             ),
              //             Row(
              //               children: [
              //                 ElevatedButton(
              //                   onPressed: () async {
              //                     /*var res= await respondLeaveRequestNotifier.respondLeaveRequest(leaveData["id"].toString(), "reject");
              //               if(res){
              //                 Navigator.pop(context,"refresh");
              //               }*/
              //                   },
              //                   style: ElevatedButton.styleFrom(
              //                       padding: const EdgeInsets.symmetric(
              //                           horizontal: 25, vertical: 10),
              //                       backgroundColor: const Color(0xFF253772),
              //                       shape: RoundedRectangleBorder(
              //                           borderRadius:
              //                               BorderRadius.circular(15.0))),
              //                   child: const Text(
              //                     "Reject",
              //                     style: TextStyle(
              //                         fontSize: 14,
              //                         fontWeight: FontWeight.w600,
              //                         fontFamily: "Poppins",
              //                         color: Colors.white),
              //                   ),
              //                 ),
              //                 const SizedBox(
              //                   width: 19,
              //                 ),
              //                 ElevatedButton(
              //                   onPressed: () async {
              //                     /*var res= await respondLeaveRequestNotifier.respondLeaveRequest(leaveData["id"].toString(), "approve");
              //               if(res){
              //                 Navigator.pop(context,"refresh");
              //               }*/
              //                   },
              //                   style: ElevatedButton.styleFrom(
              //                       padding: const EdgeInsets.symmetric(
              //                           horizontal: 25, vertical: 10),
              //                       backgroundColor: const Color(0xFF253772),
              //                       shape: RoundedRectangleBorder(
              //                           borderRadius:
              //                               BorderRadius.circular(15.0))),
              //                   child: const Text(
              //                     "Approve",
              //                     style: TextStyle(
              //                         fontSize: 14,
              //                         fontWeight: FontWeight.w400,
              //                         fontFamily: "Poppins",
              //                         color: Colors.white),
              //                   ),
              //                 ),
              //               ],
              //             )
              //           ],
              //         ),
              //       )
              //     : Container()
            ],
          ),
        ),
      ),
      bottomNavigationBar: widget.resolvedButton==true && uidValue!=widget.complaint.compBy?ValueListenableBuilder(
        valueListenable: bloc.isReviewComplainLoad,
        builder: (context, bool loading,__) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: AppButton(
              title: "Resolved",
              loading: loading?true:false,
              onTap: ()  {
                 bloc.reviewComplain(
                    "${widget.complaint.id}", 'resolve');
              },
              color: Colors.blue,
              margin: EdgeInsets.zero,
              // loading: loading,
            ),
          );
        }
      ):const SizedBox(),
    );
  }
}
