import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:office/bloc/leads_bloc.dart';
import 'package:office/ui/widget/app_dropdown.dart';
import 'package:office/ui/widget/custom_button.dart';
import 'package:provider/provider.dart';
import '../../../../bloc/project_bloc.dart';

class AddLeadLinks extends StatefulWidget {
  final int leadId;
  final LeadsBloc bloc;
  const AddLeadLinks({Key? key, required this.leadId,required this.bloc}) : super(key: key);

  @override
  State<AddLeadLinks> createState() => _AddLeadLinksState();
}

class _AddLeadLinksState extends State<AddLeadLinks> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool light = false;
  final MultiSelectController _controller = MultiSelectController();


  @override
  void initState() {
    super.initState();
    widget.bloc.getAllLinkTypes();
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
                  "Add Link",
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
                            Flexible(
                              child: ValueListenableBuilder(
                                valueListenable: widget.bloc.allLinkTypes,
                                builder: (context, allLinkType, child) {
                                  if(allLinkType == null){
                                    return AppDropdown(
                                      items: [],
                                      onChanged: (value) {

                                      },
                                      value: null,
                                      hintText: "Select",
                                    );
                                  }
                                return AppDropdown(
                                  items: widget.bloc.allLinkTypes.value!.map((e) => DropdownMenuItem<String>(child: Text(e['name']), value: e['id'].toString(),)).toList(),
                                  onChanged: (value) {
                                    widget.bloc.linkType.value = value;
                                  },
                                  value: widget.bloc.linkType.value,
                                  hintText: "Select",
                                );
                              },)
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Links",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            // color: ,
                            fontSize: 13,

                          ),
                        ),
                        10.height,
                        TextFormField(
                          style: const TextStyle(color: Colors.black),
                          controller: widget.bloc.link,
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
                            controller: widget.bloc.other,
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
                              widget.bloc.other.text = value;
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
                          height: 20,
                        ),
                        ValueListenableBuilder(
                          valueListenable: widget.bloc.addLinkLoading,
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
                                        widget.bloc.addLeadLink(widget.leadId.toString());
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
