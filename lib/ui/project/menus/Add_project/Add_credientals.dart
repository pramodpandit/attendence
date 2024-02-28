import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:office/ui/widget/custom_button.dart';
import 'package:provider/provider.dart';
import '../../../../bloc/project_bloc.dart';
import '../../../../utils/message_handler.dart';

class Add_Credientals extends StatefulWidget {
  final int projectid;
  final String branch_id;
  const Add_Credientals({Key? key, required this.projectid, required this.branch_id}) : super(key: key);

  @override
  State<Add_Credientals> createState() => _Add_CredientalsState();
}

class _Add_CredientalsState extends State<Add_Credientals> {
  late ProjectBloc bloc;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool light = false;
  final MultiSelectController _controller = MultiSelectController();


  @override
  void initState() {
    bloc = context.read<ProjectBloc>();
    super.initState();
    bloc.title.text = '';
    bloc.description.text = '';
    bloc.fetchAddMemberLit(int.parse(widget.branch_id));
    bloc.addCredialSpecificMember.value =null;
    bloc.msgController?.stream.listen((event) {
      AppMessageHandler().showSnackBar(context, event);
    });
    bloc.credientalSteam.stream.listen((event) {
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
                  "Add Crediental",
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
                                  bloc.addCredialSpecificMember.value  = data;

                                },
                                items: bloc.SpecificMemer.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value,style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w500),),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                        10.height,
                        ValueListenableBuilder(
                          valueListenable: bloc.addCredialSpecificMember, builder: (context, validation, child) {
                            if(validation.toString() == 'Yes'){
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
                                ValueListenableBuilder(
                                  valueListenable: bloc.allProjectsMemberList,
                                  builder: (context, member, child) {
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
                            );
                          }
                          return Offstage();
                        },),
                        10.height,
                        const Text(
                          "Tittle:",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              // color: ,
                              fontSize: 16,
                              fontFamily: "Poppins"),
                        ),
                        TextFormField(
                          style: const TextStyle(color: Colors.black),
                          controller: bloc.title,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xffffffff),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.red.withOpacity(1)),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.red.withOpacity(1)),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding: const EdgeInsets.all(17.0),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: const Color(0xff777777)
                                      .withOpacity(0.8)),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                  const Color(0xff777777).withOpacity(1)),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            hintText: "Title",
                            focusColor: Colors.white,
                            counterStyle:
                            const TextStyle(color: Colors.white),
                            hintStyle: const TextStyle(
                                color: Color(0xff777777),
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                fontFamily: "Poppins"),
                          ),
                          validator: (value) {
                            if (value.toString().isEmpty) {
                              return "Title is required";
                            }
                            return null;
                          },
                          onTap: () {},
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Description:",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              // color: ,
                              fontSize: 16,
                              fontFamily: "Poppins"),
                        ),
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
                          valueListenable: bloc.addCredientalLoading,
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
                                        if(bloc.addCredialSpecificMember.value =='No'){
                                          bloc.addCrediental(widget.projectid,light==true?'yes':'no',data);
                                        }else{
                                          if(data.isEmpty || data ==null){
                                            bloc.showMessage(MessageType.error('Please select member'));

                                          }else{
                                            bloc.addCrediental(widget.projectid,light==true?'yes':'no',data);
                                          }
                                        }
                                      }
                                      },
                                    tittle: 'Add Crediental'),
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
