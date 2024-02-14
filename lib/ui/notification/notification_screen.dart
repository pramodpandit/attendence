import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:office/utils/constants.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      displacement: 200,
      backgroundColor: Colors.white,
      color: K.themeColorPrimary,
      strokeWidth: 3,
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      onRefresh: () async {
        await Future.delayed(Duration(milliseconds: 1500));
      },
      child: Scaffold(
        body: Stack(
          children: [
            Image.asset("images/back.png",fit: BoxFit.cover,height: 220,width: double.infinity,),
             Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 60,),
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        PhosphorIcons.caret_left_bold,
                        color: Colors.black,
                      )),
                  const SizedBox(height: 10,),
                  const Text(
                    "Notifications",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 22
                    ),
                  ),
                  RichText(text: const TextSpan(
                    children: [
                      TextSpan(
                          text: 'You Have ',
                          style: TextStyle(
                               color: Colors.black,fontSize: 12)),
                      TextSpan(
                          text: '3 New ',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, color: Colors.blue,fontSize: 12)),
                      TextSpan(
                          text: 'Notifications',
                          style: TextStyle(color: Colors.black,fontSize: 12))
                    ]
                  )),
                ],
              ),
            ),
            Column(
              children: [
                const SizedBox(height: 140,),
                Expanded(
                  child: ListView.builder(
                    itemCount: 20,
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemBuilder: (context, index) {
                      return  Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          margin: const EdgeInsets.only(bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const CircleAvatar(
                                child: Icon(Icons.person),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    RichText(text: const TextSpan(
                                        children: [
                                          TextSpan(
                                              text: 'Jacob ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500, color: Colors.blue,fontSize: 14)),
                                          TextSpan(
                                              text: 'Likes Your UI Design',
                                              style: TextStyle(color: Colors.black54,fontSize: 14))
                                        ]
                                    )),
                                    const Text(
                                      "2hr Ago",
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w400
                                      ),
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
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
