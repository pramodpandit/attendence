import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:office/bloc/leads_bloc.dart';
import 'package:office/data/repository/lead_repository.dart';
import 'package:office/ui/leads/leadMenus/add_pages/add_lead_logs.dart';
import 'package:office/utils/message_handler.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../bloc/profile_bloc.dart';
import '../../../bloc/project_bloc.dart';
import '../../../data/model/user.dart';
import '../../../data/repository/profile_repo.dart';
import '../../../data/repository/project_repo.dart';
import '../../profile/menus/basic_info.dart';

class LeadLogs extends StatefulWidget {
  final data;
  const LeadLogs({Key? key,required this.data}) : super(key: key);

  @override
  State<LeadLogs> createState() => _LeadLogsState();
}

class _LeadLogsState extends State<LeadLogs> {
  _LeadLogsState();

  late LeadsBloc bloc;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc = LeadsBloc(context.read<LeadsRepository>());
    bloc.getSpecificLeadData(widget.data.toString(),"lead_logs");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child:ValueListenableBuilder(
          valueListenable: bloc.specificLeadData,
          builder: (context, specificLeadData, child) {
            if(specificLeadData ==null){
              return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: Center(child: CircularProgressIndicator()));
            }
            if(specificLeadData.isEmpty){
              return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: Center(child: Text("No data available")));
            }
            return   Padding(
              padding: const EdgeInsets.only(
                  left: 15, right: 15, top: 10, bottom: 10),
              child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.only(top: 10),
                  shrinkWrap: true,
                  itemCount: specificLeadData.length,
                  itemBuilder: (context, index) {
                    var data=specificLeadData[index];
                    return Container(
                      width: 1.sw,
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 3,
                              spreadRadius: 1,
                              color: Colors.black.withOpacity(0.2))
                        ],
                        // border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "${data['status']}",
                                // "${document[index].name}",
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    fontFamily: "Poppins"),
                              ),
                              Spacer(),
                              Text(
                                DateFormat.yMMMMd().format(DateTime.parse(data['create_at'])),
                                style: const TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    fontFamily: "Poppins"),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            '${data['message']}',

                            //"Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipi.Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipi",
                            //  "${document[index].other}",
                            style: const TextStyle(
                                color: Colors.black45,
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
                                fontFamily: "Poppins"),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          // Row(
                          //   children: [
                          //     Text("Next follow up"),
                          //     const SizedBox(width: 10),
                          //     Text("${data['next_followup']}")
                          //   ],
                          // ),
                        ],
                      ),
                    );
                  }),
            );
          },),


      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: 40,
            width: 90,
            child: FloatingActionButton.extended(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0))
                ),
                onPressed: () async{
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddLeadLogs(bloc: bloc,leadId: widget.data),));
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
                        "Logs",
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                )),
          ),
          SizedBox(height: 30,)
        ],
      ),
    );
  }
}
