import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:office/bloc/profile_bloc.dart';
import 'package:office/data/repository/profile_repo.dart';
import 'package:office/ui/profile/menus/basic_info.dart';
import 'package:provider/provider.dart';
import '../../../data/model/user.dart';

class OfficialDetails extends StatefulWidget {
  const OfficialDetails({Key? key}) : super(key: key);

  @override
  State<OfficialDetails> createState() => _OfficialDetailsState();
}

class _OfficialDetailsState extends State<OfficialDetails> {
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
                              child: Text("User Details Not Found!"),
                            );
                          }
                          return Column(
                            children: [
                              DetailsContainer(
                                isHtml: false,
                                title: user.employeeCode ?? "---",
                                // title: "${details["employee_code"]!=null?details["employee_code"]:""}",
                                heading: 'Employee Code',
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
                                title: user.email ?? "---",
                                // title: "${details["designation"]!=null?details["designation"]:""}",
                                heading: 'Email id',
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
                                title: user.designationname ?? "---",
                                // title: "${details["department"]!=null?details["department"]:""}",
                                heading: 'Designation',
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
                                  title: user.designationname ?? "---",
                                  // title: '${details["business_title"]!=null?details["business_title"]:""}',
                                  heading: "Department"),
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
                                title: user.joinDate ?? "---",
                                // title: "${details["office_email_id"]!=null?details["office_email_id"]:""}",
                                heading: 'Joining Date',
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
                                title: "${user.reportFirst ?? ""} ${user.reportMiddle ?? ""} ${user.reportLast ?? ""} ",
                                // title: "${details["skillName"]!=null?details["skillName"]:""}",
                                heading: 'Report To',
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
                                  title: user.skillName ?? "---",
                                  // title: '${details["work_type"]!=null?details["work_type"]:""}',
                                  heading: "Skills"),
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
                                  title: "${user.startTime?.substring(0,5)??"---"} to ${user.endTime?.substring(0,5)??"---"}",
                                  // title: '${details["shift_title"]!=null?details["shift_title"]:"--"}',
                                  heading: "Working Hour"),
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
                                  title: user.teamName ?? "---",
                                  // title: '${details["join_date"]!=null?details["join_date"]:""}',
                                  heading: "Team"),
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
                                  title: user.workType ?? "---",
                                  // title: '${details["join_date"]!=null?details["join_date"]:""}',
                                  heading: "Employee Type"),
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
                                  title: "${user.businessTitle}" ?? "---",
                                  // title: '${details["join_date"]!=null?details["join_date"]:""}',
                                  heading: "Branch"),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          );
                        }),
                  );
                })
          ],
        ),
      ),
    );
  }
}
