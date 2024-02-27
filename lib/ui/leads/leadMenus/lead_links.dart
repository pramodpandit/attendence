import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:office/bloc/leads_bloc.dart';
import 'package:office/data/repository/lead_repository.dart';
import 'package:office/utils/message_handler.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../bloc/profile_bloc.dart';
import '../../../bloc/project_bloc.dart';
import '../../../data/model/user.dart';
import '../../../data/repository/profile_repo.dart';
import '../../../data/repository/project_repo.dart';
import '../../profile/menus/basic_info.dart';

class LeadLinks extends StatefulWidget {
  final data;
  const LeadLinks({Key? key,required this.data}) : super(key: key);

  @override
  State<LeadLinks> createState() => _LeadLinksState();
}

class _LeadLinksState extends State<LeadLinks> {
  _LeadLinksState();

  late LeadsBloc bloc;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc = LeadsBloc(context.read<LeadsRepository>());
    bloc.getSpecificLeadData(widget.data.toString(),"lead_links");
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
                  left: 25, right: 25, top: 10, bottom: 10),
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
                                "${data['name']}",
                                // "${document[index].name}",
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    fontFamily: "Poppins"),
                              ),
                              Spacer(),
                              Text(
                                DateFormat.yMMMMd().format(DateTime.parse(data['created_date'])),
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
                            '${data['other_link_info']}',

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
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  final Uri url = Uri.parse(
                                      '${data['links']}');
                                  try {
                                    await launchUrl(url);
                                  } catch (e) {
                                    bloc.showMessage(MessageType.info('${data['links']} does not exist'));
                                  }
                                },
                                child: Container(
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(100),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                              spreadRadius: 0,
                                              blurRadius: 3,
                                              color: Colors.black.withOpacity(0.2))
                                        ]),
                                    child: const Icon(
                                      PhosphorIcons.link_bold,
                                      color: Colors.black,
                                      size: 20,
                                    )),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: Text("${data['links']}"),
                              )
                            ],
                          ),
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
                        "Links",
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
