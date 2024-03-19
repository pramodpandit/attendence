import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:office/data/repository/project_repo.dart';
import 'package:office/ui/chat/add_group_member.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../bloc/profile_bloc.dart';
import '../../bloc/project_bloc.dart';
import '../../data/repository/profile_repo.dart';
import '../chat/chatScreen.dart';
import '../project/menus/User_profile.dart';

class GroupDetail extends StatefulWidget {
  final Map<String,dynamic> group;
  const GroupDetail({Key? key, required this.group}) : super(key: key);

  @override
  State<GroupDetail> createState() => _CommunityProfileState();
}

class _CommunityProfileState extends State<GroupDetail> {
  late ProfileBloc bloc;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc = ProfileBloc(context.read<ProfileRepository>());
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              const SizedBox(
                height: 50,
              ),
              Container(
                height: 190,
                width: 1.sw,
                decoration: const BoxDecoration(
                    color: Color(0xFF009FE3),
                    borderRadius:
                    BorderRadius.only(bottomLeft: Radius.circular(30))),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 56,
                    ),
                  ],
                ),
              ),
              Center(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 130,
                    ),
                    Container(
                      height: 130,
                      width: 0.9.sw,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 3,
                              spreadRadius: 2)
                        ],
                        color: Colors.white,
                        borderRadius:
                        const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 40.h,
                          ),
                          Text(
                            "${widget.group['group_name']??''}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          Text(
                            "${widget.group['description']??''}",
                            textAlign: TextAlign.center,
                            style:
                            TextStyle(color: Colors.black87, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 100,
                    ),
                    CircleAvatar(
                      radius: 33,
                      backgroundColor: Colors.white,
                      child: SizedBox(
                        height: 60,
                        width: 60,
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  child: Container(
                                    height: height / 2.5,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        image: DecorationImage(
                                            image: NetworkImage(widget.group['logo']==null? 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_640.png':
                                            "https://freeze.talocare.co.in/public/${widget.group['logo']}"),
                                            fit: BoxFit.cover)),
                                  ),
                                );
                              },
                            );
                          },
                          child: ClipOval(
                            child: Image.network(widget.group['logo']==null?'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_640.png':
                            "https://freeze.talocare.co.in/public/${widget.group['logo']}",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
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
                    radius: 18,
                    child: Icon(
                      Icons.arrow_back,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
              child : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AddGroupMember(groupId: widget.group['id'].toString())));
                      },
                      title: Text("Add Member"),
                      leading: Icon(Icons.add),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 10,
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text("Pramod"),
                          leading: CircleAvatar(),
                          trailing: PopupMenuButton(
                            position: PopupMenuPosition.under,
                            itemBuilder: (context) {
                              return [
                                PopupMenuItem(
                                  child: Text("Make admin"),
                                  onTap: () {
                                    // make admin
                                    // bloc.makeRemoveAdminInGroup(widget.group['id'].toString(), "67687", "1");
                                    // remove from admin
                                    // bloc.makeRemoveAdminInGroup(widget.group['id'].toString(), "67687", "0");
                                  },
                                ),
                                PopupMenuItem(
                                  child: Text("Remove"),
                                  onTap: () {
                                    // bloc.addRemoveMemberInGroup(context, widget.group['id'].toString(), "remove",removeUser: "76457687");
                                  },
                                ),
                              ];
                            },
                          ),
                        );
                      },),
                  ),
                ],
              )
          )
        ],
      ),
    );
  }
}
