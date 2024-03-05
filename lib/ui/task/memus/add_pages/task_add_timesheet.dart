import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:nb_utils/nb_utils.dart';
import 'package:office/utils/message_handler.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../bloc/leads_bloc.dart';
import '../../../../bloc/task_bloc.dart';
import '../../../../data/repository/task_repo.dart';
import '../../../widget/app_dropdown.dart';
import '../../../widget/custom_button.dart';
import 'package:office/ui/widget/app_text_field.dart';




class TaskAddTimeSheet extends StatefulWidget {
  final int taskId;
  final  taskBloc bloc;

  const TaskAddTimeSheet({Key? key, required this.taskId, required this.bloc, }) : super(key: key);

  @override
  State<TaskAddTimeSheet> createState() => _TaskAddTimeSheetState();
}

class _TaskAddTimeSheetState extends State<TaskAddTimeSheet> {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool light = false;
  FilePickerResult? filePickerResult;
  File? galleryFile;


  @override
  void initState() {
    super.initState();
    widget.bloc.comment.text ='';
    widget.bloc.fetchexpensePaymentType();
    widget.bloc.timesheetStream.stream.listen((event) {
      if (event == 'timesheetStream') {
        widget.bloc.fetchTaskDetails(widget.taskId,'task_timesheet');
        Navigator.pop(context);
      }
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
                  "Add Timesheet",
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
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 25),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 1),
                          child: Row(
                            children: [
                              Text("Employee", style: TextStyle(fontSize: 13)),
                              Text("*", style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),)
                            ],
                          ),
                        ),

                        ValueListenableBuilder(
                          valueListenable: widget.bloc.employelist,
                          builder: (context, paymentType, child) {
                            if(paymentType ==null){
                              return  AppDropdown(
                                items: [],
                                onChanged: (v) {widget.bloc.updateemployelist.value = v;},
                                value: null,
                                hintText: "Select",
                              );
                            }
                            if(paymentType.isEmpty){
                              return SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.7,
                                  child: Center(child: Text("No data available")));
                            }
                            return  AppDropdown(
                              items: paymentType!.map((e) => DropdownMenuItem(value: '${int.parse(e['user_id'])}', child: Text('${e['first_name']??""} ${e['last_name']??''}'))
                              ).toList(),
                              onChanged: (v) {widget.bloc.updateemployelist.value = v;},
                              value: widget.bloc.updateemployelist.value,
                              hintText: "Select",
                            );
                          },

                        ),
                        SizedBox(height: 15,),
                        const Padding(
                          padding: EdgeInsets.only(left: 1),
                          child: Row(
                            children: [
                              Text("Start Time", style: TextStyle(fontSize: 13)),
                              Text("*", style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),)
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            _selectStartTime(context);
                          },
                          child: Container(
                              height: 50,
                              width:MediaQuery.of(context).size.width*0.9,
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.all(Radius.circular(10))
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 15,left: 10),
                                child: Text('${widget.bloc.startTime.hour} : ${widget.bloc.startTime.minute}',style: TextStyle(fontWeight: FontWeight.w500),),
                              ))
                        ),
                        SizedBox(height: 15,),
                        const Padding(
                          padding: EdgeInsets.only(left: 1),
                          child: Row(
                            children: [
                              Text("End Time", style: TextStyle(fontSize: 13)),
                              Text("*", style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),)
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                          _selectEndTime(context);
                          },
                          child: Container(
                            height: 50,
                              width:MediaQuery.of(context).size.width*0.9,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.all(Radius.circular(10))
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 15,left: 10),
                                child: Text('${widget.bloc.endTime.hour} : ${widget.bloc.endTime.minute}',style: TextStyle(fontWeight: FontWeight.w500),),
                              ))
                        ),
                        SizedBox(height: 15,),
                        const Padding(
                          padding: EdgeInsets.only(left: 1),
                          child: Row(
                            children: [
                              Text("Memo", style: TextStyle(fontSize: 13)),
                              Text("*", style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),)
                            ],
                          ),
                        ),
                        Container(
                          height: 100,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                  width: 1, color: const Color(0xff777777))),
                          child: TextFormField(
                            maxLines: 10,
                            style: const TextStyle(color: Colors.black),
                            keyboardType: TextInputType.multiline,
                            controller: widget.bloc.memo,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Notes",
                              focusColor: Colors.white,
                              counterStyle: TextStyle(color: Colors.white),
                              hintStyle: TextStyle(
                                  color: Color(0xff777777),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                  fontFamily: "Poppins"),
                            ),
                            onFieldSubmitted: (value) {
                              widget.bloc.memo.text = value;
                            },
                            validator: (value) {
                              if (value.toString().isEmpty) {
                                return "Please enter your memo.";
                                // widget.bloc.showMessage(MessageType.error("Please enter your file name."));
                              }
                              return null;
                            },
                          ),
                        ),
                       SizedBox(height: 15,),
                        // const Padding(
                        //   padding: EdgeInsets.only(left: 1),
                        //   child: Row(
                        //     children: [
                        //       Text("Hour Logged", style: TextStyle(fontSize: 13)),
                        //       Text("*", style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),)
                        //     ],
                        //   ),
                        // ),
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                            onTap: (){
                            widget.bloc.HourLogged.text =  _calculateTimeDifference(widget.bloc.startTime,widget.bloc.endTime);
                            },
                            child: AppTextField(enabled: false,controller: widget.bloc.HourLogged, title: 'Hour Logged')),
                        const SizedBox(height: 20,),
                        ValueListenableBuilder(
                          valueListenable: widget.bloc.addtimesheetLoading,
                          builder: (BuildContext context, bool loading, Widget? child) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                loading
                                    ? CircularProgressIndicator()
                                    : CustomButton2(
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        widget.bloc.addTimeSheet(widget.taskId,);
                                      }
                                    },
                                    tittle: 'Add Timesheet'),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: widget.bloc.startTime,
    );
    if (picked != null && picked != widget.bloc.startTime) {
      setState(() {
        widget.bloc.startTime = picked;
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: widget.bloc.endTime,
    );
    if (picked != null && picked != widget.bloc.startTime) {
      setState(() {
        widget.bloc.endTime = picked;
      });
    }
  }

  String _calculateTimeDifference(TimeOfDay startTime, TimeOfDay endTime) {
    final startDateTime = DateTime(0, 1, 1, startTime.hour, startTime.minute);
    final endDateTime = DateTime(0, 1, 1, endTime.hour, endTime.minute);
    final difference = endDateTime.difference(startDateTime);
    final hours = difference.inHours.abs();
    final minutes = difference.inMinutes.remainder(60).abs();
    return '$hours : $minutes ';
  }
}
