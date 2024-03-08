import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:office/bloc/profile_bloc.dart';
import 'package:office/data/model/warning_model.dart';
import 'package:provider/provider.dart';

class WarningDetails extends StatefulWidget {
  const WarningDetails({Key? key, required this.data}) : super(key: key);
  final WarningModel data;
  @override
  State<WarningDetails> createState() => _WarningDetailsState();
}

class _WarningDetailsState extends State<WarningDetails> {
  late ProfileBloc bloc;
  @override
  void initState() {
    bloc = context.read<ProfileBloc>();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Warning Details",style: TextStyle(
      //     color:Color(0xFF253772),
      //     fontFamily: "Poppins", ),),
      //   centerTitle: true,
      //   leading: GestureDetector(
      //     onTap: () {
      //       Navigator.pop(context);
      //     },
      //       child: const Icon(PhosphorIcons.caret_left_bold,color:Color(0xFF253772) ,)),
      // ),
      body: Column(
        children: [
          Stack(
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
                      "Warning",
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
            ],
          ),
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(
                  left: 25, right: 25, top: 10, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      widget.data.title ?? "",
                    style: const TextStyle(
                        color: Colors.black,
                      fontSize:17,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Text(
                    DateFormat.yMMMMd().format(DateTime.parse(widget.data.updatedAt.toString())),
                    style: TextStyle(
                      color: Colors.grey.withOpacity(0.6),
                      fontSize:12,
                      fontWeight: FontWeight.bold
                  ),),
                  const SizedBox(height: 20,),
                  Row(
                    children: [
                      Icon(PhosphorIcons.user_fill,color: Colors.black.withOpacity(0.7),size: 20,),
                      SizedBox(width: 10,),
                      Text("${widget.data.firstName ?? ""} ${widget.data.middleName ?? ""} ${widget.data.lastName ?? ""}",style: TextStyle(color: Colors.black.withOpacity(0.7),fontSize: 16,fontWeight: FontWeight.w600),)
                    ],
                  ),
                  Html(
                   data:widget.data.description ?? "",
                    style: {
                      "body": Style(
                          color: Colors.black45,
                          fontWeight:
                              FontWeight.w600,
                          fontFamily: "Poppins",
                        display: Display.inline,
                        fontSize: FontSize(14),
                        textAlign: TextAlign.start
                      ),
                      "p": Style(
                          color: Colors.black45,
                          fontWeight:
                          FontWeight.w600,
                          // padding: EdgeInsets.zero,
                          fontFamily: "Poppins",
                          display: Display.inline,
                          fontSize: FontSize(14),
                          textAlign: TextAlign.start
                      ),
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
