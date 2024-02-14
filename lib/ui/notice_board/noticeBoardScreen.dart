import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:intl/intl.dart';
import 'package:office/bloc/notice_bloc.dart';
import 'package:office/data/model/notice_board.dart';
import 'package:office/data/repository/notice_repo.dart';
import 'package:office/ui/notice_board/notice_board_details.dart';
import 'package:office/ui/widget/app_bar.dart';
import 'package:provider/provider.dart';

class NoticeBoardScreen extends StatefulWidget {
  const NoticeBoardScreen({super.key});

  @override
  State<NoticeBoardScreen> createState() => _NoticeBoardScreenState();
}

class _NoticeBoardScreenState extends State<NoticeBoardScreen> {
  late NoticeBloc bloc;

  @override
  void initState() {
    bloc = NoticeBloc(context.read<NoticeRepository>());
    super.initState();
    bloc.fetchNoticeBoards();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: const MyAppBar(
      //   title: "Notice Board",
      // ),
      body: Stack(
        children: [
          Column(
            children: [
              Image.asset("images/back.png",fit: BoxFit.cover,height: 220,width: double.infinity,),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60,),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      PhosphorIcons.caret_left_bold,
                      color: Colors.black,
                    )),
              ),
              const SizedBox(height: 10,),
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  "Notice Board",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      letterSpacing: 0.5,
                      color: Colors.black),
                ),
              ),
              ValueListenableBuilder(
        valueListenable: bloc.loading,
        builder: (context, bool isLoading, child) {
          return ValueListenableBuilder(
            valueListenable: bloc.noticeBoards,
            builder: (context, List<NoticeBoard> noticeBoards, child) {
              if (isLoading) {
                return  Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.8,
                    ),
                    const Center(child: CircularProgressIndicator()),
                  ],
                );
              }
              if(noticeBoards.isEmpty){
                return const Center(child: Text('Data Not Exist!'));
              }
              return
              Expanded(
                child: ListView.builder(
                  itemCount: noticeBoards.length,
                  itemBuilder: (context, index) {
                    NoticeBoard data = noticeBoards[index];
                    return GestureDetector(
                      onTap:() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Provider.value(
                                    value: bloc,
                                    child:  NoticeBoardDetails(data: data),
                                  ),

                            )
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 5,
                                spreadRadius: 1,
                                color: Colors.black.withOpacity(0.1),
                              )
                            ]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Flexible(
                                  child: Text(
                                    "To ${noticeBoards[index].forEmployee??""}",
                                    style: const TextStyle(
                                        color: Colors.black54,
                                        fontSize: 12,
                                      fontWeight: FontWeight.w500
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              "${noticeBoards[index].title}",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              DateFormat.yMMMMd().format(DateTime.parse(
                                  "${noticeBoards[index].updateAt}")),
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 10,
                                color: Colors.black45,
                              ),
                            ),
                            if(noticeBoards[index].description != null)const SizedBox(
                              height: 10,
                            ),
                            if(noticeBoards[index].description != null)Html(
                              // data:noticeBoards[index].description!.length>250?"${noticeBoards[index].description!.substring(0,250)}......." :noticeBoards[index].description?? "",
                              // data: "${noticeBoards[index].description}",
                              data: (noticeBoards[index].description != null && noticeBoards[index].description!.length > 250)
                                  ? "${noticeBoards[index].description!.substring(0, 100)}..."
                                  : noticeBoards[index].description ?? "",

                              style: {
                                "body": Style(
                                  color: Colors.black54,
                                  fontWeight:
                                  FontWeight.w500,
                                  fontFamily: "Poppins",
                                  display: Display.inline,
                                  fontSize: FontSize(14),),
                                "p": Style(
                                  color: Colors.black54,
                                  padding: HtmlPaddings.zero,
                                  margin: Margins.zero,
                                  fontWeight:
                                  FontWeight.w500,
                                  fontFamily: "Poppins",
                                  display: Display.inline,
                                  fontSize: FontSize(14),),
                              },
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
            ],
          ),
        ],
      )
    );
  }
}
