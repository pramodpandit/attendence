import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:office/bloc/work_from_home_bloc.dart';
import 'package:office/data/repository/work_from_home_repository.dart';
import 'package:office/ui/leave/leaves_detail.dart';
import 'package:office/ui/widget/loading_widget.dart';
import 'package:office/ui/work_from_home/apply_work_from_home.dart';
import 'package:office/ui/work_from_home/work_from_home_detail.dart';
import 'package:office/utils/constants.dart';
import 'package:office/utils/enums.dart';
import 'package:provider/provider.dart';

class WorkFromHomeMoreDetailPage extends StatefulWidget {
  const WorkFromHomeMoreDetailPage({Key? key}) : super(key: key);

  @override
  State<WorkFromHomeMoreDetailPage> createState() => _WorkFromHomeMoreDetailPageState();
}

class _WorkFromHomeMoreDetailPageState extends State<WorkFromHomeMoreDetailPage> {

  late WorkFromHomeBloc bloc;
  @override
  void initState() {
    bloc = WorkFromHomeBloc(context.read<WorkFromHomeRepository>());
    super.initState();
    bloc.workFromHomeController.stream.listen((event) {
      if(event=="LEAVE_REQUESTED") {
        Navigator.pop(context);
        bloc.getWorkFromHomeRecords();
      }
    });
    bloc.getWorkFromHomeRecords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => Provider.value(
                      value: bloc,
                      child: const ApplyWorkFromHome(),
                    )),
              );
            },
            backgroundColor: const Color(0xFF253772),
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
                    "Work from home",
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            )),
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
                    "Work from home records",
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
                  bloc.recordIndex.value = 0;
                  bloc.getWorkFromHomeRecords();
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
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: 50,
                          width: 1.sw,
                          child: ValueListenableBuilder(
                              valueListenable: bloc.recordIndex,
                              builder: (context, int recordIndex, _) {
                                return ListView(
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  children: [
                                    tabDetail(
                                      title: "All",
                                      isSelected: recordIndex==0,
                                      onTap: () {
                                        bloc.updateRecordIndex(0);
                                      },
                                    ),
                                    const SizedBox(width: 10),
                                    tabDetail(
                                      title: "Rejected",
                                      isSelected: recordIndex==1,
                                      onTap: () {
                                        bloc.updateRecordIndex(1);
                                      },
                                    ),
                                    const SizedBox(width: 10),
                                    tabDetail(
                                      title: "Approved",
                                      isSelected: recordIndex==2,
                                      onTap: () {
                                        bloc.updateRecordIndex(2);
                                      },
                                    ),
                                    const SizedBox(width: 10),
                                    tabDetail(
                                      title: "Pending",
                                      isSelected: recordIndex==3,
                                      onTap: () {
                                        bloc.updateRecordIndex(3);
                                      },
                                    ),
                                  ],
                                );
                              }
                          ),
                        ),
                      ),
                      ValueListenableBuilder(
                          valueListenable: bloc.workFromHomeState,
                          builder: (context, LoadingState state, _) {
                            if(state==LoadingState.loading) {
                              return const SliverFillRemaining(
                                child: Center(
                                  child: LoadingIndicator(color: K.themeColorPrimary,),
                                ),
                              );
                            }
                            if(state==LoadingState.error) {
                              return const SliverFillRemaining(
                                child: Center(
                                  child: Text("Some error occurred! Please try again!"),
                                ),
                              );
                            }
                            if(state==LoadingState.networkError) {
                              return const SliverFillRemaining(
                                child: Center(
                                  child: Text("No Internet Connection!"),
                                ),
                              );
                            }
                            return ValueListenableBuilder(
                                valueListenable: bloc.workFromHomeRecords,
                                builder: (context, List workFromHomeData, _) {
                                  if(workFromHomeData.isEmpty) {
                                    return const SliverFillRemaining(
                                      child: Center(
                                        child: Text("No Record Available!"),
                                      ),
                                    );
                                  }
                                  return SliverPadding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15),
                                    sliver: SliverList(
                                      delegate: SliverChildBuilderDelegate(
                                            (context, i) {
                                          Color borderColor = Colors.grey[200]!;
                                          return GestureDetector(
                                            onTap: (){
                                              // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>LeavesDetail(data: leaves[i])));
                                             var result = Navigator.of(context).push(MaterialPageRoute(
                                                builder: (context) => Provider.value(
                                                  value: bloc,
                                                  child: WorkFromHomeDetail(data: workFromHomeData[i],responseButton: false,),
                                                ),
                                              ));
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(vertical: 10),
                                              margin: const EdgeInsets.symmetric(vertical: 5),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5),
                                                border: Border.all(color: borderColor),
                                              ),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        workFromHomeData[i]['duration_type']!=null ? Container(
                                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                          decoration: BoxDecoration(
                                                            color: Colors.blueGrey.shade50,
                                                            borderRadius: BorderRadius.circular(5),
                                                          ),
                                                          child: Text(
                                                            workFromHomeData[i]['duration_type']=="multiple" ? "Multiple Days" : workFromHomeData[i]['duration_type']=="single" ? "Single Day" : workFromHomeData[i]['duration_type']=="first_half" ? "First Half" : workFromHomeData[i]['duration_type']=="second_half" ? "Second Half" : "",
                                                            style: const TextStyle(
                                                              color: Colors.blueGrey,
                                                              fontWeight: FontWeight.w500,
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ) : const SizedBox(),
                                                        Container(
                                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                          decoration: BoxDecoration(
                                                            color: workFromHomeData[i]['status']=="pending" ? Colors.orange.shade100 : workFromHomeData[i]['status']=="reject" ? Colors.red.shade100 : workFromHomeData[i]['status']=="approve" ? Colors.green.shade100 : Colors.grey.shade100,
                                                            borderRadius: BorderRadius.circular(5),
                                                          ),
                                                          child: Text(workFromHomeData[i]['status']=="pending" ? "Pending" : workFromHomeData[i]['status']=="reject" ? "Rejected" : workFromHomeData[i]['status']=="approve" ? "Approved" : "--", style: TextStyle(
                                                            color: workFromHomeData[i]['status']=="pending" ? Colors.orange : workFromHomeData[i]['status']=="reject" ? Colors.red : workFromHomeData[i]['status']=="approve" ? Colors.green : Colors.grey,
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 12,
                                                          ),),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Divider(color: borderColor),
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text("${workFromHomeData[i]['reason_title'] ?? "--"}", style: const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.w500,
                                                            color: K.themeColorPrimary
                                                        ),),
                                                        Row(
                                                          children: [
                                                            const Icon(PhosphorIcons.clock_afternoon, size: 18, color: K.textGrey,),
                                                            const SizedBox(width: 5),
                                                            Text("${workFromHomeData[i]['start_date']}", style: const TextStyle(
                                                              color: K.textGrey,
                                                              fontSize: 13,
                                                              fontWeight: FontWeight.w500,
                                                            ),),
                                                            const SizedBox(width: 5),
                                                            workFromHomeData[i]['duration_type']=="multiple"?
                                                            workFromHomeData[i]['end_date']!=null? Row(
                                                              children: [
                                                                CircleAvatar(radius: 4, backgroundColor: Colors.grey[200]),
                                                                const SizedBox(width: 5),
                                                                const Icon(PhosphorIcons.clock_afternoon, size: 18, color: K.textGrey,),
                                                                const SizedBox(width: 5),
                                                                Text("${workFromHomeData[i]['end_date']}", style: const TextStyle(
                                                                  color: K.textGrey,
                                                                  fontSize: 13,
                                                                  fontWeight: FontWeight.w500,
                                                                ),),
                                                              ],
                                                            )
                                                           :Offstage():Offstage()
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Divider(color: borderColor),
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                                    child: Text("${workFromHomeData[i]['reason']}", textAlign: TextAlign.start, style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey[700],
                                                    ),),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                        childCount: workFromHomeData.length,
                                      ),
                                    ),
                                  );
                                }
                            );
                          }
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        )
    );
  }

  Widget tabDetail({required String title, required bool isSelected, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? K.themeColorPrimary : Colors.grey[100],
          borderRadius: BorderRadius.circular(50),
        ),
        alignment: Alignment.center,
        child: Text(title, style: TextStyle(
          color: isSelected ? Colors.white : Colors.grey,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),),
      ),
    );
  }
}
