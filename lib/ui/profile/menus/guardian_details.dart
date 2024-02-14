import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:office/bloc/profile_bloc.dart';
import 'package:office/data/model/guardianModel.dart';
import 'package:office/data/repository/profile_repo.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class GuardianDetails extends StatefulWidget {
  const GuardianDetails({Key? key}) : super(key: key);

  @override
  State<GuardianDetails> createState() => _GuardianDetailsState();
}

class _GuardianDetailsState extends State<GuardianDetails> {
  late ProfileBloc bloc;
  @override
  void initState() {
    bloc = ProfileBloc(context.read<ProfileRepository>());
    super.initState();
    bloc.fetchUserGuardianDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [

          ValueListenableBuilder(
              valueListenable: bloc.isGuardianDetailLoad,
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
                  padding: const EdgeInsets.only(
                      left: 25, right: 25, top: 5, bottom: 10),
                  child: ValueListenableBuilder(
                      valueListenable: bloc.userGuardian,
                      builder: (context, List<Guardian>? guardian, __) {
                        if (guardian == null) {
                          return const Center(
                            child: Text("User Details Not Found!"),
                          );
                        }
                        return ListView.builder(
                            physics: const ScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: guardian.length,
                            itemBuilder: (context, index) {
                              return Container(
                                width: 1.sw,
                                padding: const EdgeInsets.all(12),
                                margin: const EdgeInsets.only(bottom: 20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [BoxShadow(
                                    spreadRadius: 1,
                                    blurRadius: 3,
                                    color: Colors.grey.withOpacity(0.3)
                                  )],
                                  // border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      guardian[index].name ?? "---",
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          fontFamily: "Poppins"),
                                    ),
                                    Text(
                                      guardian[index].relationName ?? "---",
                                      style:  TextStyle(
                                          color: Colors.black.withOpacity(0.8),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                          fontFamily: "Poppins"),
                                    ),
                                    if(guardian[index].other!=null)const SizedBox(
                                      height: 5,
                                    ),
                                    if(guardian[index].other!=null)Text(
                                      guardian[index].other ?? "",
                                      style: const TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 11,
                                          fontFamily: "Poppins"),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        if (await canLaunchUrlString(
                                            "tel:${guardian[index].mobile}")) {
                                          await launchUrlString(
                                              "tel:${guardian[index].mobile}");
                                        } else {}
                                        // await launchUrlString("tel:${guardian[index].mobile}");
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          if(guardian[index].mobile!=null)Row(
                                            children: [
                                               Container(
                                                 padding: EdgeInsets.all(6),
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
                                                 child: const Icon(
                                                  Icons.phone,
                                                  color: Colors.red,
                                                  size: 12,
                                              ),
                                               ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                guardian[index].mobile ?? "",
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 11,
                                                    fontFamily: "Poppins"),
                                              ),
                                            ],
                                          ),
                                          if(guardian[index].email!=null)GestureDetector(
                                            onTap: () async {
                                              try {
                                                await launchUrlString(
                                                    "mailto:${guardian[index].email}");
                                              } catch (e) {
                                                if (kDebugMode) {
                                                  print(e);
                                                }
                                              }
                                            },
                                            child: Row(
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.all(6),
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
                                                  child: const Icon(
                                                    Icons.email,
                                                    color: Colors.red,
                                                    size: 12,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  guardian[index].email ??
                                                      "",
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 11,
                                                      fontFamily: "Poppins"),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            });
                      }),
                );
              }),
        ],
      ),
    ));
  }
}
