import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:office/ui/widget/custom_button.dart';
import 'package:provider/provider.dart';
import '../../../../bloc/project_bloc.dart';
import '../../../widget/app_dropdown.dart';

class Add_Links extends StatefulWidget {
  final int projectid;
  final String branch_id;
  const Add_Links({Key? key, required this.projectid, required this.branch_id}) : super(key: key);

  @override
  State<Add_Links> createState() => _Add_LinksState();
}

class _Add_LinksState extends State<Add_Links> {
  late ProjectBloc bloc;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool light = false;
  final MultiSelectController _controller = MultiSelectController();


  @override
  void initState() {
    bloc = context.read<ProjectBloc>();
    super.initState();
    bloc.Comment.text = '';
    bloc.selectedLinktype = null;
    bloc.fetchLinktype();
    bloc.fetchAddMemberLit(int.parse(widget.branch_id));
    bloc.linkSteam.stream.listen((event) {
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
                  "Give Link",
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
                            Flexible(child: Text('Link Type',style: TextStyle(fontSize: 13,fontWeight: FontWeight.w700),)),
                            ValueListenableBuilder(
                              valueListenable: bloc.linketype,
                              builder: (context, linktype, child) {

                                return  Flexible(
                                  child:  AppDropdown(
                                    items: linktype!.map((e) => DropdownMenuItem(value: '${e['id']}', child: Text(e['name']??""))
                                    ).toList(),
                                    onChanged: (v) {bloc.updatelink(v);},
                                    value: bloc.selectedLinktype,
                                    hintText: "Select",
                                  ),
                                );
                              },

                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 10,
                        ),
                        const Text("Links", style: TextStyle(fontWeight: FontWeight.w700,
                              // color: ,
                              fontSize: 13,
                        ),
                        ),
                        10.height,
                        TextFormField(
                          style: const TextStyle(color: Colors.black),
                          controller: bloc.links,
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
                              return "links is required";
                            }
                            return null;
                          },
                          onTap: () {},
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Other",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              // color: ,
                              fontSize: 13,
                              ),
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
                            controller: bloc.other,
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
                              bloc.other.text = value;
                            },
                            validator: (value) {
                              if (value.toString().isEmpty) {
                                return "Please enter your other information.";
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
                                  Text("Private", style: TextStyle(fontSize: 13,fontWeight: FontWeight.w700)),
                                  Text("*", style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),)
                                ],
                              ),
                            ),
                            Switch(
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
                          valueListenable: bloc.addLinLoading,
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
                                        bloc.addlink(widget.projectid,light==true?'yes':'no',);
                                      }
                                    },
                                    tittle: 'Add Links'),
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
