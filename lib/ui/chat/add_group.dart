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

class AddGroup extends StatefulWidget {
  const AddGroup({super.key});

  @override
  State<AddGroup> createState() => _AddGroupState();
}

class _AddGroupState extends State<AddGroup> {
  late ProfileBloc bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc = ProfileBloc(context.read<ProfileRepository>());
    bloc.msgController?.stream.listen((event) {
      AppMessageHandler().showSnackBar(context, event);
    });
    // bloc.fetchAllUserDetail();
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
                      "Create Group",
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
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Stack(
                            children: [
                              ValueListenableBuilder(
                                valueListenable: bloc.groupLogo,
                                builder: (context, groupLogo, child) {
                                  if(groupLogo == null){
                                    return Container(
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(PhosphorIcons.user),
                                    );
                                  }
                                  return Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: FileImage(groupLogo),
                                            fit: BoxFit.cover
                                        )
                                    ),
                                  );
                                },),
                              Positioned(
                                right: 2,
                                bottom: 2,
                                child: InkWell(
                                  onTap: () {
                                    pickImage();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(7),
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.edit,color: Colors.white,size: 15,),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        const Row(
                          children: [
                            SizedBox(width: 10),
                            Text("Group Name"),
                            Text("*",style: TextStyle(color: Colors.red),)
                          ],
                        ),
                        const SizedBox(height: 10),
                        AppTextField(
                          controller: bloc.groupName,
                          title: "Name",
                          showTitle: false,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        AppTextField(
                          controller: bloc.groupDesc,
                          title: "Description",
                          inputAction: TextInputAction.done,
                          validate: true,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ValueListenableBuilder(
                          valueListenable: bloc.createGroupLoading,
                          builder: (context, createGroupLoading, child) {
                            return AppButton(
                              title: "Create",
                              loading: createGroupLoading,
                              onTap: () {
                                bloc.createNewGroup(context);
                              },
                              margin: EdgeInsets.zero,
                              // loading: loading,
                            );
                          },)
                      ],
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
