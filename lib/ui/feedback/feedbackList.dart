import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:office/bloc/feedback_bloc.dart';
import 'package:office/data/repository/feedback_repo.dart';
import 'package:office/ui/widget/app_bar.dart';
import 'package:provider/provider.dart';

import '../../utils/constants.dart';
import 'FeedbackScreen.dart';

class FeedbackListScreen extends StatefulWidget {
  const FeedbackListScreen({Key? key}) : super(key: key);

  @override
  State<FeedbackListScreen> createState() => _FeedbackListScreenState();
}

class _FeedbackListScreenState extends State<FeedbackListScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late FeedbackBloc bloc;

  @override
  void initState() {
    bloc = FeedbackBloc(context.read<FeedbackRepository>());
    super.initState();
    bloc.feedbackList();
  }

  @override
  void dispose() {
    bloc.feedbackStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      // appBar: const MyAppBar(
      //   title: "Feedbacks",
      // ),
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
                  "Feedbacks",
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
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: bloc.isFeedbackLoading,
                  builder: (BuildContext context, bool loading, Widget? child) {
                    if (loading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ListView.builder(
                        padding:const  EdgeInsets.only(top:10,bottom: 20),
                        itemCount: bloc.feedbackData.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Container(
                            width: 1.sw,
                            margin: const EdgeInsets.only(left: 10,right: 10,top: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  spreadRadius:0,
                                  blurRadius: 3,
                                  color: Colors.black.withOpacity(0.1),
                                )
                              ],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: IntrinsicHeight(
                              child: Row(
                                children: [
                                  Container(
                                    width: 5,
                                    decoration: const BoxDecoration(
                                        // color: Color(0xFF253772),
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10.0),
                                            bottomLeft: Radius.circular(10.0))),
                                  ),
                                  Container(
                                    width: 0.875.sw,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 10),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(top: 4.0),
                                          child: Image.asset(
                                            "images/feedback_icon.png",
                                            height: 20,
                                            width: 20,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            // mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${bloc.feedbackData[index].message}",
                                                style: const TextStyle(
                                                    fontFamily: "Poppins",
                                                    fontSize: 12,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w400),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              if(bloc.feedbackData[index].createdAt != null)
                                              Align(
                                                alignment: Alignment.bottomRight,
                                                child: Text(
                                                  DateFormat.yMMMd().format(DateTime.parse("${bloc.feedbackData[index].createdAt}")),
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      fontFamily: "Poppins",
                                                      fontSize: 11,
                                                      fontWeight: FontWeight.w300),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton:Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: 40,
            width: 90,
            child: FloatingActionButton.extended(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0))
                ),
                onPressed: () async {
                  var result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Provider.value(
                        value: bloc,
                        child: const FeedbackScreen(),
                      ),
                    ),
                  );
                  if (result == "refresh") {}
                },
                backgroundColor: const  Color(0xFF009FE3),
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
                  child: const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 5.0),
                        child: Icon(
                          PhosphorIcons.plus_circle_fill,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Add",
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                )),
          ),
          SizedBox(height: 30,)
        ],
      ),
      /*FloatingActionButton.extended(
          onPressed: () async {
            var result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => Provider.value(
                  value: bloc,
                  child: const FeedbackScreen(),
                ),
              ),
            );
            if (result == "refresh") {}
          },
          // backgroundColor: Color(0xFF253772),
          backgroundColor: const Color(0xff0B20AA).withOpacity(1),
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
            child: const Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 10.0),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "Add",
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          )),*/
    );
  }
}
