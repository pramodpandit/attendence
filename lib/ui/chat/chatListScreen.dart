
import 'package:container_tab_indicator/container_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:office/ui/chat/chatScreen.dart';
import 'package:office/ui/chat/contacts.dart';
import 'package:office/ui/widget/app_bar.dart';
import 'package:office/ui/widget/more_sheet.dart';
import 'package:office/utils/constants.dart';

import '../../data/model/user.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  List<String> tabTittle = ["Chats", "Groups"];
  ValueNotifier<int> tabIndex = ValueNotifier(0);
  ValueNotifier<bool> isSearchClicked = ValueNotifier(false);
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
          const SizedBox(
            height: 60,
          ),
          Row(
            children: [
              Text(
                "Chats",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacer(),
              ValueListenableBuilder(
                valueListenable: isSearchClicked,
                builder: (BuildContext context, bool isClick, Widget? child) {
                  if (isClick != true) {
                    return GestureDetector(
                      onTap: () {
                        isSearchClicked.value = !isSearchClicked.value;
                      },
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.grey.withOpacity(0.2),
                        child: Icon(
                          Icons.search,
                          size: 20,
                        ),
                      ),
                    );
                  }
                  return Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 2),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        // boxShadow: K.boxShadow,
                        color: Colors.grey.withOpacity(0.2),
                      ),
                      child: TextField(
                        autofocus: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                        onSubmitted: (value) {
                          isSearchClicked.value = !isSearchClicked.value;
                        },
                      ),
                    ),
                  );
                },
              ),
              SizedBox(
                width: 10,
              ),
              GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: false,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      builder: (BuildContext context) {
                        return MoreSheet(
                            ctx: context,
                            items: ["Report", "Block",],
                            icons: [Icon(Icons.report), Icon(Icons.block)]);
                      },
                    );
                  },
                  child: Icon(Icons.more_vert)),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: DefaultTabController(
              length: 2,
              initialIndex: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10, left: 10),
                    child: Container(
                      color: Colors.white,
                        child: TabBar(
                          onTap: (value) {
                            tabIndex.value = value;
                          },
                          dividerColor: Colors.white,
                          indicatorColor: const Color(0xFF0E83EA),
                          indicator: ContainerTabIndicator(
                            height: 40,
                            width: 90,
                            radius: BorderRadius.circular(100),
                          ),
                          indicatorWeight: 0,
                          indicatorPadding: EdgeInsets.symmetric(horizontal: 20),
                          tabs: [
                            ValueListenableBuilder(
                              valueListenable: tabIndex,
                              builder: (BuildContext context, int value, Widget? child) {
                                return Tab(
                                  child: Text('Chats',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: value == 0
                                              ? Colors.white
                                              : Colors.black,
                                          fontFamily: 'Poppins')),
                                );
                              },
                            ),
                            ValueListenableBuilder(
                              valueListenable: tabIndex,
                              builder: (BuildContext context, int value, Widget? child) {
                                return Tab(
                                  child: Text('Groups',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: value == 1
                                              ? Colors.white
                                              : Colors.black,
                                          fontFamily: 'Poppins')),
                                );
                              },
                            ),
                          ],
                        ),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          Stack(
                            children: [
                              RefreshIndicator(
                                displacement: 100,
                                backgroundColor: Colors.white,
                                color: K.themeColorPrimary,
                                strokeWidth: 3,
                                triggerMode:
                                    RefreshIndicatorTriggerMode.onEdge,
                                onRefresh: () async {
                                  await Future.delayed(
                                      Duration(milliseconds: 1200));
                                },
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        PageRouteBuilder(
                                            pageBuilder: (context, animation, secondaryAnimation) {
                                            return ChatScreen(User(firstName: "Aditya"));
                                  },),);
                                  },
                                  child: ListView.builder(
                                    itemCount: 15,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return const SingleChat();
                                    },
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 110,
                                right: 10,
                                child: FloatingActionButton.extended(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ContactsScreen()));
                                    },
                                    backgroundColor: const Color(0xFF253772),
                                    label: AnimatedSwitcher(
                                      duration: const Duration(seconds: 1),
                                      transitionBuilder: (Widget child,
                                              Animation<double> animation) =>
                                          FadeTransition(
                                            opacity: animation,
                                            child: SizeTransition(
                                            sizeFactor: animation,
                                            axis: Axis.horizontal,
                                            child: child,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                    )),
                              ),
                            ],
                          ),
                          Stack(
                            children: [
                              RefreshIndicator(
                                  displacement: 200,
                                  backgroundColor: Colors.white,
                                  color: K.themeColorPrimary,
                                  strokeWidth: 3,
                                  triggerMode:
                                      RefreshIndicatorTriggerMode.onEdge,
                                  onRefresh: () async {
                                    await Future.delayed(
                                        const Duration(milliseconds: 1500));
                                  },
                                  child: Container()),
                              Positioned(
                                bottom: 110,
                                right: 10,
                                child: FloatingActionButton.extended(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ContactsScreen()));
                                    },
                                    backgroundColor: const Color(0xFF253772),
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
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                    )),
                              ),
                            ],
                          ),
                        ]),
                  ),
                ],
              ),
            ),
          ),

        /*  Container(
            // width: 240,
            width: MediaQuery.of(context).size.width,
            height: 50,
            margin: EdgeInsets.symmetric(horizontal: 50),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40.0),
              color: Color.fromRGBO(255, 255, 255, 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 3,
                  // offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: DefaultTabController(
              length: 2,
              child: TabBar(
                // controller: tabController,
                // physics: const NeverScrollableScrollPhysics(),
                onTap: (index) {},
                padding: const EdgeInsets.all(0.0),
                dividerColor: Colors.transparent,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: const [
                    BoxShadow(color: Color(0xff2F85C6)),
                    BoxShadow(
                      color: Color(0xffF6F6F6),
                      spreadRadius: 0,
                      blurRadius: 15.0,
                      offset: Offset(3, 2),
                    ),
                  ],
                ),
                indicatorColor: Colors.white,
                labelColor: const Color(0xff1F1E1E),
                unselectedLabelColor:
                    const Color.fromRGBO(121, 102, 102, 1),
                labelStyle: const TextStyle(
                    color: Color(0xff1F1E1E),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Poppins"),
                tabs: const [
                  Tab(text: 'Chats'),
                  Tab(text: 'Group'),
                ],
              ),
            ),
          ),*/
        ]),
      ),
    );
  }
}

class SingleChat extends StatefulWidget {
  const SingleChat({super.key});
  @override
  State<SingleChat> createState() => _SingleChatState();
}

class _SingleChatState extends State<SingleChat> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.of(context)
        //     .push(MaterialPageRoute(builder: (context) => const ChatScreen()));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              child: Icon(Icons.person),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        "Jacob",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const Spacer(),
                      Text(
                        "1:32 PM",
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    "Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipi",
                    softWrap: true,
                    maxLines: 2,
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        overflow: TextOverflow.ellipsis,
                        fontSize: 12,
                        color: Colors.grey.shade400),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
