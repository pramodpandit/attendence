// import 'dart:js_interop';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:fast_contacts/fast_contacts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:office/ui/chat/chatScreen.dart';
import 'package:office/ui/widget/app_bar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../bloc/profile_bloc.dart';
import '../../data/model/user.dart';
import '../../data/repository/profile_repo.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  late ProfileBloc profileBloc;

  TextEditingController searchController = TextEditingController();
  String search=" No User Found ";
  List searchedUser=[];

  // List<String> _foundUsers = [];
  // @override
  // void initState(){
  //
  // }

  @override
  void initState() {
    profileBloc=ProfileBloc(context.read<ProfileRepository>());
    super.initState();
    profileBloc.fetchAllUserDetail();
  }

  void sendNotifications(){
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: MyAppBar(title: "Contacts"),
      body: Stack(
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
                  "Contacts",
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
          Column(
            children: [
              const SizedBox(height: 100,),
              ValueListenableBuilder(
                  valueListenable: profileBloc.isAllUserDetailLoad,
                  builder: (context, bool loading, child) {
                    if(loading){
                      return Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.3,
                          ),
                          const Center(child: CircularProgressIndicator()),
                        ],
                      );
                    }
                  return ValueListenableBuilder(
                    valueListenable: profileBloc.allUserDetail,
                    builder: (context, allUserDetail,__){
                     // print('htd$data');
                      if(allUserDetail == null){
                        return Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.3,
                            ),
                            const Center(child: CircularProgressIndicator()),
                          ],
                        );
                      }
                      if(allUserDetail.isEmpty){
                        return Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.3,
                            ),
                            const Center(child: Text("No data found!")),
                          ],
                        );
                      }
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                              children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.grey.withOpacity(0.2),
                                // boxShadow: [
                                //   BoxShadow(
                                //     spreadRadius: 1,
                                //     blurRadius: 3,
                                //     color: Colors.black.withOpacity(0.2),
                                //   )
                                // ]
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.search),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      controller: searchController,
                                      decoration: const InputDecoration(
                                          border: InputBorder.none, hintText: "Search"),
                                      onChanged: (String? value) {
                                        setState(() {
                                          searchedUser =
                                              profileBloc.allUserDetail.value!
                                                  .where((element) =>
                                                  "${element['first_name'] == null ? '':
                                                      element['first_name']
                                                      .toString()
                                                      .toLowerCase()
                                                  } ${element['middle_name'] == null ? '':
                                                      element['middle_name']
                                                      .toString()
                                                      .toLowerCase()
                                                  } ${element['last_name'] == null ? '':
                                                      element['last_name']
                                                      .toString()
                                                      .toLowerCase()}".contains(
                                                      value!.toLowerCase()))
                                                  .toList();
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.only(top: 15,bottom: 10),
                                shrinkWrap: true,
                                physics: const ScrollPhysics(),
                                itemCount: searchController.text.isEmpty
                                    ? allUserDetail.length
                                    : searchedUser.length,
                                itemBuilder: (context, index) {
                                // int i=0;
                                  if(searchController.text.isNotEmpty){
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(builder: (context) => ChatScreen(searchedUser[index])));
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                        ),
                                        child: Column(
                                          children: [
                                            SizedBox(height: 3.h,),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                CircleAvatar(
                                                  radius: 23,
                                                  child: ClipOval(
                                                    child: searchedUser[index]['image'] != null?Image.network(
                                                      "https://freeze.talocare.co.in/public/${searchedUser[index]['image']}",
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
                                                      height: 60,
                                                      width: 60,
                                                      fit: BoxFit.cover,
                                                    ):const Icon(PhosphorIcons.user_bold),
                                                  ),
                                                ),
                                                SizedBox(width: 7.h,),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "${searchedUser[index]['first_name']??""} ${searchedUser[index]['middle_name']??""} ${searchedUser[index]['last_name']??""}",
                                                        style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 15,),
                                                      ),
                                                      // Text(
                                                      //   searchedUser[index].departmentname ?? "",
                                                      //   style: TextStyle(
                                                      //       fontSize: 13,
                                                      //       color: Colors.black.withOpacity(0.8)),
                                                      // ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                            const Divider(),

                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) => ChatScreen(allUserDetail[index])));
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        children: [
                                          SizedBox(height: 3.h,),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              CircleAvatar(
                                                radius: 23,
                                                child: ClipOval(
                                                  child: allUserDetail[index]['image'] != null?Image.network(
                                                    "https://freeze.talocare.co.in/public/${allUserDetail[index]['image']}",
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
                                                    height: 60,
                                                    width: 60,
                                                    fit: BoxFit.cover,
                                                  ):const Icon(PhosphorIcons.user_bold),
                                                ),
                                              ),
                                              SizedBox(width: 7.h,),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "${allUserDetail[index]['first_name']??""} ${allUserDetail[index]['middle_name']??""} ${allUserDetail[index]['last_name']??""}",
                                                      style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 15,),
                                                    ),
                                                    // Text(
                                                    //   allUserDetail[index]['departmentname'] ?? "",
                                                    //   style: TextStyle(
                                                    //       fontSize: 13,
                                                    //       color: Colors.black.withOpacity(0.8)),
                                                    // ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                          const Divider(),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                            ),
                          ]),
                        ),
                      );
                    }
                  );
                }
              ),
            ],
          ),
        ],
      ),
    );
  }
  // Future<List<Contact>> getContact()async {
  //   bool isGranted = await Permission.contacts.status.isGranted;
  //   if(!isGranted){
  //     isGranted = await Permission.contacts.request().isGranted;
  //   }
  //   if(isGranted){
  //     return await FastContacts.getAllContacts();
  //   }
  //   return[];
  // }
}
