import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:office/bloc/profile_bloc.dart';
import 'package:office/data/repository/profile_repo.dart';
import 'package:office/ui/widget/app_button.dart';
import 'package:office/ui/widget/app_dropdown.dart';
import 'package:office/ui/widget/app_text_field.dart';
import 'package:office/utils/message_handler.dart';
import 'package:provider/provider.dart';

class AddGroupMember extends StatefulWidget {
  const AddGroupMember({super.key});

  @override
  State<AddGroupMember> createState() => _AddGroupMemberState();
}

class _AddGroupMemberState extends State<AddGroupMember> {
  late ProfileBloc bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc = ProfileBloc(context.read<ProfileRepository>());
    bloc.msgController?.stream.listen((event) {
      AppMessageHandler().showSnackBar(context, event);
    });
    bloc.fetchAllUserDetail();
  }

  void pickImage()async{
    ImagePicker picker = ImagePicker();
    XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    bloc.groupLogo.value = File(pickedFile!.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
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
                      "Add Member",
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

            ],
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: bloc.allUserDetail,
              builder: (context, allUserDetail, child) {
                if(allUserDetail == null){
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15, vertical: 30),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        child: MultiSelectDropDown(
                          onOptionSelected: (selectedOptions) {
                            bloc.addingUsers.value = selectedOptions.map((e) => e.value.toString()).toList().join(",");
                          },
                          options: allUserDetail.map((e) =>
                              ValueItem(label: "${e['first_name'] ??
                                  ''} ${e['middle_name'] ??
                                  ''} ${e['last_name'] ?? ''}",
                                  value: e['user_id'].toString())).toList(),
                          fieldBackgroundColor: Colors.grey.shade200,
                          hintColor: Colors.black,
                          searchEnabled: true,
                        ),
                      ),
                      const SizedBox(height: 20),
                      AppButton(
                        title: "Add",
                        loading : true,
                        onTap: () {

                        },
                      ),
                    ],
                  ),
                ),
              );
            },),
          ),
        ],
      ),
    );
  }
}
