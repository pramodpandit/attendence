import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:office/ui/widget/custom_button.dart';
import 'package:office/utils/message_handler.dart';
import 'package:provider/provider.dart';
import '../../../../bloc/project_bloc.dart';

class Add_Notes extends StatefulWidget {
  final int projectid;
  final String branch_id;
  const Add_Notes({Key? key, required this.projectid, required this.branch_id}) : super(key: key);

  @override
  State<Add_Notes> createState() => _Add_NotesState();
}

class _Add_NotesState extends State<Add_Notes> {
  late ProjectBloc bloc;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool light = false;
  final MultiSelectController _controller = MultiSelectController();


  @override
  void initState() {
    bloc = context.read<ProjectBloc>();
    super.initState();
    bloc.notes.text = '';
    bloc.addSpecificMember.value =null;
    bloc.fetchAddMemberLit(int.parse(widget.branch_id));
    bloc.msgController?.stream.listen((event) {
      AppMessageHandler().showSnackBar(context, event);
    });
    bloc.notesStream.stream.listen((event) {
      if (event == 'notes') {
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
                  "Give Notes",
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          Flexible(child: Text('Specific Member',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),)),
                            Flexible(
                              child: DropdownButtonFormField<String>(
                                icon: const Icon(
                                  Icons.keyboard_arrow_down_sharp,
                                  color: Colors.grey,
                                ),
                                iconSize: 24,
                                elevation: 16,
                                style: const TextStyle(color: Colors.black, fontSize: 15),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0xffF4F5F7)),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0xffF2F2F2)),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 10),
                                  hintText: "Select",
                                  hintStyle:
                                  TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 15,fontWeight: FontWeight.w500),
                                ),
                                onChanged: (String? data) {
                                  bloc.addSpecificMember.value  = data;

                                },
                                items: bloc.SpecificMemer.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value,style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w700),),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),

                        10.height,
                        ValueListenableBuilder(
                          valueListenable: bloc.addSpecificMember, builder: (context, validation, child) {

                          if(validation.toString() == 'Yes'){
                            return     ValueListenableBuilder(
                              valueListenable: bloc.allProjectsMemberList,
                              builder: (context, member, child) {
                                return Column(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(left: 1),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text("Members",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
                                          Text("*", style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),)
                                        ],
                                      ),
                                    ),
                                    10.height,
                                    MultiSelectDropDown(
                                      controller: _controller,
                                      onOptionSelected: (List<ValueItem> selectedOptions) {
                                        var data  = selectedOptions.map((e) => e.value).toList().join(',');
                                        print(data);
                                        },
                                      options: member!.map((e) => ValueItem(label: e['text'], value: e['id'])).toList(),
                                      selectionType: SelectionType.multi,
                                      chipConfig: const ChipConfig(wrapType: WrapType.scroll),
                                      dropdownHeight: 300,
                                      hint: 'Select Member',
                                      optionTextStyle: const TextStyle(fontSize: 16),
                                      selectedOptionIcon: const Icon(Icons.check_circle),
                                    ),
                                  ],
                                );
                              },

                            );
                          }
                          return Offstage();
                        },),
                        const SizedBox(
                          height: 10,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 1),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("Notes",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
                              Text("*", style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),)
                            ],
                          ),
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
                            controller: bloc.notes,
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
                              bloc.notes.text = value;
                            },
                            validator: (value) {
                              if (value.toString().isEmpty) {
                                return "Please enter your notes.";
                              }
                              return null;
                            },
                          ),
                        ),
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
                          valueListenable: bloc.addnotesLoading,
                          builder: (BuildContext context, bool loading,
                              Widget? child) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                loading
                                    ? CircularProgressIndicator()
                                    : CustomButton2(
                                    onPressed: () {
                                      var data  = _controller.selectedOptions.map((e) => e.value).toList().join(',');
                                      if (formKey.currentState!.validate()  ) {
                                        if(bloc.addSpecificMember.value =='No'){
                                          bloc.addNotes(widget.projectid,light==true?'yes':'no',data);
                                        }else{
                                          if(data.isEmpty || data ==null){
                                            bloc.showMessage(MessageType.error('Please select member'));

                                          }else{
                                            bloc.addNotes(widget.projectid,light==true?'yes':'no',data);
                                          }
                                        }

                                      }
                                    },
                                    tittle: 'Add Notes'),
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
}
