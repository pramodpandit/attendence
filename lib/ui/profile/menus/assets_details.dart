import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:office/bloc/profile_bloc.dart';
import 'package:office/data/model/Assets_model.dart';
import 'package:office/data/model/warning_model.dart';
import 'package:provider/provider.dart';

import '../../../data/model/Assets_Detail_modal.dart';

class assetsDetail extends StatefulWidget {
  const assetsDetail({Key? key, required this.data}) : super(key: key);
  final UserAssets data;
  @override
  State<assetsDetail> createState() => _assetsDetailState();
}

class _assetsDetailState extends State<assetsDetail> {
  late ProfileBloc bloc;
  @override
  void initState() {
    bloc = context.read<ProfileBloc>();
    super.initState();
    bloc.fetchUserAssetsDetail(widget.data.id!.toInt());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Assets Details",style: TextStyle(
          color:Color(0xFF253772),
          fontFamily: "Poppins", ),),
        centerTitle: true,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(PhosphorIcons.caret_left_bold,color:Color(0xFF253772) ,)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 15,right: 15),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        "${widget.data.itemName}",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),


                  ],
                ),
                Text(
                  widget.data.itemGroupName.toString(),
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color:Colors.black,
                  ),
                ),
               10.height,
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Table(
                    border: TableBorder.all(),
                    defaultColumnWidth: FixedColumnWidth(80),
                    children: [
                      TableRow(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                          ),
                          children:const [
                            Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Text("Date",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.w600),),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Text("Description",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.w600),),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Text("Status",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.w600),),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Text("Value",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.w600),),
                            ),
                          ]
                      ),
                    ],
                  ),
                ),
                // ValueListenableBuilder(
                //     valueListenable: bloc.isAssetsLoadDetail,
                //     builder: (context, bool loading, __) {
                //       if (loading == true) {
                //         return Column(
                //           children: [
                //             SizedBox(
                //               height: MediaQuery.of(context).size.width * 0.5,
                //             ),
                //             const Center(child: CircularProgressIndicator()),
                //           ],
                //         );
                //       }
                //       return Padding(
                //         padding: const EdgeInsets.only(
                //             left: 20, right: 20, top: 0, bottom: 10),
                //         child: ValueListenableBuilder(
                //             valueListenable: bloc.assetsUserDetail,
                //             builder: (context, List<UserAssetDetail>? asset, __) {
                //               if (asset == null) {
                //                 return const Center(
                //                   child: Text("User Details Not Found!"),
                //                 );
                //               }
                //               return ListView.builder(
                //                   itemCount: asset.length,
                //                   shrinkWrap: true,
                //                   physics: const ScrollPhysics(),
                //                   itemBuilder: (context,index){
                //                     UserAssetDetail data = asset[index];
                //                     return Container(
                //                       padding: const EdgeInsets.symmetric(horizontal: 10),
                //                       margin: const EdgeInsets.only(bottom: 20),
                //                       decoration: BoxDecoration(
                //                         boxShadow: [
                //                           BoxShadow(
                //                               color: Colors.grey.withOpacity(0.3),
                //                               blurRadius: 3,
                //                               spreadRadius: 1)
                //                         ],
                //                         color: Colors.white,
                //                         borderRadius: const BorderRadius.all(Radius.circular(10)),
                //                       ),
                //                       child:  Column(
                //                         crossAxisAlignment: CrossAxisAlignment.start,
                //                         mainAxisAlignment: MainAxisAlignment.start,
                //                         children: [
                //                           const SizedBox(height: 10,),
                //                           Row(
                //                             mainAxisAlignment: MainAxisAlignment.start,
                //                             crossAxisAlignment: CrossAxisAlignment.start,
                //                             children: [
                //                                Expanded(
                //                                 child: Text(
                //                                   "${data.itemName}",
                //                                   textAlign: TextAlign.left,
                //                                   style: TextStyle(
                //                                     fontWeight: FontWeight.w700,
                //                                   ),
                //                                 ),
                //                               ),
                //
                //                               Text(
                //                                 data.status=='allotment'?'Allotment':'Receiving',
                //                                 textAlign: TextAlign.left,
                //                                 style: TextStyle(
                //                                   fontWeight: FontWeight.w700,
                //                                   color:index==1 || index==3?const Color(0xFFD41817):const Color(0xFF3CEB43),
                //                                 ),
                //                               ),
                //                             ],
                //                           ),
                //                           Text(
                //                             data.itemGroupName.toString(),
                //                             textAlign: TextAlign.left,
                //                             style: TextStyle(
                //                               fontWeight: FontWeight.w700,
                //                               color:Colors.black
                //                             ),
                //                           ),
                //                           // Text(
                //                           //   DateFormat.yMMMMd().format(DateTime.parse(data.allotedDate.toString())),
                //                           //   textAlign: TextAlign.start,
                //                           //   style:  TextStyle(
                //                           //       color: Colors.black.withOpacity(0.7), fontSize: 8),
                //                           // ),
                //                           10.height,
                //
                //
                //                           const SizedBox(height: 10,),
                //                           // Text(
                //                           //   "Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipi.Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipi. Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipi.Neque porro quisquam.",
                //                           //   textAlign: TextAlign.left,
                //                           //   style: TextStyle(
                //                           //       color: Colors.black.withOpacity(0.7),
                //                           //       fontWeight:
                //                           //       FontWeight.w400,
                //                           //       fontFamily: "Poppins",
                //                           //       fontSize: 11
                //                           //   ),
                //                           // ),
                //                           const SizedBox(height: 20,),
                //                         ],
                //                       ),
                //                     );
                //                   }
                //               );
                //
                //
                //
                //
                //             }),
                //       );
                //     })
                // Text(
                //   // "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                //   widget.data.itemName ?? "",
                //   style: const TextStyle(
                //       color: Colors.black,
                //       fontSize:17,
                //       fontWeight: FontWeight.bold
                //   ),
                // ),
                // Text(
                //   DateFormat.yMMMMd().format(DateTime.parse(widget.data.updateAt.toString())),
                //   style: TextStyle(
                //       color: Colors.grey.withOpacity(0.6),
                //       fontSize:12,
                //       fontWeight: FontWeight.bold
                //   ),),
                // const SizedBox(height: 20,),
                // Row(
                //   children: [
                //     Icon(PhosphorIcons.user_fill,color: Colors.black.withOpacity(0.7),size: 20,),
                //     SizedBox(width: 10,),
                //    // Text("${widget.data.firstName ?? ""} ${widget.data.middleName ?? ""} ${widget.data.lastName ?? ""}",style: TextStyle(color: Colors.black.withOpacity(0.7),fontSize: 16,fontWeight: FontWeight.w600),)
                //   ],
                // ),
                // // Html(
                // //   // data:"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                // //   data:widget.data.description ?? "",
                // //   style: {
                // //     "body": Style(
                // //         color: Colors.black45,
                // //         fontWeight:
                // //         FontWeight.w600,
                // //         fontFamily: "Poppins",
                // //         display: Display.inline,
                // //         fontSize: FontSize(14),
                // //         textAlign: TextAlign.start
                // //     ),
                // //     "p": Style(
                // //         color: Colors.black45,
                // //         fontWeight:
                // //         FontWeight.w600,
                // //         // padding: EdgeInsets.zero,
                // //         fontFamily: "Poppins",
                // //         display: Display.inline,
                // //         fontSize: FontSize(14),
                // //         textAlign: TextAlign.start
                // //     ),
                // //   },
                // // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
