
import 'package:container_tab_indicator/container_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:office/bloc/profile_bloc.dart';
import 'package:office/data/repository/profile_repo.dart';
import 'package:office/ui/chat/chatScreen.dart';
import 'package:office/ui/chat/contacts.dart';
import 'package:office/ui/widget/app_bar.dart';
import 'package:office/ui/widget/more_sheet.dart';
import 'package:office/utils/constants.dart';
import 'package:provider/provider.dart';

import '../../data/model/user.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  late ProfileBloc bloc;
  // List<String> tabTittle = ["Chats", "Groups"];
  ValueNotifier<int> tabIndex = ValueNotifier(0);
  ValueNotifier<bool> isSearchClicked = ValueNotifier(false);
  late Stream<List> chatStream;

  @override
  void initState() {
    super.initState();
    sharedPref();
    bloc = ProfileBloc(context.read<ProfileRepository>());
    bloc.fetchUserDetail();
    // bloc.getRecentChats();
    chatStream = bloc.getRecentChats().asBroadcastStream();
    bloc.fetchAllUserDetail();
  }

  late SharedPreferences prefs;
  void sharedPref()async{
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
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
                            icons: [Icon(Icons.report), Icon(Icons.block)],
                            deleteOnTap: () {

                            },
                        );
                      },
                    );
                  },
                  child: Icon(Icons.more_vert)),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          ValueListenableBuilder(
            valueListenable: bloc.userDetail,
            builder: (context, value, child) {
              if(value == null){
                return Expanded(
                    child: Center(child: CircularProgressIndicator()));
              }
            return Expanded(
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
                            if(value.allowChats == "yes" )
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
                            if(value.allowChats == "yes")
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
                                    // child: ValueListenableBuilder(
                                    //   valueListenable: bloc.allLastChats,
                                    //   builder: (context, allLastChats, child) {
                                    //     if(allLastChats == null){
                                    //       return Center(
                                    //         child: CircularProgressIndicator(),
                                    //       );
                                    //     }
                                    //   return ListView.builder(
                                    //     itemCount: allLastChats.length,
                                    //     shrinkWrap: true,
                                    //     itemBuilder: (context, index) {
                                    //       return SingleChat(userData: allLastChats[index],bloc: bloc,prefs: prefs,);
                                    //     },
                                    //   );
                                    // },),
                                    child: StreamBuilder(
                                      stream: chatStream,
                                      builder: (context, snapshot) {
                                        if(snapshot.data == null){
                                          return Center(child: CircularProgressIndicator());
                                        }
                                        return ListView.builder(
                                          itemCount: snapshot.data!.length,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return SingleChat(userData: snapshot.data![index],bloc: bloc,prefs: prefs,);
                                          },
                                        );
                                    },),
                                  ),
                                  Positioned(
                                    bottom: 110,
                                    right: 10,
                                    child: FloatingActionButton.extended(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => ContactsScreen()));
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
                                    child: ListView.builder(
                                      itemCount: 15,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return GroupChat(bloc: bloc,prefs: prefs,);
                                      },
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
            );
          },)

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
  final Map<String,dynamic> userData;
  final ProfileBloc bloc;
  final SharedPreferences prefs;
  const SingleChat({super.key,required this.userData, required this.bloc, required this.prefs});
  @override
  State<SingleChat> createState() => _SingleChatState();
}

class _SingleChatState extends State<SingleChat> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => ChatScreen(user: widget.userData,bloc: widget.bloc,prefs: widget.prefs,)));
      },
      contentPadding: EdgeInsets.symmetric(horizontal: 5),
      title: Text(
            "${widget.userData['first_name'] ?? ''} ${widget.userData['middle_name'] ?? ''} ${widget.userData['last_name'] ?? ''}",
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
      subtitle: Text(
        widget.userData['last_chat'].isEmpty ? '':widget.userData['last_chat'][widget.userData['last_chat'].length-1]['message'] ?? '',
          softWrap: true,
          style: TextStyle(
              fontWeight: FontWeight.w400,
              overflow: TextOverflow.ellipsis,
              fontSize: 12,
              color: Colors.grey.shade400),
        ),
      leading: CircleAvatar(
            child: ClipOval(
                child: widget.userData['image'] == null?Icon(Icons.person):
                Image.network(
                  "https://freeze.talocare.co.in/public/${widget.userData['image']}",
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
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.fill,
                )),
          ),
    );
  }
}

class GroupChat extends StatefulWidget {
  final ProfileBloc bloc;
  final SharedPreferences prefs;
  const GroupChat({super.key, required this.bloc, required this.prefs});
  @override
  State<GroupChat> createState() => _GroupChatState();
}

class _GroupChatState extends State<GroupChat> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => ChatScreen(user: {"first_name" : "pramod"},bloc: widget.bloc,prefs: widget.prefs)));
      },
      contentPadding: EdgeInsets.symmetric(horizontal: 5),
      title: const Text(
        "Flutter Developer Group",
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        "Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipi",
        softWrap: true,
        style: TextStyle(
            fontWeight: FontWeight.w400,
            overflow: TextOverflow.ellipsis,
            fontSize: 12,
            color: Colors.grey.shade400),
      ),
      leading: CircleAvatar(
        child: Icon(Icons.person),
      ),
    );
  }
}
