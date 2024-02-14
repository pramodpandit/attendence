import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
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
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              PhosphorIcons.caret_left_bold,
              color: Colors.black,
            )),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Notice Board",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        letterSpacing: 0.5,
                        color: Colors.black),
                  ),
                  const SizedBox(
                    height: 50,
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
                 /* Text(
                    widget.data.description ?? "",
                    // "Deque poor squamous est qui do lorem ipsum qua dolor sit amet, consectetur, adipi.Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipi. Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipi.Neque porro quisquam. Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipi.Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipi. Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipi.Neque porro quisquam.Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipi.Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipi. Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipi.Neque porro quisquam. Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipi.Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipi. Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipi.Neque porro quisquam. Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipi.Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipi. Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipi.Neque porro quisquam.Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipi.Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipi. Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipi.Neque porro quisquam.",
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),*/
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
