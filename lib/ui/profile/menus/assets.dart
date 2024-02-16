import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:office/data/model/Assets_model.dart';
import 'package:office/ui/profile/menus/assets_details.dart';
import 'package:provider/provider.dart';
import '../../../bloc/profile_bloc.dart';
import '../../../data/repository/profile_repo.dart';

class Assets extends StatefulWidget {
  const Assets({Key? key}) : super(key: key);
  @override
  State<Assets> createState() => _AssetsState();
}

class _AssetsState extends State<Assets> {
  late ProfileBloc bloc;
  @override
  void initState() {
    bloc = ProfileBloc(context.read<ProfileRepository>());
    super.initState();
    bloc.fetchUserAssets();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(height: 10,width: 10,decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.blue),),
                      10.width,
                      Text(
                        'Total Stock',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.black, fontSize: 14,fontWeight: FontWeight.w400),
                      ),
                    ],),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(height: 10,width: 10,decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.green),),
                      10.width,
                      Text(
                        'Current Stock',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.black, fontSize: 14,fontWeight: FontWeight.w400),
                      ),
                    ],),
                ],
              ),
            ),
            ValueListenableBuilder(
                valueListenable: bloc.isAssetsLoad,
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
                      valueListenable: bloc.assetsUser,
                      builder: (context, List<UserAssets>? asset, __) {
                        if (asset == null) {
                          return const Center(
                            child: Text("User Details Not Found!"),
                          );
                        }
                        return  ListView.builder(
                            itemCount: asset.length,
                            physics: const ScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context,index){
                              UserAssets data = asset[index];
                              return InkWell(
                                onTap: (){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            Provider.value(
                                              value: bloc,
                                              child:  assetsDetail(data: data),
                                            ),
                                      )
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10,right: 10),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    margin: const EdgeInsets.only(bottom: 20),
                                    decoration: BoxDecoration(
                                      color:data.returnable =='0'?Colors.grey:Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            color:    Colors.grey.withOpacity(0.3),
                                            blurRadius: 3,
                                            spreadRadius: 1)
                                      ],

                                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                                    ),
                                    child:  Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 10,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${data.itemName}",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                Text(
                                                  '${data.itemGroupName}',
                                                  textAlign: TextAlign.start,
                                                  style: const TextStyle(
                                                      color: Colors.black, fontSize: 14,fontWeight: FontWeight.w400),
                                                ),
                                              ],
                                            ),
                                            // Text(
                                            //   index==1 || index==3?"Return":"Allotted",
                                            //   textAlign: TextAlign.left,
                                            //   style: TextStyle(
                                            //     fontWeight: FontWeight.w700,
                                            //     color:index==1 || index==3?const Color(0xFFD41817):const Color(0xFF3CEB43),
                                            //   ),
                                            // ),
                                            80.width,
                                            data.returnable=='1'?Container(height: 0,width: 0,):
                                            CircleAvatar(
                                              backgroundColor: Colors.blue,
                                              radius: 20,
                                              child: Text(
                                                '${data.totalStock.toString()}',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: data.returnable=='0'?Colors.grey:Colors.black, fontSize: 14,fontWeight: FontWeight.w400),
                                              ),
                                            ),
                                             10.width,
                                            CircleAvatar(
                                              radius: 20,
                                              backgroundColor: Colors.green,
                                              child: Text(
                                                '${data.returnable =='1'?data.stock.toString():'${data.stock}'}',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: Colors.white, fontSize: 14,fontWeight: FontWeight.w400),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 10),
                                              child: Icon(Icons.arrow_forward_ios_outlined),
                                            ),
                                          ],
                                        ),
                                        10.height
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                        );

                      });
                })

          ],
        ),
      ),
    );
  }
}

