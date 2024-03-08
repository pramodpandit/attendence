import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:office/bloc/profile_bloc.dart';
import 'package:office/data/model/bankDetails_model.dart';
import 'package:office/data/repository/profile_repo.dart';
import 'package:office/utils/message_handler.dart';
import 'package:provider/provider.dart';

class BankDetails extends StatefulWidget {
  const BankDetails({Key? key}) : super(key: key);

  @override
  State<BankDetails> createState() => _BankDetailsState();
}

class _BankDetailsState extends State<BankDetails> {
  late ProfileBloc bloc;
  @override
  void initState() {
    bloc = ProfileBloc(context.read<ProfileRepository>());
    super.initState();
    bloc.fetchBankDocuments();
    bloc.msgController?.stream.listen((event) {
      AppMessageHandler().showSnackBar(context, event);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ValueListenableBuilder(
                valueListenable: bloc.isBankDetailsLoad,
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
                  return Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25, bottom: 10),
                    child: Column(
                      children: [
                        ValueListenableBuilder(
                            valueListenable: bloc.userBankDetails,
                            builder: (context,
                                List<BankDetailsModel>? bankDetail, __) {
                              if (bankDetail == null) {
                                return const Center(
                                  child: Text("User Details Not Found!"),
                                );
                              }
                              return ListView.builder(
                                  physics: const ScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: bankDetail.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (bankDetail[index].method == "upi")
                                          Container(
                                            width: 1.sw,
                                            padding: const EdgeInsets.all(12),
                                            margin: const EdgeInsets.only(
                                                bottom: 20),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                                  // bankDetail[index].deafult == 0
                                                  //     ? const Color(0xFF253772)
                                                  //     : Colors.grey
                                                  //         .withOpacity(0.2),
                                              boxShadow: [
                                                BoxShadow(
                                                  spreadRadius: 1,
                                                  blurRadius: 3,
                                                  color: Colors.grey.withOpacity(0.3)
                                                )
                                              ],
                                              // border: Border.all(color: Colors.black),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  //crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Text(
                                                      'Mobile Payment',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          // bankDetail[
                                                          //                 index]
                                                          //             .deafult ==
                                                          //         0
                                                          //     ? Colors.white
                                                          //     : const Color(
                                                          //         0xFF253772),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 13,
                                                          fontFamily:
                                                              "Poppins"),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        Clipboard.setData(
                                                                ClipboardData(
                                                                    text:
                                                                        'UPI\n${bankDetail[index].upiId ?? "---"}\n${bankDetail[index].other ?? "---"}'))
                                                            .then((_) {
                                                              bloc.showMessage(MessageType.info('Copied UPI Details to your clipboard !'));
                                                          // ScaffoldMessenger.of(
                                                          //         context)
                                                          //     .showSnackBar(
                                                          //         const SnackBar(
                                                          //             content: Text(
                                                          //                 'Copied UPI Details to your clipboard !')));
                                                        });
                                                      },
                                                      child: const Icon(
                                                        Icons.copy,
                                                        size: 20,
                                                        color: Colors.blue,
                                                        // bankDetail[index]
                                                        //             .deafult ==
                                                        //         0
                                                        //     ? Colors.white
                                                        //     : Colors.grey,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                DetailCard(icon: 'images/bank.png', tittle: "UPI Id", data: bankDetail[index].upiId ??
                                                          "---",),
                                                // DetailCard(icon: PhosphorIcons.device_mobile, tittle: "Mobile Number", data: bankDetail[index].upiId ??
                                                //           "---",),
                                                const SizedBox(height: 10,),
                                                // Text(
                                                //   bankDetail[index].upiId ??
                                                //       "---",
                                                //   // '8448722041@paytm',
                                                //   style: TextStyle(
                                                //       color: bankDetail[index]
                                                //                   .deafult ==
                                                //               0
                                                //           ? Colors.white
                                                //           : Colors.black,
                                                //       fontWeight:
                                                //           FontWeight.w600,
                                                //       fontSize: 11,
                                                //       fontFamily: "Poppins"),
                                                // ),
                                                // const SizedBox(
                                                //   height: 5,
                                                // ),
                                                if(bankDetail[index].other!=null)Text(
                                                  bankDetail[index].other ??
                                                      "---",
                                                  // "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s",
                                                  style: TextStyle(
                                                      color: Colors.black.withOpacity(0.8),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 12,
                                                      fontFamily: "Poppins"),
                                                ),
                                              ],
                                            ),
                                          ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        if (bankDetail[index].method == "bank")
                                          Container(
                                            width: 1.sw,
                                            padding: const EdgeInsets.all(12),
                                            margin: const EdgeInsets.only(
                                                bottom: 20),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                                  // bankDetail[index].deafult == 0
                                                  //     ? const Color(0xFF253772)
                                                  //     : Colors.grey
                                                  //         .withOpacity(0.2),
                                              boxShadow: [
                                                BoxShadow(
                                                    spreadRadius: 1,
                                                    blurRadius: 3,
                                                    color: Colors.grey.withOpacity(0.3)
                                                )
                                              ],
                                              // border: Border.all(color: Colors.black),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  //crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Text(
                                                      'Bank Payment',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14,
                                                          fontFamily:
                                                              "Poppins"),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        Clipboard.setData(
                                                                ClipboardData(
                                                                    text:
                                                                        'Bank Details\nBank Name\n${bankDetail[index].bankName ?? "---"}\nAccount Holder Name\n${bankDetail[index].bankHolderName ?? "---"}\nAccount No\n${bankDetail[index].accountNo ?? "---"}\nIFSC No\n${bankDetail[index].ifscCode ?? "---"}\n${bankDetail[index].other ?? "---"}'))
                                                            .then((_) {
                                                              bloc.showMessage(MessageType.info('Copied Bank Details to your clipboard !'));
                                                          // ScaffoldMessenger.of(
                                                          //         context)
                                                          //     .showSnackBar(
                                                          //         const SnackBar(
                                                          //             content: Text(
                                                          //                 'Copied Bank Details to your clipboard !')));
                                                        });
                                                      },
                                                      child: const Icon(
                                                        Icons.copy,
                                                        size: 20,
                                                        color: Colors.blue,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                DetailCard(icon: 'images/bank.png', tittle: "Bank Name", data: bankDetail[index]
                                                    .bankName ??
                                                    "---",),
                                                DetailCard(icon: 'images/list.png', tittle: "IFSC Code", data:  bankDetail[index]
                                                    .ifscCode ??
                                                    "---",),
                                                DetailCard(icon: 'images/user.png', tittle: "Account Number", data: bankDetail[index]
                                                    .accountNo ??
                                                    "---",),
                                                // BankDetailsContainer(
                                                //     title: bankDetail[index]
                                                //             .bankName ??
                                                //         "---",
                                                //     heading: "Bank Name",
                                                //     defaultColor:
                                                //         bankDetail[index]
                                                //                 .deafult ==
                                                //             0),
                                                // BankDetailsContainer(
                                                //     title: bankDetail[index]
                                                //             .bankHolderName ??
                                                //         "---",
                                                //     heading:
                                                //         "Account Holder Name",
                                                //     defaultColor:
                                                //         bankDetail[index]
                                                //                 .deafult ==
                                                //             0),
                                                // BankDetailsContainer(
                                                //     title: bankDetail[index]
                                                //             .accountNo ??
                                                //         "---",
                                                //     heading: "Account No",
                                                //     defaultColor:
                                                //         bankDetail[index]
                                                //                 .deafult ==
                                                //             0),
                                                // BankDetailsContainer(
                                                //     title: bankDetail[index]
                                                //             .ifscCode ??
                                                //         "---",
                                                //     heading: "IFSC NO",
                                                //     defaultColor:
                                                //         bankDetail[index]
                                                //                 .deafult ==
                                                //             0),
                                                const SizedBox(height: 10,),
                                                if(bankDetail[index].other!=null)Text(
                                                  bankDetail[index].other ??
                                                      "---",
                                                  style: TextStyle(
                                                      color:Colors.black,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 12,
                                                      fontFamily: "Poppins"),
                                                ),
                                              ],
                                            ),
                                          )
                                      ],
                                    );
                                  });
                            })
                      ],
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}

