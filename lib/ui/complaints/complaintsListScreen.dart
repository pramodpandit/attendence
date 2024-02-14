import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:office/bloc/complaint_bloc.dart';
import 'package:office/data/model/complaint_list_model.dart';
import 'package:office/data/repository/complaint_repo.dart';
import 'package:office/ui/complaints/complaintsDetailScreen.dart';
import 'package:office/ui/complaints/complaintsScreen.dart';
import 'package:office/utils/constants.dart';
import 'package:office/utils/message_handler.dart';
import 'package:provider/provider.dart';

class ComplaintsListScreen extends StatefulWidget {
  const ComplaintsListScreen({Key? key}) : super(key: key);

  @override
  State<ComplaintsListScreen> createState() => _ComplaintsListScreenState();
}

class _ComplaintsListScreenState extends State<ComplaintsListScreen> {
  late ComplaintBloc bloc;

  @override
  void initState() {
    bloc = ComplaintBloc(context.read<ComplaintRepository>());
    super.initState();
    bloc.init();
    bloc.msgController!.stream.listen((event) { 
      AppMessageHandler().showSnackBar(context, event);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: const MyAppBar(
      //   title: "Complaints",
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
                  "Complaints",
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
          // Positioned(
          //   top: 56,
          //   right: 10,
          //   child: GestureDetector(
          //     onTap: () {
          //       Navigator.of(context).push(MaterialPageRoute(
          //           builder: (context) => const OwnComplainList()));
          //     },
          //     child: const CircleAvatar(
          //       backgroundColor: Colors.white,
          //       radius: 15,
          //       child: Icon(
          //         Icons.arrow_downward,
          //         size: 18,
          //       ),
          //     ),
          //   ),
          // ),
          Column(
            children: [
              const SizedBox(height: 100,),
              Expanded(
                child: DefaultTabController(
                  length: 2,
                  initialIndex: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       const Material(
                        color: Colors.white,
                        child: SizedBox(
                          child: TabBar(
                            indicatorColor: Color(0xFF0E83EA),
                            tabs: [
                              Tab(
                                child: Text('In Progress',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF009FE3),
                                        fontFamily: 'Poppins')),
                              ),
                              Tab(
                                child: Text('Reviewed',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF009FE3),
                                        fontFamily: 'Poppins')),
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(left: 10,right: 10),
                          height: 1.sh,
                          width: 1.sw,
                          // padding: EdgeInsets.all(20.h),
                          child: TabBarView(
                            // controller: _tabController,
                            children: [
                              ValueListenableBuilder(
                                valueListenable: bloc.isListLoading,
                                builder: (BuildContext context, bool loading, Widget? child) {
                                  if(loading){
                                    return const Center(child: CircularProgressIndicator(color: Colors.blue,),);
                                  }
                                  if(bloc.progressList.isEmpty){
                                    return Center(child: Text("No data found",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18),));
                                  }
                                  return  ListView.builder(
                                    padding:const  EdgeInsets.only(top:10,bottom: 20),
                                  shrinkWrap: true,
                                  // reverse: true,
                                  itemCount: bloc.progressList.length,
                                  itemBuilder: (context, index) {
                                    return ComplaintsListView(
                                      data: bloc.progressList,
                                      index: index,
                                      bloc: bloc,
                                      isReviewButton: false,
                                    );
                                  });
                                },
                              ),
                              ValueListenableBuilder(
                                valueListenable: bloc.isListLoading,
                                builder: (BuildContext context, bool loading, Widget? child) {
                                  if(loading){
                                    return const Center(child: CircularProgressIndicator(),);
                                  }
                                    if(bloc.reviewedList.isEmpty){
                                    return Center(child: Text("No data found",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18),));
                                  }
                                  return  ListView.builder(
                                      padding:const  EdgeInsets.only(top:10,bottom: 20),
                                  shrinkWrap: true,
                                  // reverse: true,
                                  itemCount: bloc.reviewedList.length,
                                  itemBuilder: (context, index) {
                                    return ComplaintsListView(
                                      data: bloc.reviewedList,
                                      index: index,
                                      bloc: bloc,
                                      isReviewButton: false,
                                    );
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => Provider.value(
                        value: bloc,
                        child: const ComplaintScreen(),
                      )),
            );
          },
          backgroundColor: const Color(0xFF009FE3),
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
                  "Complain",
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          )),
    );
  }
}

class ComplaintsListView extends StatelessWidget {
  const ComplaintsListView(
      {super.key, required this.data, required this.index, required this.bloc,required this.isReviewButton});
  final List<ComplaintList> data;
  final int index;
  final bool isReviewButton;
  final ComplaintBloc bloc;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => Provider.value(
                      value: bloc,
                      child: ComplaintRequestsDetails(
                        complaint: data[index],
                        resolvedButton: isReviewButton==true?true:false,
                      ),
                    )));
      },
      child: Container(
        width: 1.sw,
        margin: const EdgeInsets.only(top: 10, right: 1),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              spreadRadius: 0,
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
                decoration:  BoxDecoration(
                    color: data[index].markAs == 'yes' ? Colors.green:data[index].markAs == 'no' ? Colors.red: Color(0xFF009FE3),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        bottomLeft: Radius.circular(10.0))),
              ),
              Container(
                width: 0.853.sw,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                color: Colors.white,
                child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${data[index].title}"
                      ,style: const TextStyle(
                          fontWeight: FontWeight.w500,color: Colors.black,fontSize: 16,fontFamily: "Poppins"
                      ),),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const Text(
                          "Complained To: ",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontSize: 10,
                              fontFamily: "Poppins"),
                        ),
                        SizedBox(width: 5,),
                        Text(data[index].compToValue == null ?
                          "${data[index].compTo}" : "${data[index].firstName ?? ''} ${data[index].middleName ?? ''} ${data[index].lastName ?? ''}",
                          style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              color: K.textColor,
                              fontSize: 9,
                              fontFamily: "Poppins"),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                   
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text("${DateFormat.yMMMd().format(DateTime.parse("${data[index].createdDate}"))}"
                            ,style: const TextStyle(
                                fontWeight: FontWeight.w500,color: K.textColor,fontSize: 11,fontFamily: "Poppins"
                            ),),
                        ),],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
