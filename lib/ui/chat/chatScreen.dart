import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:office/data/model/user.dart';
import 'package:office/ui/community/communityProfile.dart';
import 'package:office/ui/widget/more_sheet.dart';
import 'package:provider/provider.dart';

import '../../bloc/profile_bloc.dart';
import '../../data/repository/profile_repo.dart';

class ChatScreen extends StatefulWidget {
  final User user;
  const ChatScreen(this.user,{Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController sendmessage = TextEditingController();
  File? galleryFile;
  late ProfileBloc profileBloc;
  List<String> messageType = ["r", "s", "s", "r", "s", "s", "r", "s"];
  Future<void> _openGallery() async {
    print("Opening Image Picker");
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        galleryFile = File(pickedFile.path);
        profileBloc.image = galleryFile;
      });
    }
  }

  @override
  void initState() {
    profileBloc=ProfileBloc(context.read<ProfileRepository>());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget imageView = SizedBox.shrink();
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;
    if (galleryFile != null) {
      imageView = Stack(children: [
        //image container:::
        Container(
          height: heightScreen / 2,
          width: widthScreen *0.7,
          margin: EdgeInsets.only(left: widthScreen*0.1,top: heightScreen*0.03),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            image: DecorationImage(
                fit: BoxFit.fill,
                image: FileImage(
                  galleryFile!,
                )),
            //color: Colors.amber,
          ),
        ),
        //cross::::
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
              onPressed: () {
                setState(() {
                  galleryFile = null;
                });
              },
              icon: Icon(Icons.highlight_remove)),
        )
      ]);
    }
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: Column(
          children: [
             Container(
              height:35,
               color: Colors.grey.withOpacity(0.2),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(25),bottomLeft: Radius.circular(25))
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back,
                    ),
                  ),
                  const SizedBox(width: 5),
                   CircleAvatar(
                     radius: 20,
                     child: ClipOval(
                      child: widget.user.image != null?Image.network(
                        "https://freeze.talocare.co.in/public/${widget.user.image}",
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                      ):const Icon(PhosphorIcons.user_bold),
                  ),
                   ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CommunityProfile()));
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Text(
                             "${widget.user.firstName??""} ${widget.user.middleName??""} ${widget.user.lastName??""}",
                            maxLines: 1,
                            style: const TextStyle(fontWeight: FontWeight.w500,overflow: TextOverflow.ellipsis),
                          ),
                          Text(
                            "online",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                overflow: TextOverflow.ellipsis,
                                fontSize: 12,
                                color: Colors.blue.shade400),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Spacer(),
                  SizedBox(
                    width: 15,
                  ),
                  GestureDetector(
                      onTap: () {},
                      child: Icon(
                        Icons.videocam,
                        color: Colors.blue,
                      )),
                  SizedBox(
                    width: 15,
                  ),
                  GestureDetector(
                      onTap: () {},
                      child: Icon(
                        Icons.call,
                        color: Colors.blue,
                        size: 20,
                      )),
                  SizedBox(
                    width: 15,
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
                                items: ["Report", "Block"],
                                icons: [Icon(Icons.report), Icon(Icons.block)]);
                          },
                        );
                      },
                      child: Icon(Icons.more_vert)),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ListView.builder(
                  itemCount: 8,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Column(
                        children: [
                          Container(
                            margin: messageType[index] == "r"
                                ? const EdgeInsets.only(right: 80)
                                : const EdgeInsets.only(left: 80),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius: messageType[index] == "r"
                                  ? const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    )
                                  : const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                    ),
                              color: messageType[index] == "r"
                                  ? Colors.grey.withOpacity(0.3)
                                  : Colors.blue,
                            ),
                            child: Text(
                              "Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipi",
                              style: TextStyle(
                                color: messageType[index] == "r"
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                          ),
                          Padding(
                            padding: messageType[index] == "r"
                                ? const EdgeInsets.only(left: 10)
                                : const EdgeInsets.only(right: 10),
                            child: Row(
                              mainAxisAlignment: messageType[index] == "r"
                                  ? MainAxisAlignment.start
                                  : MainAxisAlignment.end,
                              children: [
                                if (messageType[index] == "r")
                                  Icon(PhosphorIcons.checks_bold,
                                      size: 14,
                                      color: messageType[index] == "r"
                                          ? Colors.blue.shade700
                                          : Colors.grey.withOpacity(0.8)),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "1:30 AM",
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey.withOpacity(0.8)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        spreadRadius: 1,
                        blurRadius: 3,
                        color: Colors.black.withOpacity(0.2),
                      )
                    ]),
                padding: const EdgeInsets.only(
                    bottom: 10, top: 10, left: 10, right: 10),
                child: Column(
                  children: [
                    imageView,
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: sendmessage,
                            keyboardType: TextInputType.multiline,
                            maxLines: 3,
                            minLines: 1,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Send Message...",
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        InkWell(
                            onTap: (){
                              _openGallery();
                            },
                            child: const Icon(Icons.attach_file)),
                        const SizedBox(
                          width: 10,
                        ),
                        const Icon(PhosphorIcons.paper_plane_tilt),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
