import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:office/ui/widget/app_bar.dart';

class LeavePolicy extends StatelessWidget {
  const LeavePolicy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: MyAppBar(title: "Leave Policy"),
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
                  "Leave Policy",
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
            child: InkWell(
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
          Column(
            children: [
              const SizedBox(height: 70,),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 30.h,),
                      ListView.builder(
                        itemCount: 2,
                        shrinkWrap: true,
                        itemBuilder: (context,index) {
                          return Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 10),
                            margin: EdgeInsets.only(bottom: 25,left: 20,right: 20,top: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: [BoxShadow(
                                spreadRadius: 0,
                                blurRadius: 3,
                                color: Colors.black.withOpacity(0.2),
                              )]
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Text("SICK LEAVE",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16),),
                                ),
                                SizedBox(height: 10,),
                                Dash(
                                  dashColor: Colors.grey.withOpacity(0.3),
                                  dashGap: 3,
                                  length: 325.w,
                                ),
                                SizedBox(height: 10,),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Text("Paid",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16),),
                                ),
                                SizedBox(height: 10,),
                                Dash(
                                  dashColor: Colors.grey.withOpacity(0.3),
                                  dashGap: 3,
                                  length: 325.w,
                                ),
                                SizedBox(height: 10,),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Text("Allowence",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16),),
                                ),
                                SizedBox(height: 10,),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                  child: Row(
                                    children: [
                                      Text("Month: 1",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 14,color: Colors.grey),),
                                      Spacer(),
                                      Text("Year: 12",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 14,color: Colors.grey),),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Dash(
                                  dashColor: Colors.grey.withOpacity(0.3),
                                  dashGap: 3,
                                  length: 325.w,
                                ),
                                SizedBox(height: 10,),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                  child: Row(
                                    children: [
                                      Text("Carry Forward:",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 14),),
                                      SizedBox(width: 5,),
                                      Text("No",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 14,color: Colors.grey),),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
