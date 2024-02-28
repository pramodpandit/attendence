import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:office/ui/widget/custom_button.dart';
import 'package:office/utils/message_handler.dart';
import 'package:provider/provider.dart';
import '../../../../bloc/project_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:office/ui/widget/app_text_field.dart';



class Add_Expenses extends StatefulWidget {
  final String branch_id;
  final int projectid;
  const Add_Expenses({Key? key, required this.projectid, required this.branch_id}) : super(key: key);

  @override
  State<Add_Expenses> createState() => _Add_ExpensesState();
}

class _Add_ExpensesState extends State<Add_Expenses> {
  late ProjectBloc bloc;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  int _selectedValue = 1;
  bool light = false;
  FilePickerResult? filePickerResult;
  File? galleryFile;
  final MultiSelectController _controller = MultiSelectController();


  @override
  void initState() {
    bloc = context.read<ProjectBloc>();
    super.initState();
    bloc.fileName.text = '';
    bloc.fetchAddMemberLit(int.parse(widget.branch_id));
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
                  "Add Expenses",
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
                  child: SingleChildScrollView(
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
                                Text("Item Name", style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500)),
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
                                hintText: "Item Name",
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
                            padding: EdgeInsets.only(left: 1),
                            child: Row(
                              children: [
                                Text("Purchase Date", style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500)),
                                Text("*", style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),)
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          ValueListenableBuilder(
                              valueListenable: bloc.PurchaseDate,
                              builder: (context, DateTime? date, _) {
                                return InkWell(
                                  onTap: () async {
                                    DateTime? dt = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now().subtract(Duration(days: 15)), lastDate:  DateTime.now().add(Duration(days: 30)),);
                                    if(dt!=null) {
                                      await bloc.updateDateStart(dt);
                                    }
                                  },
                                  child: Container(
                                    height: 50,
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    decoration: BoxDecoration(
                                     border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.all(Radius.circular(5)),
                                    ),
                                    child: Row(
                                      children: [
                                        Text(date==null ?  DateFormat('MMM dd, yyyy').format(DateTime.now()) : DateFormat('MMM dd, yyyy').format(date), style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),),
                                      ],
                                    ),
                                  ),
                                );
                              }
                          ),
                      10.height,
                      Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 1),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Employee",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
                                Text("*", style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),)
                              ],
                            ),
                          ),
                          10.height,
                          ValueListenableBuilder(
                            valueListenable: bloc.allProjectsMemberList,
                            builder: (context, member, child) {
                              if(member ==null){
                                return SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.7,
                                    child: Center(child: CircularProgressIndicator()));
                              }
                              if(member.isEmpty){
                                return SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.7,
                                    child: Center(child: Text("No data available")));
                              }
                              return MultiSelectDropDown(
                                controller: _controller,
                                onOptionSelected: (List<ValueItem> selectedOptions) {
                                },
                                options: member!.map((e) => ValueItem(label: e['text'], value: e['id'])).toList(),
                                selectionType: SelectionType.multi,
                                chipConfig: const ChipConfig(wrapType: WrapType.scroll),
                                dropdownHeight: 300,
                                optionTextStyle: const TextStyle(fontSize: 16),
                                selectedOptionIcon: const Icon(Icons.check_circle),
                              );
                            },
                    
                          ),
                        ],
                      ),
                          10.height,
                          const Text(
                            "Description:",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                // color: ,
                                fontSize: 16,
                                fontFamily: "Poppins"),
                          ),
                          10.height,
                          Container(
                            height: 200,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                border: Border.all(
                                    width: 1, color: const Color(0xff777777))),
                            child: TextFormField(
                              style: const TextStyle(color: Colors.black),
                              keyboardType: TextInputType.multiline,
                              controller: bloc.description,
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
                                bloc.description.text = value;
                              },
                              validator: (value) {
                                if (value.toString().isEmpty) {
                                  return "Please enter your description.";
                                }
                                return null;
                              },
                            ),
                          ),
                          10.height,
                          const Padding(
                            padding: EdgeInsets.only(left: 1),
                            child: Row(
                              children: [
                                Text("Bill Copy", style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500)),
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
                                padding: EdgeInsets.only(left: 1),
                                child: Row(
                                  children: [
                                    Text("Private", style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500)),
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
