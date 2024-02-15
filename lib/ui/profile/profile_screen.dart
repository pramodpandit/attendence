import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:office/data/model/user.dart';
import 'package:office/utils/message_handler.dart';
import 'package:provider/provider.dart';
import '../../bloc/profile_bloc.dart';
import '../../data/repository/profile_repo.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late ProfileBloc bloc;

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    bloc = ProfileBloc(context.read<ProfileRepository>());
    super.initState();
    bloc.fetchUserDetail();
    bloc.msgController?.stream.listen((event) {
      AppMessageHandler().showSnackBar(context, event);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(valueListenable: bloc.isUserDetailLoad, builder: (context,bool loading,_) {
        if(loading){
          return Center(child: CircularProgressIndicator());
        }
        return
          Column(
            children: [
              Stack(
                children: [
                  const SizedBox(height: 50,),
                  Container(
                      height: 190,
                    width: 1.sw,
                    decoration: const BoxDecoration(
                        color: Color(0xFF009FE3),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30))
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 56,),
                        Text(
                          "Profile",
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
                  Center(
                    child: Column(
                      children: [
                          SizedBox(
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
                                  spreadRadius: 2
                              )
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: 40.h,),
                              Text(
                                  bloc.userDetail.value?.name ?? "",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                ),
                              ),
                              SizedBox(height: 3,),
                              Text(
                                  "${bloc.userDetail.value?.designationname ?? ""}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 12
                                ),
                              ),
                              SizedBox(height: 5,),
                              Text(
                                "Employee Id: ${bloc.userDetail.value?.employeeCode ?? ""}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 12
                                ),
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
                          SizedBox(
                            height: 100,
                          ),
                        CircleAvatar(
                          radius: 33,
                          backgroundColor: Colors.white,
                          child: SizedBox(
                            height: 60,
                            width: 60,
                            child: ClipOval(
                              child: Image.network(
                                "https://freeze.talocare.co.in/public/${bloc.userDetail.value
                                    ?.image}",
                                fit: BoxFit.cover,),
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
                        radius: 15,
                        child: Icon(Icons.arrow_back, size: 18,),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                height: 55,
                padding: const EdgeInsets.only(top: 18),
                child: ValueListenableBuilder(
                    valueListenable: bloc.selectedMenuIndex,
                    builder: (context, snapshot, __) {
                      return ListView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          scrollDirection: Axis.horizontal,
                          itemCount: bloc.profileMenus.length,
                          itemBuilder: (context, index) {
                            return Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    bloc.selectMenu(index);
                                    // userDetailsNotifier.selectMenu(index);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: bloc.selectedMenuIndex.value ==
                                            index
                                            ? const Color(0xFF009FE3)
                                            : Colors.grey.shade300,
                                        borderRadius: BorderRadius.circular(
                                            10.0)),
                                    child: Text(
                                      bloc.profileMenus[index],
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: "Poppins",
                                          color: bloc.selectedMenuIndex.value ==
                                              index
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
                          });}
                ),
              ),
              Expanded(
                child: Container(
                  width: 1.sw,
                  height: 0.8.sh,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ValueListenableBuilder(
                    valueListenable: bloc.selectedMenuIndex,
                    builder: (BuildContext context, int index, Widget? child) {
                      // print(index);
                      return Provider.value(
                          value: bloc, child: bloc.profileMenusWidgets[index]);
                    },
                  ),
                ),
              )
            ],
          );
      }),
  );
  }
}
