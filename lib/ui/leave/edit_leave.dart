import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:office/bloc/leave_bloc.dart';
import 'package:office/ui/widget/app_button.dart';
import 'package:office/ui/widget/app_dropdown.dart';
import 'package:office/ui/widget/app_text_field.dart';
import 'package:provider/provider.dart';

import '../../data/model/LeaveRecord.dart';

class EditLeavePage extends StatefulWidget {
  final LeaveRecord data;
  const EditLeavePage({Key? key, required this.data}) : super(key: key);

  @override
  State<EditLeavePage> createState() => _EditLeavePageState();
}

class _EditLeavePageState extends State<EditLeavePage> {
  late LeaveBloc bloc;
  File? galleryFile;
  FilePickerResult? filePickerResult;

  @override
  void initState() {
    bloc = context.read<LeaveBloc>();
    super.initState();
    bloc.leaveEditController.stream.listen((event) {
      if (event == 'LEAVE_Edit') {
        bloc.getLeaveCategory();
        bloc.getLeaveRecords();
        Navigator.pop(context);
        Navigator.pop(context);
      }
    });
    bloc.startDateEdit.value = DateTime.parse(widget.data.startDate.toString());
    bloc.endDateEdit.value = DateTime.parse(widget.data.endDate ==null?DateTime.now().toString():widget.data.endDate.toString());
    bloc.reasonTitleEdit.text = widget.data.reasonTitle.toString();
    bloc.reasonEdit.text = widget.data.reason.toString();
    bloc.selectedDurationType.value = widget.data.durationType;
    bloc.selectedLeaveCategory = widget.data.leaveType;
    bloc.leaveId.value = widget.data.id;
    bloc.filepath.text =widget.data.document.toString();
  }
  Future<void> _openImagePicker(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        galleryFile = File(pickedFile.path);
        bloc.image = galleryFile;
        bloc.filepath.text = pickedFile.path.toString().split('/').last;
      });
    }
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
                  "Edit Leave",
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
                          AppDropdown(
                            items: bloc.leaveCategories.map((e) => DropdownMenuItem(value: '${e.id}', child: Text("${e.name}"))
                            ).toList(),
                            onChanged: (v) {bloc.updateLC(v);},
                            value: bloc.selectedLeaveCategory,
                            hintText: widget.data.leaveCategory ==''?"Select Leave Category":widget.data.leaveCategory.toString(),
                          ),
                          const SizedBox(height: 10),
                          AppTextField(
                            controller: bloc.reasonTitleEdit,
                            title: "Reason Title",
                            validate: true,
                          ),
                          const SizedBox(height: 10),
                          AppTextField(
                            controller: bloc.reasonEdit,
                            title: "Reason Description",
                            validate: true,
                            maxLines: 5,
                            inputAction: TextInputAction.done,
                          ),
                          const SizedBox(height: 10),
                          ValueListenableBuilder(
                              valueListenable: bloc.startDateEdit,
                              builder: (context, DateTime? date, _) {
                                return InkWell(
                                  onTap: () async {
                                    DateTime? dt = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate:  DateTime.now().add(Duration(days: 30)),);
                                    if(dt!=null) {
                                      bloc.updateStartEditDate(dt);
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
                              if(durationType=='multiple' || widget.data.durationType =='multiple' ) {
                                return ValueListenableBuilder(
                                  valueListenable: bloc.endDateEdit,
                                  builder: (context, DateTime? date, _) {
                                    return Column(
                                      children: [
                                        const SizedBox(height: 10),
                                        InkWell(
                                          onTap: () async {
                                            DateTime? dt = await showDatePicker(context: context, initialDate: DateTime.now().add(Duration(days: 2)), firstDate: DateTime.now().add(Duration(days: 2)), lastDate:  DateTime.now().add(Duration(days: 30)),);
                                            if(dt!=null) {
                                              bloc.updateEndEditDate(dt);
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
                          InkWell(
                            onTap: (){
                              openFilePicker();
                              // _openImagePicker(ImageSource.gallery);
                            },
                            child:AppTextField(
                              enabled: false,
                              controller: bloc.filepath,
                              title: "Attach File",
                              validate: false,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ValueListenableBuilder(
                              valueListenable: bloc.requesting,
                              builder: (context, bool loading, _) {
                                return AppButton(
                                  title: "Update",
                                  onTap: bloc.EditForLeave,
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
  Future<void> openFilePicker() async{
    filePickerResult = await FilePicker.platform.pickFiles(
    );
    galleryFile = File(filePickerResult!.files.single.path!);
    bloc.image = galleryFile;
    bloc.filepath.text = galleryFile!.path.split('/').last;
  }
}
