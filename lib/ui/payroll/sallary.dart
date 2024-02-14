import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:office/ui/payroll/payroll_slip.dart';

class sallary extends StatefulWidget {
  const sallary({super.key});

  @override
  State<sallary> createState() => _sallaryState();
}

class _sallaryState extends State<sallary> {
  List sallaryMonthly = [
    {
      "month":"April",
      "status":"green"
    },
    {
      "month":"March",
      "status":"red"
    },
    {
      "month":"February",
      "status":"orange"
    },
    {
      "month":"January",
      "status":"green"
    }
  ];
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
                    bottomRight: Radius.circular(20))),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 56,
                ),
                Text(
                  "Salary",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
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
                child: Icon(
                  Icons.arrow_back,
                  size: 18,
                ),
              ),
            ),
          ),
          Positioned(
            top: 56,
            right: 10,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const CircleAvatar(
                backgroundColor: Colors.white,
                radius: 15,
                child: Icon(
                  Icons.question_mark,
                  size: 18,
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
            const SizedBox(
                  height: 100,
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: sallaryMonthly.length,
                      itemBuilder: (context, index){
                    return Card(
                      child: ListTile(
                        onTap: (){
                          if(sallaryMonthly[index]['status']=='green'){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>payroll_slip()));
                          }
                          },
                        title:  Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.asset('images/Due_1.png'),
                                  SizedBox(width: 5,),
                                  Text(
                                      sallaryMonthly[index]['month'],
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.w700,
                                                          // color: ,
                                                          fontSize: 16,
                                                          fontFamily: "Poppins"),
                                                    ),

                                ],
                              ),
                              Icon(Icons.arrow_right_alt,size: 22,color:sallaryMonthly[index]['status']== 'green'?Colors.black:Colors.grey,)
                            ],
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.asset('images/status_2.png'),
                                  SizedBox(width: 5,),
                                  Text(
                                    'Status',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        // color: ,
                                        fontSize: 16,
                                        fontFamily: "Poppins"),
                                  ),
                                ],
                              ),
                              Container(
                                height: 10,
                                width: 10,decoration: BoxDecoration(shape: BoxShape.circle,color:sallaryMonthly[index]['status']=='green'?Colors.green:sallaryMonthly[index]['status']=='red'?Colors.red:Colors.orange ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          )
          // Column(
          //   children: [
          //     const SizedBox(
          //       height: 100,
          //     ),
          //     Expanded(
          //       child: SingleChildScrollView(
          //         child: Padding(
          //           padding: const EdgeInsets.symmetric(
          //               horizontal: 15, vertical: 40),
          //           child: Form(
          //             key: formKey,
          //             child: Column(
          //               mainAxisAlignment: MainAxisAlignment.start,
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: [
          //                 const Text(
          //                   "Tittle:",
          //                   style: TextStyle(
          //                       fontWeight: FontWeight.w500,
          //                       // color: ,
          //                       fontSize: 16,
          //                       fontFamily: "Poppins"),
          //                 ),
          //                 TextFormField(
          //                   style: const TextStyle(color: Colors.black),
          //                   controller: bloc.tittleController,
          //                   decoration: InputDecoration(
          //                     filled: true,
          //                     fillColor: const Color(0xffffffff),
          //                     errorBorder: OutlineInputBorder(
          //                       borderSide: BorderSide(
          //                           color: Colors.red.withOpacity(1)),
          //                       borderRadius: BorderRadius.circular(12),
          //                     ),
          //                     focusedErrorBorder: OutlineInputBorder(
          //                       borderSide: BorderSide(
          //                           color: Colors.red.withOpacity(1)),
          //                       borderRadius: BorderRadius.circular(12),
          //                     ),
          //                     contentPadding: const EdgeInsets.all(17.0),
          //                     focusedBorder: OutlineInputBorder(
          //                       borderSide: BorderSide(
          //                           color: const Color(0xff777777)
          //                               .withOpacity(0.8)),
          //                       borderRadius: BorderRadius.circular(12),
          //                     ),
          //                     enabledBorder: OutlineInputBorder(
          //                       borderSide: BorderSide(
          //                           color:
          //                           const Color(0xff777777).withOpacity(1)),
          //                       borderRadius: BorderRadius.circular(12),
          //                     ),
          //                     hintText: "Title",
          //                     focusColor: Colors.white,
          //                     counterStyle:
          //                     const TextStyle(color: Colors.white),
          //                     hintStyle: const TextStyle(
          //                         color: Color(0xff777777),
          //                         fontSize: 12,
          //                         fontWeight: FontWeight.w400,
          //                         fontFamily: "Poppins"),
          //                   ),
          //                   validator: (value) {
          //                     if (value.toString().isEmpty) {
          //                       return "Title is required";
          //                     }
          //                     return null;
          //                   },
          //                   onTap: () {},
          //                 ),
          //                 const SizedBox(
          //                   height: 20,
          //                 ),
          //                 const Text(
          //                   "Description:",
          //                   style: TextStyle(
          //                       fontWeight: FontWeight.w500,
          //                       // color: ,
          //                       fontSize: 16,
          //                       fontFamily: "Poppins"),
          //                 ),
          //                 TextFormField(
          //                   style: const TextStyle(color: Colors.black),
          //                   controller: bloc.descriptionController,
          //                   keyboardType: TextInputType.multiline,
          //                   maxLines: 5,
          //                   decoration: InputDecoration(
          //                     filled: true,
          //                     fillColor: const Color(0xffffffff),
          //                     errorBorder: OutlineInputBorder(
          //                       borderSide: BorderSide(
          //                           color: Colors.red.withOpacity(1)),
          //                       borderRadius: BorderRadius.circular(12),
          //                     ),
          //                     focusedErrorBorder: OutlineInputBorder(
          //                       borderSide: BorderSide(
          //                           color: Colors.red.withOpacity(1)),
          //                       borderRadius: BorderRadius.circular(12),
          //                     ),
          //                     contentPadding: const EdgeInsets.all(17.0),
          //                     focusedBorder: OutlineInputBorder(
          //                       borderSide: BorderSide(
          //                           color: const Color(0xff777777)
          //                               .withOpacity(0.8)),
          //                       borderRadius: BorderRadius.circular(12),
          //                     ),
          //                     enabledBorder: OutlineInputBorder(
          //                       borderSide: BorderSide(
          //                           color:
          //                           const Color(0xff777777).withOpacity(1)),
          //                       borderRadius: BorderRadius.circular(12),
          //                     ),
          //                     hintText: "Description",
          //                     focusColor: Colors.white,
          //                     counterStyle:
          //                     const TextStyle(color: Colors.white),
          //                     hintStyle: const TextStyle(
          //                         color: Color(0xff777777),
          //                         fontSize: 12,
          //                         fontWeight: FontWeight.w400,
          //                         fontFamily: "Poppins"),
          //                   ),
          //                   validator: (value) {
          //                     if (value.toString().isEmpty) {
          //                       return "Description is required";
          //                     }
          //                     return null;
          //                   },
          //                 ),
          //                 const SizedBox(
          //                   height: 20,
          //                 ),
          //                 const Text(
          //                   "Complaint To:",
          //                   style: TextStyle(
          //                       fontWeight: FontWeight.w500,
          //                       // color: ,
          //                       fontSize: 16,
          //                       fontFamily: "Poppins"),
          //                 ),
          //                 Column(
          //                   mainAxisAlignment: MainAxisAlignment.start,
          //                   crossAxisAlignment: CrossAxisAlignment.start,
          //                   children: [
          //                     Row(
          //                       children: [
          //                         Radio(
          //                           value: 1,
          //                           groupValue: selectedOption,
          //                           onChanged: (value) {
          //                             setState(() {
          //                               selectedOption = value!;
          //                               bloc.complainTo ='HR';
          //                             });
          //                           },
          //                         ),
          //                         const Text('Human Resource',)
          //                       ],
          //                     ),
          //                     Row(
          //                       children: [
          //                         Radio(
          //                           value: 2,
          //                           groupValue: selectedOption,
          //                           onChanged: (value) {
          //                             setState(() {
          //                               selectedOption = value!;
          //                               bloc.complainTo ='report_to';
          //                             });
          //                           },
          //                         ),
          //                         const Text('Reporting To',),
          //                       ],
          //                     ),
          //                     Row(
          //                       children: [
          //                         Radio(
          //                           value: 3,
          //                           groupValue: selectedOption,
          //                           onChanged: (value) {
          //                             setState(() {
          //                               selectedOption = value!;
          //                               bloc.complainTo ='Administrator';
          //                             });
          //                           },
          //                         ),
          //                         const Text('Administrator',),
          //                       ],
          //                     )
          //                   ],
          //                 ),
          //
          //                 // ValueListenableBuilder(
          //                 //     valueListenable: reportTo,
          //                 //     builder: (context,bool report,__){
          //                 //       return Column(
          //                 //         crossAxisAlignment: CrossAxisAlignment.start,
          //                 //         children: [
          //                 //           const Text(
          //                 //             "Complaint To:",
          //                 //             style: TextStyle(
          //                 //                 fontWeight: FontWeight.w500,
          //                 //                 // color: ,
          //                 //                 fontSize: 16,
          //                 //                 fontFamily: "Poppins"),
          //                 //           ),
          //                 //           DropdownButtonFormField(
          //                 //             items: advisors.map((String value) {
          //                 //               return DropdownMenuItem<String>(
          //                 //                   value: value.toString(), child: Text(value.toString()));
          //                 //             }).toList(),
          //                 //             onChanged: (String? value) {
          //                 //               if(value == 'Administrator'){
          //                 //                 bloc.complainTo ='Administrator';
          //                 //                 reportTo.value=false;
          //                 //               }
          //                 //               if(value == 'Reporting Person'){
          //                 //                 reportTo.value=true;
          //                 //                 return;
          //                 //                 // bloc.complainTo = 'report_to';
          //                 //               }
          //                 //             },
          //                 //             style: const TextStyle(color: Colors.black),
          //                 //             decoration: InputDecoration(
          //                 //               filled: true,
          //                 //               fillColor: const Color(0xffffffff),
          //                 //               errorBorder: OutlineInputBorder(
          //                 //                 borderSide: BorderSide(color: Colors.red.withOpacity(1)),
          //                 //                 borderRadius: BorderRadius.circular(12),
          //                 //               ),
          //                 //               focusedErrorBorder: OutlineInputBorder(
          //                 //                 borderSide: BorderSide(color: Colors.red.withOpacity(1)),
          //                 //                 borderRadius: BorderRadius.circular(12),
          //                 //               ),
          //                 //               contentPadding: const EdgeInsets.all(17.0),
          //                 //               focusedBorder: OutlineInputBorder(
          //                 //                 borderSide: BorderSide(
          //                 //                     color: const Color(0xff777777).withOpacity(0.8)),
          //                 //                 borderRadius: BorderRadius.circular(12),
          //                 //               ),
          //                 //               enabledBorder: OutlineInputBorder(
          //                 //                 borderSide: BorderSide(
          //                 //                     color: const Color(0xff777777).withOpacity(1)),
          //                 //                 borderRadius: BorderRadius.circular(12),
          //                 //               ),
          //                 //               hintText: "Complain To",
          //                 //               focusColor: Colors.white,
          //                 //               counterStyle: const TextStyle(color: Colors.white),
          //                 //               hintStyle: const TextStyle(
          //                 //                   color: Color(0xff777777),
          //                 //                   fontSize: 12,
          //                 //                   fontWeight: FontWeight.w400,
          //                 //                   fontFamily: "Poppins"),
          //                 //             ),
          //                 //           ),
          //                 //           if(reportTo.value==true)const SizedBox(
          //                 //             height: 30,
          //                 //           ),
          //                 //           if(reportTo.value==true)const Text(
          //                 //             "Reporting To:",
          //                 //             style: TextStyle(
          //                 //                 fontWeight: FontWeight.w500,
          //                 //                 // color: ,
          //                 //                 fontSize: 16,
          //                 //                 fontFamily: "Poppins"),
          //                 //           ),
          //                 //           // if(reportTo.value==true)DropdownButtonFormField(
          //                 //           //   items: advisors.map((String value) {
          //                 //           //     return DropdownMenuItem<String>(
          //                 //           //         value: value.toString(), child: Text(value.toString()));
          //                 //           //   }).toList(),
          //                 //           //   onChanged: (String? value) {
          //                 //           //     if(value == 'Administrator'){
          //                 //           //       bloc.complainTo ='Administrator';
          //                 //           //     }
          //                 //           //     if(value == 'Reporting Person'){
          //                 //           //       bloc.complainTo = 'report_to';
          //                 //           //     }
          //                 //           //   },
          //                 //           //   style: const TextStyle(color: Colors.black),
          //                 //           //   decoration: InputDecoration(
          //                 //           //     filled: true,
          //                 //           //     fillColor: const Color(0xffffffff),
          //                 //           //     errorBorder: OutlineInputBorder(
          //                 //           //       borderSide: BorderSide(color: Colors.red.withOpacity(1)),
          //                 //           //       borderRadius: BorderRadius.circular(12),
          //                 //           //     ),
          //                 //           //     focusedErrorBorder: OutlineInputBorder(
          //                 //           //       borderSide: BorderSide(color: Colors.red.withOpacity(1)),
          //                 //           //       borderRadius: BorderRadius.circular(12),
          //                 //           //     ),
          //                 //           //     contentPadding: const EdgeInsets.all(17.0),
          //                 //           //     focusedBorder: OutlineInputBorder(
          //                 //           //       borderSide: BorderSide(
          //                 //           //           color: const Color(0xff777777).withOpacity(0.8)),
          //                 //           //       borderRadius: BorderRadius.circular(12),
          //                 //           //     ),
          //                 //           //     enabledBorder: OutlineInputBorder(
          //                 //           //       borderSide: BorderSide(
          //                 //           //           color: const Color(0xff777777).withOpacity(1)),
          //                 //           //       borderRadius: BorderRadius.circular(12),
          //                 //           //     ),
          //                 //           //     hintText: "Reporting To",
          //                 //           //     focusColor: Colors.white,
          //                 //           //     counterStyle: const TextStyle(color: Colors.white),
          //                 //           //     hintStyle: const TextStyle(
          //                 //           //         color: Color(0xff777777),
          //                 //           //         fontSize: 12,
          //                 //           //         fontWeight: FontWeight.w400,
          //                 //           //         fontFamily: "Poppins"),
          //                 //           //   ),
          //                 //           // ),
          //                 //           if(reportTo.value==true)ValueListenableBuilder(valueListenable: profileBloc.isAllUserDetailLoad, builder: (context, bool loading, child) {
          //                 //             if(loading){
          //                 //               return const CircularProgressIndicator();
          //                 //             }
          //                 //             return DropdownButtonFormField(
          //                 //               // dropdownColor: Colors.grey.shade500,
          //                 //               style: const TextStyle(color: Colors.black),
          //                 //               decoration: InputDecoration(
          //                 //                 filled: true,
          //                 //                 fillColor: const Color(0xffffffff),
          //                 //                 errorBorder: OutlineInputBorder(
          //                 //                   borderSide: BorderSide(color: Colors.red.withOpacity(1)),
          //                 //                   borderRadius: BorderRadius.circular(12),
          //                 //                 ),
          //                 //                 focusedErrorBorder: OutlineInputBorder(
          //                 //                   borderSide: BorderSide(color: Colors.red.withOpacity(1)),
          //                 //                   borderRadius: BorderRadius.circular(12),
          //                 //                 ),
          //                 //                 contentPadding: const EdgeInsets.all(17.0),
          //                 //                 focusedBorder: OutlineInputBorder(
          //                 //                   borderSide: BorderSide(
          //                 //                       color: const Color(0xff777777).withOpacity(0.8)),
          //                 //                   borderRadius: BorderRadius.circular(12),
          //                 //                 ),
          //                 //                 enabledBorder: OutlineInputBorder(
          //                 //                   borderSide: BorderSide(
          //                 //                       color: const Color(0xff777777).withOpacity(1)),
          //                 //                   borderRadius: BorderRadius.circular(12),
          //                 //                 ),
          //                 //                 hintText: "Reporting To",
          //                 //                 focusColor: Colors.white,
          //                 //                 counterStyle: const TextStyle(color: Colors.white),
          //                 //                 hintStyle: const TextStyle(
          //                 //                     color: Color(0xff777777),
          //                 //                     fontSize: 12,
          //                 //                     fontWeight: FontWeight.w400,
          //                 //                     fontFamily: "Poppins"),
          //                 //               ),
          //                 //               items: profileBloc.allUserDetail.value?.map((User items) {
          //                 //                 return DropdownMenuItem(
          //                 //                   value: "${items.firstName??""} ${items.middleName??""} ${items.lastName??""}",
          //                 //                   child: Text(
          //                 //                     "${items.firstName??""} ${items.middleName??""} ${items.lastName??""}" ?? "",
          //                 //                   ),
          //                 //                 );
          //                 //               }).toList(),
          //                 //               onChanged: (v) {
          //                 //                 profileBloc.allUser.value = v;
          //                 //               },
          //                 //             );
          //                 //           },),
          //                 //         ],
          //                 //       );
          //                 //     }
          //                 // ),
          //
          //
          //                 const SizedBox(
          //                   height: 30,
          //                 ),
          //                 Row(
          //                   mainAxisAlignment: MainAxisAlignment.end,
          //                   children: [
          //                     ValueListenableBuilder(
          //                       valueListenable: bloc.isSubmit,
          //                       builder: (BuildContext context, bool loading,
          //                           Widget? child) {
          //                         if (loading) {
          //                           return Container(
          //                               margin: EdgeInsets.only(right: 20),
          //                               child: CircularProgressIndicator());
          //                         }
          //                         return ElevatedButton(
          //                           onPressed: () async {
          //                             if (formKey.currentState!.validate()) {
          //                               bloc.addComplaint();
          //                             }
          //                           },
          //                           style: ElevatedButton.styleFrom(
          //                               backgroundColor: Color(0xFF009FE3),
          //                               padding: const EdgeInsets.symmetric(
          //                                   vertical: 10, horizontal: 30),
          //                               elevation: 4,
          //                               shape: RoundedRectangleBorder(
          //                                   borderRadius:
          //                                   BorderRadius.circular(30.0))),
          //                           child: const Text(
          //                             "Submit",
          //                             style: TextStyle(color: Colors.white),
          //                           ),
          //                         );
          //                       },
          //                     ),
          //                   ],
          //                 )
          //               ],
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
