import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../bloc/team_bloc.dart';
import '../../data/repository/team_repo.dart';
import '../../utils/message_handler.dart';
import '../widget/app_dropdown.dart';
import '../widget/custom_button.dart';

class TeamHomePage extends StatefulWidget {
  final int branchid;
  const TeamHomePage({super.key, required this.branchid});

  @override
  State<TeamHomePage> createState() => _TeamHomePageState();
}

class _TeamHomePageState extends State<TeamHomePage> {
  late TeamBloc bloc;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc = TeamBloc(context.read<TeamRepo>());
    bloc.fetchuserMeber(widget.branchid);
    bloc.fetchteamList();
    bloc.Updatemanger.value =null;
    bloc.UpdatereportTeam.value =null;
    bloc.Updatereportto.value =null;
    bloc.msgController?.stream.listen((event) {
      AppMessageHandler().showSnackBar(context, event);
    });
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
                        bottomRight: Radius.circular(20))),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 56,
                    ),
                    Text(
                      "Add Team",
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
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 15,right: 15,top: 15),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 1),
                    child: Row(
                      children: [
                        Text("Report To", style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500)),
                        Text("*", style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),)
                      ],
                    ),
                  ),
                  5.height,
                  ValueListenableBuilder(
                    valueListenable: bloc.reportto,
                    builder: (context, member, child) {
                      if(member ==null){
                        return AppDropdown(
                          items:[],
                          onChanged: (v) {bloc.Updatereportto=v;
                          print(v);
                          },
                          value: null,
                          hintText: "Choose Member",
                        );
                      }
                      if(member.isEmpty){
                        return SizedBox(
                            height: MediaQuery.of(context).size.height * 0.7,
                            child: Center(child: Text("No data available")));
                      }
                      return AppDropdown(
                        items: member!.map((e) => DropdownMenuItem(value: '${e['id']}', child: Text(e['text']??""))
                        ).toList(),
                        onChanged: (v) {bloc.Updatereportto.value = v;
                        print(v);
                        },
                        value: bloc.Updatereportto.value,
                        hintText: "Choose Member",
                      );
                    },

                  ),
                  ValueListenableBuilder(
                    valueListenable: bloc.reportto,
                    builder: (context, member, child) {
                      if(member ==null){
                        return AppDropdown(
                          items:[],
                          onChanged: (v) {bloc.Updatereportto=v;
                          print(v);
                          },
                          value: null,
                          hintText: "Choose Member",
                        );
                      }
                      if(member.isEmpty){
                        return SizedBox(
                            height: MediaQuery.of(context).size.height * 0.7,
                            child: Center(child: Text("No data available")));
                      }
                      return AppDropdown(
                        items: member!.map((e) => DropdownMenuItem(value: '${e['id']}', child: Text(e['text']??""))
                        ).toList(),
                        onChanged: (v) {bloc.Updatereportto.value = v;
                        print(v);
                        },
                        value: bloc.Updatereportto.value,
                        hintText: "Choose Member",
                      );
                    },

                  ),
                  10.height,
                  const Padding(
                    padding: EdgeInsets.only(left: 1),
                    child: Row(
                      children: [
                        Text("Report Team", style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500)),
                        Text("*", style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),)
                      ],
                    ),
                  ),
                  5.height,
                  ValueListenableBuilder(
                    valueListenable: bloc.getTeamList,
                    builder: (context, member, child) {
                      if(member ==null){
                        return AppDropdown(
                          items:[],
                          onChanged: (v) {bloc.UpdatereportTeam=v;
                          print(v);
                          },
                          value: null,
                          hintText: "Choose Team",
                        );
                      }
                      if(member.isEmpty){
                        return SizedBox(
                            height: MediaQuery.of(context).size.height * 0.7,
                            child: Center(child: Text("No data available")));
                      }
                      return AppDropdown(
                        items: member!.map((e) => DropdownMenuItem(value: '${e['id']}', child: Text(e['name']??""))
                        ).toList(),
                        onChanged: (v) {bloc.UpdatereportTeam.value = v;
                        print(v);
                        },
                        value: bloc.UpdatereportTeam.value,
                        hintText: "Choose Team",
                      );
                    },

                  ),
                  10.height,
                  const Padding(
                    padding: EdgeInsets.only(left: 1),
                    child: Row(
                      children: [
                        Text("Manager", style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500)),
                        Text("*", style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),)
                      ],
                    ),
                  ),
                  5.height,
                  ValueListenableBuilder(
                    valueListenable: bloc.reportto,
                    builder: (context, member, child) {
                      if(member ==null){
                        return AppDropdown(
                          items:[],
                          onChanged: (v) {bloc.Updatemanger=v;
                          print(v);
                          },
                          value: null,
                          hintText: "Choose Manager",
                        );
                      }
                      if(member.isEmpty){
                        return SizedBox(
                            height: MediaQuery.of(context).size.height * 0.7,
                            child: Center(child: Text("No data available")));
                      }
                      return AppDropdown(
                        items: member!.map((e) => DropdownMenuItem(value: '${e['id']}', child: Text(e['text']??""))
                        ).toList(),
                        onChanged: (v) {bloc.Updatemanger.value = v;
                        print(v);
                        },
                        value: bloc.Updatemanger.value,
                        hintText: "Choose Manager",
                      );
                    },

                  ),
                  10.height,
                  const SizedBox(
                    height: 20,
                  ),
                  ValueListenableBuilder(
                    valueListenable: bloc.isLoadingupdateTeam,
                    builder: (BuildContext context, bool loading,
                        Widget? child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          loading
                              ? CircularProgressIndicator()
                              : CustomButton2(
                              onPressed: () {
                                bloc.UpdateTeam();
                               },
                              tittle: 'Submit'),
                        ],
                      );
                    },
                  ),

                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
