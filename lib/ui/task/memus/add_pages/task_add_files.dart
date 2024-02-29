import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:office/utils/message_handler.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../bloc/leads_bloc.dart';
import '../../../../bloc/task_bloc.dart';
import '../../../../data/repository/task_repo.dart';
import '../../../widget/custom_button.dart';



class TaskAddFiles extends StatefulWidget {
  final int taskId;
  final  taskBloc bloc;

  const TaskAddFiles({Key? key, required this.taskId, required this.bloc, }) : super(key: key);

  @override
  State<TaskAddFiles> createState() => _TaskAddFilesState();
}

class _TaskAddFilesState extends State<TaskAddFiles> {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool light = false;
  FilePickerResult? filePickerResult;
  File? galleryFile;
 // late taskBloc bloc;


  @override
  void initState() {
   // bloc =taskBloc(context.read<TaskRepositary>(), );
    super.initState();
    widget.bloc.fileStream.stream.listen((event) {
      if (event == 'streamFiles') {
        widget.bloc.fetchTaskDetails(widget.taskId,'task_file_details');
        Navigator.pop(context);
      }
    });
   widget.bloc.fileName.text ='';
   widget.bloc.filepath.text= '';
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
                  "Add Files",
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
                          padding: EdgeInsets.only(left: 10),
                          child: Row(
                            children: [
                              Text("File Name", style: TextStyle(fontSize: 13)),
                              Text("*", style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),)
                            ],
                          ),
                        ),
                        10.height,
                        Container(
                          height: 50,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                  width: 1, color: const Color(0xff777777))),
                          child: TextFormField(
                            style: const TextStyle(color: Colors.black),
                            keyboardType: TextInputType.multiline,
                            controller: widget.bloc.fileName,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "File Name",
                              focusColor: Colors.white,
                              counterStyle: TextStyle(color: Colors.white),
                              hintStyle: TextStyle(
                                  color: Color(0xff777777),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                  fontFamily: "Poppins"),
                            ),
                            onFieldSubmitted: (value) {
                              widget.bloc.fileName.text = value;
                            },
                            validator: (value) {
                              if (value.toString().isEmpty) {
                                widget.bloc.showMessage(MessageType.error("Please enter your file name."));
                              }
                              return null;
                            },
                          ),
                        ),
                        10.height,
                        const Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Row(
                            children: [
                              Text("Upload By", style: TextStyle(fontSize: 13)),
                              Text("*", style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),)
                            ],
                          ),
                        ),
                        10.height,
                        InkWell(
                          onTap: (){
                            openFilePicker();
                          },
                          child: Container(
                            height: 50,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(
                                    width: 1, color: const Color(0xff777777))),
                            child: TextFormField(
                              enabled: false,
                              style: const TextStyle(color: Colors.black),
                              keyboardType: TextInputType.multiline,
                              controller:widget.bloc.filepath,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Choose File",
                                focusColor: Colors.white,
                                counterStyle: TextStyle(color: Colors.white),
                                hintStyle: TextStyle(
                                    color: Color(0xff777777),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300,
                                    fontFamily: "Poppins"),
                              ),
                              onFieldSubmitted: (value) {
                                widget.bloc.filepath.text = value;
                              },
                              validator: (value) {
                                if (value.toString().isEmpty) {
                                  widget.bloc.showMessage(MessageType.error('Please select file'));
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        10.height,
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Row(
                                children: [
                                  Text("Private", style: TextStyle(fontSize: 13)),
                                  Text("*", style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),)
                                ],
                              ),
                            ),
                            Switch(
                              // This bool value toggles the switch.
                              value: light,
                              activeColor: Colors.blue,
                              onChanged: (bool value) {
                                // This is called when the user toggles the switch.
                                setState(() {
                                  light = value;
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 20,),
                        ValueListenableBuilder(
                          valueListenable: widget.bloc.addfileLoading,
                          builder: (BuildContext context, bool loading, Widget? child) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                loading
                                    ? CircularProgressIndicator()
                                    : CustomButton2(
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        widget.bloc.addFiles(widget.taskId,light?'yes':'no');
                                      }
                                    },
                                    tittle: 'Add Files'),
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
  Future<void> openFilePicker() async{
    filePickerResult = await FilePicker.platform.pickFiles();
    galleryFile = File(filePickerResult!.files.single.path!);
    widget.bloc.image = galleryFile;
    widget.bloc.filepath.text = galleryFile!.path.split('/').last;
  }
}
