// import 'dart:js_interop';

import 'package:fast_contacts/fast_contacts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
                            height: MediaQuery.of(context).size.width * 1,
                          ),
                          const Center(child: CircularProgressIndicator()),
                        ],
                      );
                    }
                  return ValueListenableBuilder(
                    valueListenable: profileBloc.allUserDetail,
                    builder: (context,List<User>?data,__){
                      if(data==null){
                        return Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.width * 1,
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
                                      onChanged: (String? value){
                                        setState(() {
                                          search= value.toString();
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                                // Expanded(
                                //   child: FutureBuilder(
                                //     future: profileBloc.allUserDetail,
                                //     builder: (context, snapshot){
                                //       if(snapshot.data ==  null){
                                //         return Center(child: CircularProgressIndicator());
                                //       }else if(snapshot.data!= null){
                                //         return ListView.builder(
                                //             itemCount: snapshot.data!.length,
                                //             itemBuilder: (context, index){
                                //               Contact contact = snapshot.data![index];
                                //               final phones = contact.phones.map((e) => e.number).join(', ');
                                //               return ListTile(
                                //                 onTap: (){
                                //                   // Navigator.of(context).push(
                                //                                      // MaterialPageRoute(builder: (context) => ChatScreen(contact.displayName)));
                                //                 },
                                //                   title: Text(contact.displayName,style: TextStyle(fontWeight: FontWeight.w400,),maxLines: 1,),
                                //                   leading: CircleAvatar(
                                //                     radius: 20,
                                //                     child: Icon(Icons.person),
                                //                   ),
                                //                   subtitle: Text('${phones}',style: TextStyle(fontWeight: FontWeight.w400,),maxLines: 1,)
                                //               );
                                //             });
                                //       }
                                //       return Center(child: CircularProgressIndicator());
                                //     },
                                //   ),
                                // ),
                            Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.only(top: 15,bottom: 10),
                                shrinkWrap: true,
                                physics: const ScrollPhysics(),
                                itemCount: searchController.text.isEmpty
                                    ? data.length
                                    : data.any((item) =>
                                "${item.firstName?.toLowerCase().toString()}" ==
                                    searchController.text.toLowerCase().toString())
                                    ? 1
                                    : 0,
                                itemBuilder: (context, index) {
                                int i=0;
                                if(searchController.text.isEmpty){
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) => ChatScreen(data[index])));
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
                                                  child: data[index].image != null?Image.network(
                                                    "https://freeze.talocare.co.in/public/${data[index].image}",
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
                                                      "${data[index].firstName??""} ${data[index].middleName??""} ${data[index].lastName??""}",
                                                      style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 15,),
                                                    ),
                                                    Text(
                                                      "${data[index].mobile}",
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.black.withOpacity(0.8)),
                                                    ),
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
                                else if(searchController.text.isNotEmpty){
                                  for(i=0; i<data.length; i++) {
                                    if ("${data[i].firstName?.toLowerCase()
                                        .toString()}" ==
                                        searchController.text.toLowerCase()
                                            .toString()) {
                                      // print("user found");
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ChatScreen(data[i])));
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 5),
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                          ),
                                          child: Column(
                                            children: [
                                              SizedBox(height: 3.h,),
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment
                                                    .center,
                                                children: [
                                                  CircleAvatar(
                                                    radius: 23,
                                                    child: ClipOval(
                                                      child: data[i].image !=
                                                          null ? Image.network(
                                                        "https://freeze.talocare.co.in/public/${data[i]
                                                            .image}",
                                                        height: 60,
                                                        width: 60,
                                                        fit: BoxFit.cover,
                                                      ) : const Icon(
                                                          PhosphorIcons
                                                              .user_bold),
                                                    ),
                                                  ),
                                                  SizedBox(width: 7.h,),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        Text(
                                                          "${data[i]
                                                              .firstName ??
                                                              ""} ${data[i]
                                                              .middleName ??
                                                              ""} ${data[i]
                                                              .lastName ?? ""}",
                                                          style: const TextStyle(
                                                            fontWeight: FontWeight
                                                                .w500,
                                                            fontSize: 15,),
                                                        ),
                                                        Text(
                                                          "${data[i].mobile}",
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                  0.8)),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }

                                  }
                                }


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
