import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../data/model/notice_board.dart';

class NoticeBoardDetails extends StatefulWidget {
  const NoticeBoardDetails({Key? key, required this.data}) : super(key: key);
  final NoticeBoard data;

  @override
  State<NoticeBoardDetails> createState() => _NoticeBoardDetailsState();
}

class _NoticeBoardDetailsState extends State<NoticeBoardDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                          bottomRight: Radius.circular(20))
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 56,),
                      Text(
                        "Notice Board",
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
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const Text(
                  //   "Notice Board",
                  //   style: TextStyle(
                  //       fontWeight: FontWeight.w600,
                  //       fontSize: 20,
                  //       letterSpacing: 0.5,
                  //       color: Colors.black),
                  // ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    widget.data.title ?? "",
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    DateFormat.yMMMMd()
                        .format(DateTime.parse("${widget.data.updateAt}")),
                    textAlign: TextAlign.start,
                    style: const TextStyle(color: Colors.black54, fontSize: 8),
                  ),
                  const SizedBox(
                    height: 5,
                  ),

                  Html(
                    data: widget.data.description ?? "",
                    // data: "${noticeBoards[index].description}",
                    style: {
                      "body": Style(
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Poppins",
                        display: Display.inline,
                        fontSize: FontSize(13),
                      ),
                      "p": Style(
                        color: Colors.black54,
                        padding: HtmlPaddings.zero,
                        margin: Margins.zero,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Poppins",
                        display: Display.inline,
                        fontSize: FontSize(13),
                      ),
                    },
                  ),
                  const SizedBox(
                    height: 20,
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
