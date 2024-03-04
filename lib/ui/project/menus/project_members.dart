import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:office/ui/community/communityProfile.dart';
import 'package:provider/provider.dart';

import '../../../bloc/project_bloc.dart';
import '../../../data/repository/project_repo.dart';
import '../../widget/app_dropdown.dart';
import 'User_profile.dart';

class ProjectMembers extends StatefulWidget {
  final  data ;
  const ProjectMembers({Key? key, this.data}) : super(key: key);

  @override
  State<ProjectMembers> createState() => _ProjectMembersState();
}

class _ProjectMembersState extends State<ProjectMembers> {
  late ProjectBloc bloc;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc = ProjectBloc(context.read<ProjectRepository>());
    bloc.fetchProjectsDetails(widget.data['id']);
    bloc.fetchAddMemberLit(int.parse(widget.data['business_address']));
    bloc.AddMemberStream.stream.listen((event) {
      if (event == 'successfully') {
        bloc.fetchProjectsDetails(widget.data['id']);
        bloc.fetchAddMemberLit(int.parse(widget.data['business_address']));
        setState(() {
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            ValueListenableBuilder(
              valueListenable: bloc.projectmember,
              builder: (context, projectMember, child) {
                if(projectMember ==null){
                  return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: Center(child: CircularProgressIndicator()));
                }
                if(projectMember.isEmpty){
                  return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: Center(child: Text("No data available")));
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15,vertical:0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RefreshIndicator(
                        displacement: 250,
                        backgroundColor: Colors.yellow,
                        color: Colors.red,
                        strokeWidth: 3,
                        triggerMode: RefreshIndicatorTriggerMode.onEdge,
                        onRefresh: ()async {
                          await Future.delayed(Duration(seconds: 5));
                          },
                        child: ListView.builder(
                          itemCount: projectMember.length,
                          padding: const EdgeInsets.only(top: 10),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            var data  = projectMember[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => UserProfile(userid: data['user_id'],)));
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 20),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage:data['employee_img']==null?null:NetworkImage('https://freeze.talocare.co.in/public/${data['employee_img']}'),
                                      child: data['employee_img']==null?Icon(Icons.person):Offstage(),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${data['first_name']??''} ${data['l_name']==null?data['m_name']??'':data['l_name']??''}",
                                            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: 40,
            width: 90,
            child: ValueListenableBuilder(
              valueListenable: bloc.allProjectsMemberList,
              builder: (context, member, child) {
                if(member ==null){
                  return AppDropdown(
                    items:[],
                    onChanged: (v) {bloc.updateEmployee(v);
                    print(v);
                    },
                    value: null,
                    hintText: "Choose Designation",
                  );
                }
                if(member.isEmpty){
                  return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: Center(child: Text("No data available")));
                }
                return FloatingActionButton.extended(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0))
                    ),
                    onPressed: () async{
                      showDialog(context: context, builder: (context){
                        return AlertDialog(
                          title: Text('Add Members'),
                          content:  AppDropdown(
                            items: member!.map((e) => DropdownMenuItem(value: '${e['id']}', child: Text(e['text']??""))
                            ).toList(),
                            onChanged: (v) {bloc.updateEmployee(v);
                              print(v);
                              },
                            value: bloc.selectedEmpId,
                            hintText: "Choose Designation",
                          ),
                          actions: [
                            ValueListenableBuilder(
                              valueListenable: bloc.isAddmemberLoading,
                              builder: (context, bool isLoading, child) {
                                return ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                        shape: BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)))),
                                    onPressed: (){
                                      bloc.addMember(widget.data['id']);
                                      bloc.selectedEmpId = null;
                                      bloc.fetchProjectsDetails(widget.data['id']);
                                      Navigator.pop(context);
                                      }, child: isLoading?CircularProgressIndicator():Text('Add',style: TextStyle(color: Colors.white),));
                              },
                            ),
                          ],
                        );
                      });
                      // var result =await Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (_) => Provider.value(
                      //       value: bloc,
                      //       child: Add_Member(branch_id: widget.data['business_address'],id:widget.data['id']),
                      //     ),
                      //   ),
                      // );
                    },
                    backgroundColor: const  Color(0xFF009FE3),
                    label: AnimatedSwitcher(
                      duration: const Duration(seconds: 1),
                      transitionBuilder: (Widget child, Animation<double> animation) =>
                          FadeTransition(
                            opacity: animation,
                            child: SizeTransition(
                              sizeFactor: animation,
                              axis: Axis.horizontal,
                              child: child,
                            ),
                          ),
                      child: const Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 5.0),
                            child: Icon(
                              PhosphorIcons.plus_circle_fill,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "Members",
                            style: TextStyle(color: Colors.white,fontSize: 12),
                          )
                        ],
                      ),
                    ));
              },

            ),
          ),
          SizedBox(height: 30,)
        ],
      ),
    );
  }
}
