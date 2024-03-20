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
  final String groupId;
  const GroupDetail({Key? key, required this.groupId}) : super(key: key);

  @override
  State<GroupDetail> createState() => _CommunityProfileState();
}

class _CommunityProfileState extends State<GroupDetail> {
  late ProfileBloc bloc;
  late SharedPreferences prefs;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc = ProfileBloc(context.read<ProfileRepository>());
    sharedPrefs();
    bloc.getSpecificGroupDetails(widget.groupId);
  }

  void sharedPrefs()async{
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: bloc.groupDetailLoading,
        builder: (context, groupDetailLoading, child) {
          if(groupDetailLoading){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        return ValueListenableBuilder(
          valueListenable: bloc.groupDetails,
          builder: (context, groupDetails, child) {
            if(groupDetails!.isEmpty){
              return Text("Something went wrong");
            }
          return Column(
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
                                "${groupDetails['group']['group_name']??''}",
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
                                "${groupDetails['group']['description']??''}",
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
                                                image: NetworkImage(groupDetails['group']['logo']==null? 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_640.png':
                                                "https://freeze.talocare.co.in/public/${groupDetails['group']['logo']}"),
                                                fit: BoxFit.cover)),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: ClipOval(
                                child: Image.network(groupDetails['group']['logo']==null?'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_640.png':
                                "https://freeze.talocare.co.in/public/${groupDetails['group']['logo']}",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
                          "Group Detail",
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
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AddGroupMember(groupId: widget.groupId,groupMembers: groupDetails['data'],)));
                          },
                          title: Text("Add Member"),
                          leading: Icon(Icons.add),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: (groupDetails['data'] as List).length,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          itemBuilder: (context, index) {
                            return ListTile(
                              contentPadding: EdgeInsets.symmetric(vertical: 0),
                              title: Text(groupDetails['data'][index]['user_name']),
                              leading: SizedBox(
                                height: 50,
                                width: 50,
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
                                                    image: NetworkImage(groupDetails['data'][index]['image']==null? 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_640.png':
                                                    "https://freeze.talocare.co.in/public/${groupDetails['data'][index]['image']}"),
                                                    fit: BoxFit.cover)),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: CircleAvatar(
                                    child: ClipOval(
                                        child: groupDetails['data'][index]['image'] == null?Icon(Icons.person):
                                        Image.network(
                                          "https://freeze.talocare.co.in/public/${groupDetails['data'][index]['image']}",
                                          loadingBuilder: (context, child, loadingProgress) {
                                            if(loadingProgress == null){
                                              return child;
                                            }
                                            return SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                value: loadingProgress.expectedTotalBytes!=null?
                                                loadingProgress.cumulativeBytesLoaded/
                                                    loadingProgress.expectedTotalBytes!
                                                    : null,
                                                strokeWidth: 2,
                                              ),
                                            );
                                          },
                                          errorBuilder: (context, error, stackTrace) {
                                            return Icon(Icons.person);
                                          },
                                          width: double.infinity,
                                          height: double.infinity,
                                          fit: BoxFit.cover,
                                        )),
                                  ),
                                ),
                              ),
                              subtitle: Text(groupDetails['data'][index]['role'].toString() == "1" ? "Admin" : "",style: TextStyle(color: Colors.blue),),
                              trailing: PopupMenuButton(
                                position: PopupMenuPosition.under,
                                enabled: groupDetails['data'][index]['user1'].toString() != prefs.getString("uid"),
                                itemBuilder: (context) {
                                  return [
                                    PopupMenuItem(
                                      child: Text(groupDetails['data'][index]['role'].toString() == "1"?"Remove From Admin" : "Make admin"),
                                      onTap: () {
                                        bloc.makeRemoveAdminInGroup(widget.groupId.toString(), groupDetails['data'][index]['user1'].toString(), groupDetails['data'][index]['role'].toString() == "1" ? "0" : "1");
                                      },
                                    ),
                                    PopupMenuItem(
                                      child: Text("Remove"),
                                      onTap: () {
                                        bloc.addRemoveMemberInGroup(context, widget.groupId.toString(), "remove",removeUser: groupDetails['data'][index]['user1'].toString());
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
          );
        },);
      },),
    );
  }
}
