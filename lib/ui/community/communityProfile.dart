import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:office/data/repository/project_repo.dart';
import 'package:office/ui/community/communityHomepage.dart';
import 'package:provider/provider.dart';

import '../../bloc/project_bloc.dart';
import '../project/menus/User_profile.dart';

class CommunityProfile extends StatefulWidget {
  final int userid;
  const CommunityProfile({Key? key, required this.userid}) : super(key: key);

  @override
  State<CommunityProfile> createState() => _CommunityProfileState();
}

class _CommunityProfileState extends State<CommunityProfile> {
  late ProjectBloc bloc;
  List<Widget> menusWidgets = [
  ];
  List<String> menuItems = [
    "My Timeline",
    "Documents",
    "other",
  ];
  ValueNotifier<int> selectedMenuIndex = ValueNotifier(0);
  selectMenu(int index) {
    selectedMenuIndex.value = index;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    menusWidgets = [
      ListView.builder(
        itemCount: 7,
        physics: ScrollPhysics(),
        // shrinkWrap: true,
        itemBuilder: (context, index) {
          return PostList();
        },
      ),
      ProfileInfo(userid: widget.userid.toString()),
      AboutInfo(userid: widget.userid.toString()),
    ];
    bloc = ProjectBloc(context.read<ProjectRepository>());
    bloc.fetchUserDetail(int.parse(widget.userid.toString()));
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: bloc.userDetail,
        builder: (context, userdata, child) {
          if(userdata ==null){
            return SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: Center(child: CircularProgressIndicator()));
          }
          if(userdata.isEmpty){
            return SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: Center(child: Text("No data available")));
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
                                "${userdata['Name']??''}",
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
                                "${userdata['designationname']??''}",
                                textAlign: TextAlign.center,
                                style:
                                TextStyle(color: Colors.black87, fontSize: 12),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Employee Id: ${userdata['employee_code']}",
                                textAlign: TextAlign.center,
                                style:
                                TextStyle(color: Colors.black54, fontSize: 12),
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
                                                image: NetworkImage(userdata['image']==null? 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_640.png':
                                                "https://freeze.talocare.co.in/public/${userdata['image']}"),
                                                fit: BoxFit.cover)),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: ClipOval(
                                child: Image.network(userdata['image']==null?'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_640.png':
                                "https://freeze.talocare.co.in/public/${userdata['image']}",
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
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 55,
                padding: const EdgeInsets.only(top: 18),
                child: ValueListenableBuilder(
                    valueListenable: selectedMenuIndex,
                    builder: (context, int menuindex, _) {
                      return ListView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          scrollDirection: Axis.horizontal,
                          itemCount: menuItems.length,
                          itemBuilder: (context, index) {
                            return Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    selectMenu(index);
                                    // userDetailsNotifier.selectMenu(index);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10.0),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: selectedMenuIndex.value == index
                                            ? const Color(0xFF009FE3)
                                            : Colors.grey.shade300,
                                        borderRadius: BorderRadius.circular(30.0)),
                                    child: Text(
                                      menuItems[index],
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: "Poppins",
                                          color: selectedMenuIndex.value == index
                                              ? Colors.white
                                              : Colors.black),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                )
                              ],
                            );
                          });
                    }),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: selectedMenuIndex,
                  builder: (BuildContext context, int index, Widget? child) {
                    return menusWidgets[index];
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
