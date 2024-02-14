import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:office/bloc/profile_bloc.dart';
import 'package:office/data/model/user.dart';
import 'package:office/data/repository/profile_repo.dart';
import 'package:provider/provider.dart';

class BasicInfoScreen extends StatefulWidget {
  const BasicInfoScreen({Key? key}) : super(key: key);

  @override
  State<BasicInfoScreen> createState() => _BasicInfoScreenState();
}

class _BasicInfoScreenState extends State<BasicInfoScreen> {
  late ProfileBloc bloc;
  @override
  void initState() {
    bloc = ProfileBloc(context.read<ProfileRepository>());
    super.initState();
    bloc.fetchUserDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Container(
            //   width: 1.sw,
            //   alignment: Alignment.center,
            //   padding: const EdgeInsets.symmetric(vertical: 10),
            //   decoration: const BoxDecoration(color: Color(0xFF253772)),
            //   child: const Text(
            //     "Basic Info",
            //     style: TextStyle(
            //         fontSize: 14,
            //         fontFamily: "Poppins",
            //         fontWeight: FontWeight.w600,
            //         color: Colors.white),
            //   ),
            // ),
            ValueListenableBuilder(
                valueListenable: bloc.isUserDetailLoad,
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
                        left: 25, right: 25, top: 30, bottom: 10),
                    child: ValueListenableBuilder(
                        valueListenable: bloc.userDetail,
                        builder: (context, User? user, __) {
                          if (user == null) {
                            return const Center(
                              child: Text("User Not Found!"),
                            );
                          }
                          return Column(
                            children: [
                              DetailsContainer(
                                title: user.name ?? "---",
                                //"${details["first_name"]!=null?details["first_name"]:""} ${details["middle_name"]!=null?details["middle_name"]:""} ${details["last_name"]!=null?details["last_name"]:""}",
                                heading: 'Name', isHtml: false,
                              ),
                              Dash(
                                dashColor: Colors.grey.withOpacity(0.3),
                                dashGap: 3,
                                length: 320.w,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              DetailsContainer(
                                title: user.email ?? "---",
                                // title: "${details["email"]!=null?details["email"]:""}",
                                heading: 'Email', isHtml: false,
                              ),
                              Dash(
                                dashColor: Colors.grey.withOpacity(0.3),
                                dashGap: 3,
                                length: 320.w,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              DetailsContainer(
                                  isHtml: false,
                                title: user.mobile ?? "---",
                                // title: "${details["mobile"]!=null?details["mobile"]:""}",
                                heading: 'Mobile No (Primary)',
                              ),
                              Dash(
                                dashColor: Colors.grey.withOpacity(0.3),
                                dashGap: 3,
                                length: 320.w,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              DetailsContainer(
                                isHtml: false,
                                title: user.alternateMobileNo ?? "---",
                                // title: "${details["mobile"]!=null?details["mobile"]:""}",
                                heading: 'Mobile No (Secondary)',
                              ),
                              Dash(
                                dashColor: Colors.grey.withOpacity(0.3),
                                dashGap: 3,
                                length: 320.w,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              DetailsContainer(
                                  isHtml: true,
                                  title: user.currentAddress ?? "---",
                                  // title: '${details["current_address"]!=null?details["current_address"]:""}',
                                  heading: "Current Address"),
                              Dash(
                                dashColor: Colors.grey.withOpacity(0.3),
                                dashGap: 3,
                                length: 320.w,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              DetailsContainer(
                                  isHtml: true,
                                  title: user.permanentAddress ?? "---",
                                  // title: '${details["permanent_address"]!=null?details["permanent_address"]:""}',
                                  heading: "Permanent Address"),
                              Dash(
                                dashColor: Colors.grey.withOpacity(0.3),
                                dashGap: 3,
                                length: 320.w,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              DetailsContainer(
                                  isHtml: false,
                                  title: user.gender ?? "---",
                                  // title: '${details["gender"]!=null?details["gender"]:""}',
                                  heading: "Gender"),
                              Dash(
                                dashColor: Colors.grey.withOpacity(0.3),
                                dashGap: 3,
                                length: 320.w,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              DetailsContainer(
                                  isHtml: false,
                                  title: user.dateOfBirth ?? "---",
                                  // title: '${details["date_of_birth"]!=null?details["date_of_birth"]:""}',
                                  heading: "Date Of Birth"),
                              Dash(
                                dashColor: Colors.grey.withOpacity(0.3),
                                dashGap: 3,
                                length: 320.w,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              DetailsContainer(
                                  isHtml: false,
                                  title: user.maritalStatus ?? "---",
                                  // title: '${details["marital_status"]!=null?details["marital_status"]:""}',
                                  heading: "Marital Status"),
                              Dash(
                                dashColor: Colors.grey.withOpacity(0.3),
                                dashGap: 3,
                                length: 320.w,
                              ),
                              if (user.maritalStatus == "Married")
                                const SizedBox(
                                  height: 10,
                                ),
                              if (user.maritalStatus == "Married")
                                DetailsContainer(
                                    isHtml: false,
                                    title: user.marriageNniversary ?? "---",
                                    heading: "Marriage Anniversary"),
                              if (user.maritalStatus == "Married")
                              Dash(
                                dashColor: Colors.grey.withOpacity(0.3),
                                dashGap: 3,
                                length: 320.w,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              DetailsContainer(
                                  isHtml: false,
                                  title: user.bloodGroup ?? "---",
                                  // title: '${details["date_of_birth"]!=null?details["date_of_birth"]:""}',
                                  heading: "Blood Group"),
                              Dash(
                                dashColor: Colors.grey.withOpacity(0.3),
                                dashGap: 3,
                                length: 320.w,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              DetailsContainer(
                                  isHtml: false,
                                  title: user.aadharCard ?? "---",
                                  // title: '${details["date_of_birth"]!=null?details["date_of_birth"]:""}',
                                  heading: "Aadhar Number"),
                              Dash(
                                dashColor: Colors.grey.withOpacity(0.3),
                                dashGap: 3,
                                length: 320.w,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              DetailsContainer(
                                  title: user.aboutUs ?? "---",
                                  // title: '${details["about_us"]!=null?details["about_us"]:""}',
                                  heading: "About Us", isHtml: true,),
                              SizedBox(height: 10,),
                            ],
                          );
                        }),
                  );
                }),
          ],
        ),
      ),
    );
  }
}

class DetailsContainer extends StatelessWidget {
  final String? title;
  final String? heading;
  final bool isHtml;

  const DetailsContainer({
    Key? key,
    @required this.title,
    required this.isHtml,
    @required this.heading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 10,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$heading ",
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
              color: Colors.black,
            ),
          ),
          SizedBox(width: 20,),
          isHtml ?
        // Container(
        //   width: 1.sw,
        //   //height: 0.08.sh,
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(5),
        //     //color: Color(0xFFeceef9).withOpacity(0.3),
        //   ),
        //   /* padding: EdgeInsets.only(
        //         left: 10,
        //       ),*/
        //   child: Padding(
        //     padding: const EdgeInsets.only(right: 8, top: 3, bottom: 8),
        //     child:
              Flexible(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Html(
                    data: title,
                    style: {
                      "body": Style(
                          color: Colors.black,
                          //fontWeight:
                          // FontWeight.w600,
                          fontFamily: "Poppins",
                          display: Display.inline,
                          fontSize: FontSize(14),),
                      "p": Style(
                          color: Colors.black,
                          padding: HtmlPaddings.zero,
                          margin: Margins.zero,
                          //fontWeight:
                          // FontWeight.w600,
                          fontFamily: "Poppins",
                          display: Display.inline,
                          fontSize: FontSize(14),),
                    },
                  ),
                ),
              )
            // )))
          :
            Flexible(
              child: Text(
                title!,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 14,
                  // fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  color: Colors.black,
                ),
              ),
            ),
                ],
              ),
            );
  }
}
