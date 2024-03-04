import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:office/bloc/leave_bloc.dart';
import 'package:office/bloc/work_from_home_bloc.dart';
import 'package:office/ui/widget/app_button.dart';
import 'package:office/ui/widget/app_dropdown.dart';
import 'package:office/ui/widget/app_text_field.dart';
import 'package:provider/provider.dart';

import '../../utils/message_handler.dart';

class ApplyWorkFromHome extends StatefulWidget {
  const ApplyWorkFromHome({Key? key}) : super(key: key);

  @override
  State<ApplyWorkFromHome> createState() => _ApplyWorkFromHomeState();
}

class _ApplyWorkFromHomeState extends State<ApplyWorkFromHome> {

  late WorkFromHomeBloc bloc;

  @override
  void initState() {
    bloc = context.read<WorkFromHomeBloc>();
    super.initState();
    bloc.msgController!.stream.listen((event) {
      AppMessageHandler().showSnackBar(context, event);
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
                    bottomRight: Radius.circular(20))
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 56,),
                Text(
                  "Request Work Form Home",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                  ),
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
                child: Icon(Icons.arrow_back, size: 18,),
              ),
            ),
          ),
          Column(
            children: [
              const SizedBox(height: 100,),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Form(
                      key: bloc.formKey,
                      child: Column(
                        children: [
                          AppDropdown(
                            items: bloc.durationType.map((e) => DropdownMenuItem(value: '${e['value']}', child: Text("${e['title']}"))
                            ).toList(),
                            onChanged: (v) {bloc.updateDT(v);},
                            value: bloc.selectedDurationType.value,
                            hintText: "Select Duration Type",
                          ),
                          const SizedBox(height: 10),

                          const SizedBox(height: 10),
                          AppTextField(
                            controller: bloc.reasonTitle,
                            title: "Reason Title",
                            validate: true,
                          ),
                          const SizedBox(height: 10),
                          AppTextField(
                            controller: bloc.reason,
                            title: "Reason Description",
                            validate: true,
                            maxLines: 5,
                            inputAction: TextInputAction.done,
                          ),
                          const SizedBox(height: 10),
                          ValueListenableBuilder(
                              valueListenable: bloc.startDate,
                              builder: (context, DateTime? date, _) {
                                return InkWell(
                                  onTap: () async {
                                    DateTime? dt = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate:  DateTime.now().add(Duration(days: 30)),);
                                    if(dt!=null) {
                                      bloc.updateStartDate(dt);
                                    }
                                  },
                                  child: Container(
                                    height: 50,
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(PhosphorIcons.clock),
                                        const SizedBox(width: 15),
                                        Text(date==null ? "Select Date" : DateFormat('MMM dd, yyyy').format(date), style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),),
                                      ],
                                    ),
                                  ),
                                );
                              }
                          ),
                          ValueListenableBuilder(
                            valueListenable: bloc.selectedDurationType,
                            builder: (context, String? durationType, _) {
                              if(durationType=='multiple') {
                                return ValueListenableBuilder(
                                  valueListenable: bloc.endDate,
                                  builder: (context, DateTime? date, _) {
                                    return Column(
                                      children: [
                                        const SizedBox(height: 10),
                                        InkWell(
                                          onTap: () async {
                                            DateTime? dt = await showDatePicker(context: context, initialDate: DateTime.now().add(Duration(days: 2)), firstDate: DateTime.now().add(Duration(days: 2)), lastDate:  DateTime.now().add(Duration(days: 30)),);
                                            if(dt!=null) {
                                              bloc.updateEndDate(dt);
                                            }
                                          },
                                          child: Container(
                                            height: 50,
                                            padding: const EdgeInsets.symmetric(horizontal: 20),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[100],
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            child: Row(
                                              children: [
                                                const Icon(PhosphorIcons.clock),
                                                const SizedBox(width: 15),
                                                Text(date==null ? "Select End Date" : DateFormat('MMM dd, yyyy').format(date), style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                ),),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                              return const SizedBox();
                            },
                          ),
                          const SizedBox(height: 10),
                          ValueListenableBuilder(
                              valueListenable: bloc.requesting,
                              builder: (context, bool loading, _) {
                                return AppButton(
                                  title: "Request",
                                  onTap: ()=> bloc.applyForWFH(),
                                  margin: EdgeInsets.zero,
                                  loading: loading,
                                );
                              }
                          ),
                        ],
                      ),
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
}