// class BankDetailsContainer extends StatelessWidget {
//   final String? title;
//   final String? heading;
//   final bool? defaultColor;
//
//   const BankDetailsContainer({
//     Key? key,
//     @required this.title,
//     @required this.heading,
//     @required this.defaultColor,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(
//         bottom: 3,
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             heading!,
//             style: TextStyle(
//               fontSize: 10,
//               fontWeight: FontWeight.bold,
//               fontFamily: 'Poppins',
//               color:
//                   defaultColor == true ? Colors.white : const Color(0xFF253772),
//             ),
//           ),
//           Container(
//             width: 1.sw,
//             //height: 0.08.sh,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(5),
//               //color: Color(0xFFeceef9).withOpacity(0.3),
//             ),
//             /* padding: EdgeInsets.only(
//               left: 10,
//             ),*/
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   title!,
//                   textAlign: TextAlign.start,
//                   style: TextStyle(
//                     fontSize: 11,
//                     // fontWeight: FontWeight.bold,
//                     // fontFamily: 'Poppins',
//                     color: defaultColor == true ? Colors.white : Colors.black,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class DetailCard extends StatelessWidget {
  const DetailCard({Key? key, required this.icon, required this.tittle, required this.data}) : super(key: key);
  final String icon;
  final String tittle;
  final String data;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 40,
            width: 40,
            padding: EdgeInsets.all(9),
            margin: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      spreadRadius: 1,
                      blurRadius: 3,
                      color: Colors.grey.withOpacity(0.3)
                  )
                ]
            ),
            child: Image.asset(icon)),
        const SizedBox(width: 10,),
        Text(tittle,
          style: TextStyle(
            color: Colors.black.withOpacity(0.7),
            fontWeight: FontWeight.w500,
          ),
        ),
        // Spacer(),
        // Text(":",style: TextStyle(fontWeight: FontWeight.w700),),
        Spacer(),
        Text(data,style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w400,
        ),),
      ],
    );
  }
}
