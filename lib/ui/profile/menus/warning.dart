import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:office/bloc/profile_bloc.dart';
import 'package:office/data/model/warning_model.dart';
import 'package:office/data/repository/profile_repo.dart';
import 'package:office/ui/profile/menus/warning_details.dart';
import 'package:provider/provider.dart';

class Warning extends StatefulWidget {
  const Warning({Key? key}) : super(key: key);

  @override
  State<Warning> createState() => _WarningState();
}

class _WarningState extends State<Warning> {
  late ProfileBloc bloc;
  @override
  void initState() {
    bloc = ProfileBloc(context.read<ProfileRepository>());
    super.initState();
    bloc.fetchUserWarnings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [

            ValueListenableBuilder(
                valueListenable: bloc.isWarningsLoad,
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
                        left: 20, right: 20, top: 0, bottom: 10),
                    child: ValueListenableBuilder(
                        valueListenable: bloc.userWarnings,
                        builder: (context, List<WarningModel>? warning, __) {
                          if (warning == null) {
                            return const Center(
                              child: Text("User Details Not Found!"),
                            );
                          }
                          return ListView.builder(
                              physics:const ScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: warning.length,
                              itemBuilder: (context, index) {
                                WarningModel data = warning[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                        builder: (context) =>
                                            Provider.value(
                                              value: bloc,
                                              child:  WarningDetails(data: data),
                                            ),

                                    )
                                    );
                                  },
                                  child: Container(
                                    width: 1.sw,
                                    padding:const EdgeInsets.only(top: 5 ,left: 10,right: 10,bottom: 10),
                                    margin:const EdgeInsets.only(bottom: 20),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                              spreadRadius: 1,
                                              blurRadius: 3,
                                              color: Colors.grey.withOpacity(0.3)
                                          )
                                        ],
                                      // border: Border.all(color: Colors.black),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top: 5),
                                              child: Text(
                                                warning[index].title ?? "",
                                                style: const TextStyle(
                                                    color: Colors.red,
                                                    fontWeight:
                                                        FontWeight.w600,
                                                    fontSize: 17,
                                                    fontFamily: "Poppins"),
                                              ),
                                            ),
                                            const Spacer(),
                                            Text(
                                              DateFormat.yMMMMd().format(
                                                  DateTime.parse(warning[index]
                                                      .updatedAt
                                                      .toString() ??
                                                      "")),
                                              // "${document[index].name}",
                                              style:  TextStyle(
                                                  color: Colors.black.withOpacity(0.7),
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 10,
                                                  fontFamily: "Poppins"),
                                            ),
                                          ],
                                        ),
                                        // const SizedBox(height: 5,),
                                        if(warning[index].firstName!=null)Row(
                                          children: [
                                            const Icon(PhosphorIcons.user,color: Colors.black,size: 12,),
                                            Text("${warning[index].firstName ?? ""} ${warning[index].middleName ?? ""} ${warning[index].lastName ?? ""}",style: const TextStyle(color: Colors.black,fontSize: 11,fontWeight: FontWeight.w500),)
                                          ],
                                        ),
                                        const SizedBox(height: 5,),
                                        if(warning[index].description!=null) Align(
                                          alignment: Alignment.centerLeft,
                                          child: Html(
                                            data: warning[index].description ?? "",
                                            style: {
                                              "body": Style(
                                                color: Colors.black.withOpacity(0.7),
                                                //fontWeight:
                                                // FontWeight.w600,
                                                fontFamily: "Poppins",
                                                display: Display.inline,
                                                fontSize: FontSize(13),),
                                              "p": Style(
                                                color: Colors.black.withOpacity(0.7),
                                                padding: HtmlPaddings.zero,
                                                margin: Margins.zero,
                                                //fontWeight:
                                                // FontWeight.w600,
                                                fontFamily: "Poppins",
                                                display: Display.inline,
                                                fontSize: FontSize(13),),
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                        }),
                  );
                })
          ],
        ),
      ),
    );
  }
}
