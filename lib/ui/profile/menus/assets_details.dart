import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:office/bloc/profile_bloc.dart';
import 'package:office/data/model/Assets_model.dart';
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
                       "Assets Details",
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
          SizedBox(height: 10,),
          SingleChildScrollView(
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
                    ValueListenableBuilder(
                        valueListenable: bloc.isAssetsLoadDetail,
                        builder: (context, bool loading, __) {
                          if (loading == true) {
                            return Column(
                              children: [
                                SizedBox(
                                  height: MediaQuery.of(context).size.width * 0.5,
                                ),
                                const Center(child: CircularProgressIndicator()),
                              ],
                            );
                          }
                          return ValueListenableBuilder(
                              valueListenable: bloc.assetsUserDetail,
                              builder: (context, List<UserAssetDetail>? asset, __) {
                                if (asset == null) {
                                  return const Center(
                                    child: Text("User Details Not Found!"),
                                  );
                                }
                                return
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: DataTable(
                                      columnSpacing: 10.0,
                                      columns: [
                                        DataColumn(label: Text('Date',style: TextStyle(fontWeight: FontWeight.w700),)),
                                        DataColumn(label: Text('Description',style: TextStyle(fontWeight: FontWeight.w700))),
                                        DataColumn(label: Text('Status',style: TextStyle(fontWeight: FontWeight.w700))),
                                        DataColumn(label: Text('Value',style: TextStyle(fontWeight: FontWeight.w700))),
                                      ],
                                      rows: List.generate(
                                          asset.length, (index) {
                                        return DataRow(
                                            cells: [
                                          DataCell(Center(child: Container(width: 75, child: Text("${DateFormat.yMd().format(DateTime.parse(asset[index].createdAt.toString()))}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 11),),))),
                                          DataCell(Center(child: Container(  child: Text("${asset[index].remarks}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 11),),)),),
                                          DataCell(Center(child: Container(  child: Text("${asset[index].status}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 11),),))),
                                          DataCell(Center(child: Container( child: Text("${asset[index].returnable}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 11),),)))
                                        ]);
                                      }),
                                    ),
                                  );
                              });
                        }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
