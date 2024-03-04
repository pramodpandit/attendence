import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:office/ui/Settings/projectsetting.dart';
import 'package:office/ui/Settings/task_category.dart';

import '../../data/model/TaskCategory.dart';
import 'currency_setting.dart';
import 'designation_List.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
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
                      "Setting",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20
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
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  10.height,
                  ListSetting('Project',callback: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ProjectSetting()));
                  }),
                  5.height,
                  ListSetting('Department',callback: (){}),
                  5.height,
                  ListSetting('Designation',callback: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>DesignationList()));
                  }),
                  5.height,
                  ListSetting('Skills/Technology',callback: (){}),
                  5.height,
                  ListSetting('Task Category',callback: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>TaskCategorySetting()));
                  }),
                  5.height,
                  ListSetting('Task Label',callback: (){}),
                  5.height,
                  ListSetting('Leave Type',callback: (){}),
                  5.height,
                  ListSetting('Currency',callback: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>CurrencySetting()));
                  }),
                  5.height,
                  ListSetting('Company',callback: (){}),
                  5.height,
                  ListSetting('Branch',callback: (){}),
                  5.height,
                  ListSetting('Bank',callback: (){}),
                  5.height,
                  ListSetting('Attendance Setting',callback: (){}),
                  5.height,
                  ListSetting('Job Title',callback: (){}),
                  5.height,
                  ListSetting('Salary',callback: (){}),
                  5.height,
                  ListSetting('Experience',callback: (){}),
                  5.height
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
  Widget ListSetting(String title,{callback}){
    return InkWell(
      onTap: callback,
      child: Padding(
        padding: const EdgeInsets.only(left: 10,right: 10),
        child: Card(
          child: Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.all(Radius.circular(11))
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 14),),
                  Icon(Icons.arrow_forward_ios_outlined,color: Colors.black,)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
