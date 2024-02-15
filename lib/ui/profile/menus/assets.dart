import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView.builder(
                itemCount: 4,
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemBuilder: (context,index){
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: 3,
                              spreadRadius: 1)
                        ],
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                      ),
                      child:  Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10,),
                           Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Expanded(
                                child: Text(
                                  "Mouse",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              Text(
                                index==1 || index==3?"Return":"Allotted",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color:index==1 || index==3?const Color(0xFFD41817):const Color(0xFF3CEB43),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            DateFormat.yMMMMd().format(DateTime.now()),
                            textAlign: TextAlign.start,
                            style:  TextStyle(
                                color: Colors.black.withOpacity(0.7), fontSize: 8),
                          ),
                          const SizedBox(height: 3,),
                          const Text(
                            "Given By:Rajan Sir",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: Colors.black, fontSize: 10,fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(height: 10,),
                           Text(
                            "Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipi.Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipi. Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipi.Neque porro quisquam.",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.7),
                                fontWeight:
                                FontWeight.w400,
                                fontFamily: "Poppins",
                                fontSize: 11
                            ),
                          ),
                          const SizedBox(height: 20,),
                        ],
                      ),
                    );
                  }
              ),
            )
          ],
        ),
      ),
    );
  }
}

