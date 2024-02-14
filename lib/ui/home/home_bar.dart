import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:office/ui/attendance/attendance_punching.dart';
import 'package:office/ui/chat/chatListScreen.dart';
import 'package:office/ui/community/communityHomepage.dart';
import 'package:office/ui/profile/profileScreen.dart';
import 'package:office/ui/home/dashboard.dart';

class HomeBar extends StatefulWidget {
  static const route = "/HomeBar";
  const HomeBar({Key? key}) : super(key: key);

  @override
  State<HomeBar> createState() => _HomeBarState();
}

class _HomeBarState extends State<HomeBar> {

  List<Widget> pages = [
    const AttendancePunching(),
    const CommunityHomePage(),
    const DashBoard(),
    const ChatListScreen(),
    const ProfileScreen(),
  ];
  ValueNotifier<int> currentIndex = ValueNotifier(2);

  // late final HomeBloc bloc;

  @override
  void initState() {
    super.initState();
    // bloc.msgController?.stream.listen((event) {
    //   AppMessageHandler().showSnackBar(context, event);
    // });
    // bloc.init();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        showDialog(
            context: context,
            builder: (context){
              return  AlertDialog(
                title: const Text("Exit"),
                content: const Text("Are you sure you want to Exit?"),
                actions: [
                  TextButton(
                    onPressed:() => SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
                    child: const Text("Yes", style: TextStyle(
                      color: Colors.blue,
                    ),),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: const Text("No", style: TextStyle(
                      color: Colors.grey,
                    ),),
                  ),
                ],
              );
            }
        );
        return false;
      },
      child: Scaffold(
        body: ValueListenableBuilder(
          valueListenable: currentIndex,
          builder: (context, int index, _) {
            return pages[index];
            // return Provider.value(
            //   value: bloc,
            //   child: pages[index],
            // );
          }
        ),
        extendBody: true,
        bottomNavigationBar: ValueListenableBuilder(
          valueListenable: currentIndex,
          builder: (context, int index, _) {
            return
              Container(
                height: 78.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 3,
                          spreadRadius: 2
                      ),
                    ]
                ),
                child: Row(
                children: [
                  Expanded(
                    child: BottomBarIcon(
                      icon: Icons.calendar_month,
                      activeColor: Colors.white,
                      isSelected: index==0,
                      onTap: () {
                        currentIndex.value=0;
                      },
                    ),
                  ),
                  Expanded(
                    child: BottomBarIcon(
                      icon: PhosphorIcons.telegram_logo,
                      activeColor: Colors.white,
                      isSelected: index==1,
                      onTap: () {
                        currentIndex.value=1;
                      },
                    ),
                  ),
                  Expanded(
                    child: BottomBarIcon(
                      icon: PhosphorIcons.diamonds_four_fill,
                      activeColor: Colors.white,
                      isSelected: index==2,
                      onTap: () {
                        currentIndex.value=2;
                      },
                    ),
                  ),
                  Expanded(
                    child: BottomBarIcon(
                      icon: PhosphorIcons.list_checks_fill,
                      activeColor: Colors.white,
                      isSelected: index==3,
                      onTap: () {
                        currentIndex.value=3;
                      },
                    ),
                  ),
                  Expanded(
                    child: BottomBarIcon(
                      icon: Icons.person,
                      activeColor: Colors.white,
                      isSelected: index==4,
                      onTap: () {
                        currentIndex.value=4;
                      },
                    ),
                  ),
                ],
            ),
              );
              /*BottomNavigationBar(
              currentIndex: index,
              onTap: (v) {
                setState(() {
                  currentIndex.value = v;
                });
              },
              items:const [
                BottomNavigationBarItem(icon: Icon(PhosphorIcons.house), label: "Home",),
                BottomNavigationBarItem(icon: Icon(PhosphorIcons.house), label: "Home",),
                BottomNavigationBarItem(icon: Icon(PhosphorIcons.user), label: "Profile"),
                BottomNavigationBarItem(icon: Icon(PhosphorIcons.user), label: "Profile"),
                BottomNavigationBarItem(icon: Icon(PhosphorIcons.user), label: "Profile"),
              ],
            );*/
          }
        ),
      ),
    );
  }
}
class BottomBarIcon extends StatelessWidget {
  final Color activeColor;
  final IconData? icon;
  final String? imageIcon;
  final VoidCallback onTap;
  final bool isSelected;
  const BottomBarIcon({Key? key, required this.activeColor, this.icon, required this.onTap, this.imageIcon, required this.isSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(

            decoration: const BoxDecoration(
              color: Colors.white,
            ),
          ),
          const Spacer(),
          SizedBox(
            width: 60.w,
            height: 74.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 45,
                  width: 45,
                  child: Container(
                    decoration: BoxDecoration(
                        color:  isSelected ? Colors.blue : Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 3,
                              spreadRadius: 2
                          ),
                        ]
                    ),
                    child: icon!=null ? Icon(icon, color: isSelected ? activeColor : Colors.grey,size: isSelected?27:20,) : Image.asset(imageIcon!, color: isSelected ? activeColor : Colors.blue),
                ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
