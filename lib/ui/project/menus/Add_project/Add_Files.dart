import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:office/ui/widget/custom_button.dart';
import 'package:office/utils/message_handler.dart';
import 'package:provider/provider.dart';
import '../../../../bloc/project_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:office/ui/widget/app_text_field.dart';



class Add_Files extends StatefulWidget {
  final String branch_id;
  final int projectid;
  const Add_Files({Key? key, required this.projectid, required this.branch_id}) : super(key: key);

  @override
  State<Add_Files> createState() => _Add_FilesState();
}

class _Add_FilesState extends State<Add_Files> {
  late ProjectBloc bloc;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  int _selectedValue = 1;
  bool light = false;
  FilePickerResult? filePickerResult;
  File? galleryFile;


  @override
  void initState() {
    bloc = context.read<ProjectBloc>();
    super.initState();
    bloc.fileName.text = '';
    bloc.msgController?.stream.listen((event) {
      AppMessageHandler().showSnackBar(context, event);
    });
    bloc.fileStream.stream.listen((event) {
      if (event == 'streamFiles') {
        bloc.fetchProjectsDetails(widget.projectid);
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: const MyAppBar(
      //   title: "Give Feedback",
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
                            controller: bloc.fileName,
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
                              bloc.fileName.text = value;
                            },
                            validator: (value) {
                              if (value.toString().isEmpty) {
                               bloc.showMessage(MessageType.error("Please enter your file name."));
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
                            // _openImagePicker(ImageSource.gallery);
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
                            controller: bloc.filepath,
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
                              bloc.filepath.text = value;
                            },
                            validator: (value) {
                              if (value.toString().isEmpty) {
                                bloc.showMessage(MessageType.error('Please select file'));
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
                        const SizedBox(
                          height: 20,
                        ),

                        ValueListenableBuilder(
                          valueListenable: bloc.addfileLoading,
                          builder: (BuildContext context, bool loading,
                              Widget? child) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                loading
                                    ? CircularProgressIndicator()
                                    : CustomButton2(
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        bloc.addFiles(widget.projectid,light?'yes':'no');
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
    bloc.image = galleryFile;
    bloc.filepath.text = galleryFile!.path.split('/').last;
  }
}
