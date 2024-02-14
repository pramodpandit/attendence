import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../bloc/complaint_bloc.dart';
import '../../data/repository/complaint_repo.dart';
import '../../utils/message_handler.dart';
import 'complaintsListScreen.dart';

class OwnComplainList extends StatefulWidget {
  const OwnComplainList({Key? key}) : super(key: key);

  @override
  State<OwnComplainList> createState() => _OwnComplainListState();
}

class _OwnComplainListState extends State<OwnComplainList> {
  late ComplaintBloc bloc;
  @override
  void initState() {
    bloc = ComplaintBloc(context.read<ComplaintRepository>());
    super.initState();
    bloc.initEmployee();
    bloc.msgController!.stream.listen((event) {
      AppMessageHandler().showSnackBar(context, event);
    });
    bloc.complainStream.stream.listen((event) {
      if(event=="REVIEW_COMPLAIN") {
        Navigator.pop(context);
        bloc.initEmployee();
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  "Employee Complaints",
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
                                          isReviewButton: true,
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
          )
        ],
      ),
    );
  }
}
