import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:office/ui/leave/leaves_page.dart';
import 'package:office/ui/notification/notification_screen.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../bloc/notice_bloc.dart';
import '../../bloc/profile_bloc.dart';
import '../../bloc/task_bloc.dart';
import '../../data/model/notice_board.dart';
import '../../data/repository/notice_repo.dart';
import '../../data/repository/profile_repo.dart';
import '../../data/repository/task_repo.dart';
import '../notice_board/noticeBoardScreen.dart';
import '../notice_board/notice_board_details.dart';
import '../task/task_details.dart';
import '../task/task_screen.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  late ProfileBloc bloc;
  late NoticeBloc blocnotice;
  // late taskBloc ongoingbloc;

  @override
  void initState() {
    bloc = ProfileBloc(context.read<ProfileRepository>());
    blocnotice = NoticeBloc(context.read<NoticeRepository>());
    // ongoingbloc = taskBloc(context.read<TaskRepositary>(), );
    super.initState();
    bloc.fetchUserDetail();
    blocnotice.fetchNoticeBoards();
    bloc.fetchDoingTaskData();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: ValueListenableBuilder(
            valueListenable: bloc.isUserDetailLoad,
            builder: (context, bool loading, __) {
              if (loading == true) {
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
                valueListenable: bloc.userDetail,
                builder: (context, user, _) {
                  if (user == null) {
                    return Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 1,
                        ),
                        const Center(
                          child: Text("User Details Not Found!"),
                        ),
                      ],
                    );
                  }
                return Column(
                  children: [
                    Stack(
                      children: [
                        const SizedBox(
                          height: 240,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.only(bottomLeft: Radius.circular(30)),
                            color: Colors.blue,
                          ),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 60,
                                ),
                                Row(
                                  children: [
                                     Expanded(
                                       child: Text(
                                        "Hii, ${user.name}",
                                        maxLines: 1,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            overflow: TextOverflow.ellipsis,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500),
                                    ),
                                     ),
                                    const SizedBox(width: 15,),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(MaterialPageRoute(
                                            builder: (context) =>
                                                const NotificationScreen()));
                                      },
                                      child: const Icon(
                                        Icons.notifications,
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                                Text(
                                  DateFormat("EEEE, d MMMM y").format(DateTime.now()),
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white.withOpacity(0.8),
                                      fontWeight: FontWeight.w400),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                const Text(
                                  "What's Up Today?",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(
                                  height: 50,
                                )
                              ]),
                        ),
                        Positioned(
                            top: 165,
                            left: 25,
                            right: 20,
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            spreadRadius: 0,
                                            blurRadius: 3,
                                            color: Colors.black.withOpacity(0.2))
                                      ]),
                                  child: Column(children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(7),
                                        color: Colors.blue,
                                      ),
                                      child:  Text(
                                        DateFormat("MMM").format(DateTime.now()),
                                        // "Dec",
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                     Text(
                                       DateFormat("dd").format(DateTime.now()),
                                      // "04",
                                      style:const TextStyle(
                                          fontSize: 18,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ]),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                              spreadRadius: 0,
                                              blurRadius: 3,
                                              color: Colors.black.withOpacity(0.2))
                                        ]),
                                    child: const Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(Icons.computer),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Flexible(
                                                child: Text(
                                                  "UI/Ux Team Huddle",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w500),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "11:00 Am - 12:00 PM",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ]),
                                  ),
                                ),
                              ],
                            ))
                      ],
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            spreadRadius: 0,
                                            blurRadius: 3,
                                            color: Colors.black.withOpacity(0.2))
                                      ]),
                                  child: Column(children: [
                                    const Row(
                                      children: [
                                        Text(
                                          "Monday",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Spacer(),
                                        Text(
                                          "24 Dec 2023 | 05:38 PM",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    const Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              "ENTRY",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            Text(
                                              "00.00",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              "TOTAL",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            Text(
                                              "00.00",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              "BALANCE",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            Text(
                                              "00.00",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              "EXIT",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            Text(
                                              "00.00",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 3),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(100),
                                            color: Colors.blue,
                                          ),
                                          child: const Text(
                                            "Clock In",
                                            style: TextStyle(
                                                color: Colors.white, fontSize: 12),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 3),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(100),
                                            color: Colors.white,
                                            border: Border.all(color: Colors.blue),
                                          ),
                                          child: const Text(
                                            "Clock out",
                                            style: TextStyle(
                                                color: Colors.blue, fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    )
                                  ]),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      "Ongoing Task",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const Spacer(),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>TaskScreen()));
                                      },
                                      child: const Text(
                                        "See Details",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),

                                Container(
                                  child: ValueListenableBuilder(
                                    valueListenable: bloc.isUserDetailLoad,
                                    builder: (BuildContext context,bool isLoading,Widget? child){
                                      if(isLoading){
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                      return  ValueListenableBuilder(
                                        valueListenable: bloc.allDoingTaskData,
                                        builder: (context, allDoingTaskData, child) {
                                          if(allDoingTaskData == null){
                                            return CircularProgressIndicator();
                                          }
                                        return CarouselSlider.builder(

                                            itemCount: allDoingTaskData.length,
                                            itemBuilder: (context,index, realindex){
                                                return GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>TaskDetails(data: allDoingTaskData[index],)));
                                                  },
                                                  child:  SizedBox(
                                                    height: 120,
                                                    child: Container(
                                                      margin: EdgeInsets.all(5),
                                                      padding: const EdgeInsets.symmetric(
                                                          horizontal: 15, vertical: 10),
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(10),
                                                          color: Colors.white,
                                                          boxShadow: [
                                                            BoxShadow(
                                                                spreadRadius: 0,
                                                                blurRadius: 3,
                                                                color: Colors.black.withOpacity(0.2))
                                                          ]),
                                                      child:  Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Icon(Icons.computer),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              Flexible(
                                                                child: Text(
                                                                  "${allDoingTaskData[index]['title']}",
                                                                  style: TextStyle(
                                                                      fontSize: 14,
                                                                      color: Colors.black,
                                                                      fontWeight: FontWeight.w500),
                                                                ),
                                                              ),
                                                              Spacer(),
                                                              const DashedCircularProgressBar.square(
                                                                dimensions: 50,
                                                                progress: 60,
                                                                startAngle: 0,
                                                                sweepAngle: 360,
                                                                foregroundColor: Color(0xff4BCD36),
                                                                backgroundColor: Color(0xffeeeeee),
                                                                foregroundStrokeWidth: 5,
                                                                backgroundStrokeWidth: 5,
                                                                animation: true,
                                                                seekSize: 4,
                                                                seekColor: Colors.white,
                                                                child: Center(
                                                                    child: Text(
                                                                      '65%',
                                                                      style: TextStyle(
                                                                          fontSize: 12,
                                                                          fontWeight: FontWeight.w600),
                                                                    )),
                                                              ),
                                                            ],
                                                          ),
                                                          Container(
                                                            child: Html(
                                                              // data:"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                                                              data:
                                                              "${allDoingTaskData[index]['description']}",
                                                              style: {
                                                                "body": Style(
                                                                    color: Colors.black,
                                                                    fontWeight:
                                                                    FontWeight.w600,

                                                                    display: Display.inline,
                                                                    fontSize: FontSize(10),
                                                                    textAlign:
                                                                    TextAlign.start),
                                                                "p": Style(
                                                                    color: Colors.black,

                                                                    display: Display.inline,
                                                                    fontSize: FontSize(10),
                                                                    textAlign:
                                                                    TextAlign.start),
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );

                                            },
                                            options: CarouselOptions(
                                              autoPlay: false,
                                              enlargeCenterPage: false,
                                              aspectRatio: 2.0,
                                              viewportFraction: 1.0,
                                              initialPage: 0,

                                            ));
                                      },);
                                        },
                                  ),
                                ),

                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      "Application Leave",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const Spacer(),
                                    GestureDetector(
                                      onTap: () {},
                                      child: const Text(
                                        "See Details",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  height: 190,
                                  child: PageView.builder(
                                    itemCount: 2,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        margin: EdgeInsets.all(5),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 10),
                                       decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            spreadRadius: 0,
                                            blurRadius: 3,
                                            color: Colors.black.withOpacity(0.2))
                                      ]),
                                  child: Column(
                                      children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const CircleAvatar(
                                          child: Icon(Icons.person),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        const Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "John Smith",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Text(
                                              "Personal Leave Request",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Text(
                                              "Applied on 05/05/2023",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            color: Colors.yellow,
                                          ),
                                          child: const Text(
                                            "Pending",
                                            style: TextStyle(
                                                color: Colors.black, fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    const Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          children: [
                                            DashedCircularProgressBar.square(
                                              dimensions: 50,
                                              progress: 60,
                                              startAngle: 0,
                                              sweepAngle: 360,
                                              foregroundColor: Color(0xff4BCD36),
                                              backgroundColor: Color(0xffeeeeee),
                                              foregroundStrokeWidth: 5,
                                              backgroundStrokeWidth: 5,
                                              animation: true,
                                              seekSize: 4,
                                              seekColor: Colors.white,
                                              child: Center(
                                                  child: Text(
                                                '65%',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600),
                                              )),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              'Casual leave',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600),
                                            )
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            DashedCircularProgressBar.square(
                                              dimensions: 50,
                                              progress: 60,
                                              startAngle: 0,
                                              sweepAngle: 360,
                                              foregroundColor: Color(0xff4BCD36),
                                              backgroundColor: Color(0xffeeeeee),
                                              foregroundStrokeWidth: 5,
                                              backgroundStrokeWidth: 5,
                                              animation: true,
                                              seekSize: 4,
                                              seekColor: Colors.white,
                                              child: Center(
                                                  child: Text(
                                                '65%',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600),
                                              )),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              'Flexi leave',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            DashedCircularProgressBar.square(
                                              dimensions: 50,
                                              progress: 60,
                                              startAngle: 0,
                                              sweepAngle: 360,
                                              foregroundColor: Color(0xff4BCD36),
                                              backgroundColor: Color(0xffeeeeee),
                                              foregroundStrokeWidth: 5,
                                              backgroundStrokeWidth: 5,
                                              animation: true,
                                              seekSize: 4,
                                              seekColor: Colors.white,
                                              child: Center(
                                                  child: Text(
                                                '65%',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600),
                                              )),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              'Medical leave',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ]),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      "Notice Board",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const Spacer(),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>NoticeBoardScreen()));
                                      },
                                      child: const Text(
                                        "See Details",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                ),
                                20.height,
                                Container(
                                  child: ValueListenableBuilder(
                                    valueListenable: blocnotice.loading,
                                    builder: (context, bool isLoading, child) {
                                      return ValueListenableBuilder(
                                        valueListenable: blocnotice.noticeBoards,
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
                                            CarouselSlider.builder(
                                                itemCount: noticeBoards.length,
                                                itemBuilder: (context,index, realindex){
                                                  NoticeBoard data = noticeBoards[index];
                                                  return GestureDetector(
                                                    onTap:() {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                Provider.value(
                                                                  value: blocnotice,
                                                                  child:  NoticeBoardDetails(data: data),
                                                                ),
                                                          )
                                                      );
                                                    },
                                                    child: Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                                      margin: const EdgeInsets.only(bottom: 15, left: 8, right: 8),
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
                                                options: CarouselOptions(
                                                    autoPlay: true,
                                                    enlargeCenterPage: false,
                                                    aspectRatio: 2.0,
                                                    viewportFraction: 1.0,
                                                    initialPage: 0,
                                                )
                                            );
                                        },
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 110,
                                ),
                              ]),
                        ),
                      ),
                    ),
                  ],
                );
              }
            );
          }
        ),
      ),
    );
  }
}
