import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:office/bloc/leads_bloc.dart';
import 'package:office/ui/leads/add_lead.dart';
import 'package:office/ui/leads/create_lead_page.dart';
import 'package:office/ui/leads/lead_details.dart';
import 'package:provider/provider.dart';
import '../../data/repository/lead_repository.dart';
import '../profile/menus/basic_info.dart';

class LeadList extends StatefulWidget {
  const LeadList({Key? key}) : super(key: key);

  @override
  State<LeadList> createState() => _LeadListState();
}

class _LeadListState extends State<LeadList> {
  late LeadsBloc bloc;

  @override
  void initState() {
    bloc = LeadsBloc(context.read<LeadsRepository>());
    super.initState();
    // bloc.fetchAllLeadSource();
    // bloc.fetchAllManageBy();
    // bloc.department();
    // bloc.technology();
    // bloc.leadFor();
    bloc.getLeadData("open");
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
                  "Leads",
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
          Positioned(
            top: 56,
            right: 10,
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => Provider.value(
                      value: bloc,
                      child: const CreateNewLeadPage(),
                    )
                ));
              },
              child: const CircleAvatar(
                backgroundColor: Colors.white,
                radius: 15,
                child: Icon(Icons.add, size: 18,),
              ),
            ),
          ),
          Column(
            children: [
              const SizedBox(
                height: 100,
              ),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable:bloc.leadData,
                  builder: (context, leadData, child) {
                    if(leadData ==null){
                      return SizedBox(
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: Center(child: CircularProgressIndicator()));
                    }
                    if(leadData.isEmpty){
                      return SizedBox(
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: Center(child: Text("No data available")));
                    }
                    return ListView.builder(
                      itemCount: leadData.length,
                      itemBuilder: (context, index) {
                        var data = leadData[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => LeadDetails(data: data)));
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: 25,right: 25,bottom: 25),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      spreadRadius: 0,
                                      blurRadius: 5,
                                      color: Colors.black.withOpacity(0.1))
                                ]),
                            // ignore: prefer_const_constructors
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(height: 5,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${data['Lead_title']}",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 10,),
                                Dash(
                                  dashColor: Colors.grey.withOpacity(0.3),
                                  dashGap: 3,
                                  length: 270.w,
                                ),
                                const SizedBox(height: 10,),
                                 DetailsContainer(
                                  title:"${data['createdby_fname'] ?? ''} ${data['createdby_lname'] ?? ''}",
                                  heading: 'Created By', isHtml: false,
                                ),
                                Dash(
                                  dashColor: Colors.grey.withOpacity(0.3),
                                  dashGap: 3,
                                  length: 270.w,
                                ),
                                const SizedBox(height: 10,),
                                DetailsContainer(
                                  title:"${DateFormat.yMMMd().format(DateTime.parse(data['created_date']))}",
                                  //"${details["first_name"]!=null?details["first_name"]:""} ${details["middle_name"]!=null?details["middle_name"]:""} ${details["last_name"]!=null?details["last_name"]:""}",
                                  heading: 'Created At', isHtml: false,
                                ),
                                Dash(
                                  dashColor: Colors.grey.withOpacity(0.3),
                                  dashGap: 3,
                                  length: 270.w,
                                ),
                                const SizedBox(height: 10,),
                                 DetailsContainer(
                                  title:"${data['next_followup'].toString().split(" ").first}",
                                  //"${details["first_name"]!=null?details["first_name"]:""} ${details["middle_name"]!=null?details["middle_name"]:""} ${details["last_name"]!=null?details["last_name"]:""}",
                                  heading: 'Next Follow Up', isHtml: false,
                                ),
                                Dash(
                                  dashColor: Colors.grey.withOpacity(0.3),
                                  dashGap: 3,
                                  length: 270.w,
                                ),
                                const SizedBox(height: 10,),
                                DetailsContainer(
                                  title:"${data['last_follow_up'].toString().split(" ").first}",
                                  //"${details["first_name"]!=null?details["first_name"]:""} ${details["middle_name"]!=null?details["middle_name"]:""} ${details["last_name"]!=null?details["last_name"]:""}",
                                  heading: 'Last Follow Up', isHtml: false,
                                ),
                                Dash(
                                  dashColor: Colors.grey.withOpacity(0.3),
                                  dashGap: 3,
                                  length: 270.w,
                                ),
                                const SizedBox(height: 10,),
                                 DetailsContainer(
                                  title:"${data['clientsurname'] ?? ''} ${data['clientfirstname'] ?? ''} ${data['clientlastname'] ?? ''}",
                                  //"${details["first_name"]!=null?details["first_name"]:""} ${details["middle_name"]!=null?details["middle_name"]:""} ${details["last_name"]!=null?details["last_name"]:""}",
                                  heading: 'Client Name', isHtml: false,
                                ),
                                Dash(
                                  dashColor: Colors.grey.withOpacity(0.3),
                                  dashGap: 3,
                                  length: 270.w,
                                ),
                                const SizedBox(height: 10,),
                                 DetailsContainer(
                                  title:"${data['status']}",
                                  //"${details["first_name"]!=null?details["first_name"]:""} ${details["middle_name"]!=null?details["middle_name"]:""} ${details["last_name"]!=null?details["last_name"]:""}",
                                  heading: 'Status', isHtml: false,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          )
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: 50,
            width: 50,
            child: FloatingActionButton.extended(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0))
                ),
                onPressed: () async{
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.white,
                    builder: (context) {
                      List leadTypeData = [
                        {"title": "All", "value": "total"},
                        {"title": "Open", "value": "open"},
                        {"title": "Dead", "value": "dead"},
                        {"title": "Converted", "value": "converted"},
                      ];
                    return Container(
                      padding: EdgeInsets.all(10),
                      width: double.infinity,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: leadTypeData.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                              bloc.leadData.value = null;
                              bloc.leadType.value = leadTypeData[index]["value"];
                              bloc.getLeadData(leadTypeData[index]["value"]);
                            },
                            child: ValueListenableBuilder(
                              valueListenable: bloc.leadType,
                              builder: (context, type, child) {
                              return Container(
                                margin: EdgeInsets.all(5),
                                padding : EdgeInsets.symmetric(horizontal: 10,vertical: 3),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        leadTypeData[index]["title"],
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: type == leadTypeData[index]["value"]?Colors.white:Colors.black,
                                        )),
                                    type == leadTypeData[index]["value"]?Icon(PhosphorIcons.check_circle_fill,color: Colors.white):Offstage(),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                    color: type == leadTypeData[index]["value"]? Colors.green: Colors.white,
                                    borderRadius: BorderRadius.circular(5)
                                ),
                              );
                            },),
                          );
                        },
                      ),
                    );
                  },);
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (_) => Provider.value(
                  //         value: bloc,
                  //         child: const AddLead(),
                  //       )),
                  // );
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
                      Center(
                        // padding: EdgeInsets.only(right: 5.0),
                        child: Icon(
                          Icons.filter_alt,
                          color: Colors.white,
                        ),
                      ),
                      // Text(
                      //   "Lead",
                      //   style: TextStyle(color: Colors.white),
                      // )
                    ],
                  ),
                )),
          ),
          const SizedBox(height: 10,)
        ],
      ),
    );
  }
}
