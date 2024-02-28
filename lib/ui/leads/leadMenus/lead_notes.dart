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

import 'add_pages/add_lead_notes.dart';



class LeadNotes extends StatefulWidget {
  final data;
  const LeadNotes({Key? key,required this.data}) : super(key: key);

  @override
  State<LeadNotes> createState() => _LeadNotesState();
}

class _LeadNotesState extends State<LeadNotes> {
  _LeadNotesState();

  late LeadsBloc bloc;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc = LeadsBloc(context.read<LeadsRepository>());
    bloc.getSpecificLeadData(widget.data.toString(),"lead_notes");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ValueListenableBuilder(
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
                return Container(
                  height: MediaQuery.of(context).size.height,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15,vertical:0),
                    child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount:specificLeadData.length,
                        padding: EdgeInsets.only(top: 10),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var data = specificLeadData[index];
                          return GestureDetector(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                margin: const EdgeInsets.only(bottom: 20),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        blurRadius: 3,
                                        spreadRadius: 2)
                                  ],
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                ),
                                child:  Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 5,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${data['title']}",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 8
                                          ),
                                        ),
                                        Flexible(
                                          child: Text(
                                            "${DateFormat.yMMMd().format(DateTime.parse(data['created_at']))}",
                                            style: const TextStyle(
                                                color: Colors.black54,
                                                fontSize: 10
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    // const Text(
                                    //   "Web Development",
                                    //   textAlign: TextAlign.left,
                                    //   style: TextStyle(
                                    //     fontWeight: FontWeight.w700,
                                    //   ),
                                    // ),

                                    const SizedBox(height: 5,),
                                    Html(
                                      data: data['description'],
                                      // data:"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                                      // data:notes[index].description ?? "",
                                      style: {
                                        "body": Style(
                                            color: Colors.black,
                                            fontWeight:
                                            FontWeight.w500,
                                            fontFamily: "Poppins",
                                            display: Display.inline,
                                            fontSize: FontSize(11),
                                            textAlign: TextAlign.start
                                        ),
                                        "p": Style(
                                            color: Colors.black,
                                            fontWeight:
                                            FontWeight.w500,
                                            // padding: EdgeInsets.zero,
                                            fontFamily: "Poppins",
                                            display: Display.inline,
                                            fontSize: FontSize(11),
                                            textAlign: TextAlign.start
                                        ),
                                      },
                                    ),
                                    const SizedBox(height: 15,)
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  ) ,
                );
              },),
          ],
        ),
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
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>AddLeadNotes(leadId:widget.data,bloc: bloc,)));
               // var data =   await Navigator.push(
               //      context,
               //      MaterialPageRoute(
               //        builder: (_) => Provider.value(
               //          value: bloc,
               //          child: AddLeadNotes(leadId:  widget.data),
               //        ),
               //      ),
               //    );
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
                        "Notes",
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
