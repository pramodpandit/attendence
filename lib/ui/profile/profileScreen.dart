import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:office/bloc/profile_bloc.dart';
import 'package:office/data/repository/profile_repo.dart';
import 'package:office/ui/attendance/attendanceScreen.dart';
import 'package:office/ui/auth/loginScreen.dart';
import 'package:office/ui/chat/contacts.dart';
import 'package:office/ui/complaints/complaintsListScreen.dart';
import 'package:office/ui/complaints/ownComplainList.dart';
import 'package:office/ui/credentials/credential_list.dart';
import 'package:office/ui/events/eventsScreen.dart';
import 'package:office/ui/expense/expense_list.dart';
import 'package:office/ui/feedback/employee_feedback.dart';
import 'package:office/ui/feedback/feedbackList.dart';
import 'package:office/ui/holiday/holidayScreen.dart';
import 'package:office/ui/leads/lead_list.dart';
import 'package:office/ui/leads/leads_list_page.dart';
import 'package:office/ui/leave/leaves_homepage.dart';
import 'package:office/ui/leave/leaves_page.dart';
import 'package:office/ui/notes/notes_list.dart';
import 'package:office/ui/notice_board/noticeBoardScreen.dart';
import 'package:office/ui/policies/policy.dart';
import 'package:office/ui/profile/profile_screen.dart';
import 'package:office/ui/project/projectScreen.dart';
import 'package:office/ui/task/task_screen.dart';
import 'package:office/ui/water/add_water.dart';
import 'package:office/ui/work_from_home/workFromHomePage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Settings/setting.dart';
import '../bill/add_bill.dart';
import '../leave/employee_leave.dart';
import '../leave/leave_request/leave_page_hr.dart';
import '../payroll/sallary.dart';
import '../work_form_home_request/work_from_home_request.dart';
import '../work_from_home/work_from_home_more_details.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ProfileBloc bloc;
  @override
  void initState() {
    bloc = ProfileBloc(context.read<ProfileRepository>());
    super.initState();
    bloc.fetchUserDetail();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: bloc.isUserDetailLoad,
        builder: (context, bool loading, __) {
          if (loading == true) {
            return Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.width * 1,
                ),
                const Center(child: CircularProgressIndicator()),
              ],
            );
          }
          return  ValueListenableBuilder(
              valueListenable: bloc.userDetail,
              builder: (context, user, _) {

                if (user == null) {
                  return Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 1,
                      ),
                      const Center(
                        child: Text("User Details Not Found!"),
                      ),
                    ],
                  );
                }
                var department =
                    user!.departmentaccess;
              return Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 190,
                        width: 1.sw,
                        decoration: const BoxDecoration(
                            color: Color(0xFF009FE3),
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(30))),
                        child:  Column(
                          children: [
                            SizedBox(
                              height: 56,
                            ),
                            Text(
                              "Profile",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 135,
                            ),
                            Container(
                              height: 120,
                              width: 0.9.sw,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      blurRadius: 3,
                                      spreadRadius: 2)
                                ],
                                color: Colors.white,
                                borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  Text(
                                    user?.name ?? "",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    user.designationname ?? "",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: Colors.black87, fontSize: 12),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Employee Id:${user?.employeeCode ?? ""}",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: Colors.black54, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Column(
                          children: [
                            const SizedBox(height: 100),
                            CircleAvatar(
                              radius: 30,
                              child: ClipOval(
                                child: Image.network(
                                  "https://freeze.talocare.co.in/public/${user?.image}",
                                  height: 60,
                                  width: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          if (bloc.hasAccess(department, 1,'1'))BoxContainer(
                            heading: "Profile",
                            image: "images/man.png",
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const ProfilePage()));
                            },
                          ),
                          if (bloc.hasAccess(department, 2,'1'))BoxContainer(
                            heading: "Attendance",
                            image: "images/calendar.png",
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const AttendanceScreen()));
                            },
                          ),
                          if (bloc.hasAccess(department, 3,'1'))BoxContainer(
                            heading: "Leaves",
                            image: "images/calendar1.png",
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const LeavesHomePage()));
                            },
                          ),
                          if (bloc.hasAccess(department, 3,'1'))BoxContainer(
                            heading: "Leaves Request",
                            image: "images/calendar1.png",
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const LeavesRecordsPagehr()));
                            },
                          ),

                          if (bloc.hasAccess(department, 3,'1'))BoxContainer(
                            heading: "Work from home",
                            image: "images/calendar1.png",
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const WorkFromHomeMoreDetailPage()));
                            },
                          ),
                          if (bloc.hasAccess(department, 3,'1'))BoxContainer(
                            heading: "Work from home Request",
                            image: "images/calendar1.png",
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const WorkFromHomeRequest()));
                            },
                          ),
                          if (bloc.hasAccess(department, 29,'1'))BoxContainer(
                            heading: "Employee Leaves",
                            image: "images/calendar1.png",
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const EmployeeLeave()));
                            }
                          ),
                          if (bloc.hasAccess(department, 4,'1'))BoxContainer(
                            heading: "Projects",
                            image: "images/project.png",
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ProjectScreen(user: user,)));
                            },
                          ),
                          if (bloc.hasAccess(department,5,'1')) BoxContainer(
                            heading: "Leads",
                            image: "images/leads.png",
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const LeadList()));
                            //  LeadDetailPage
                            },
                          ),
                          if (bloc.hasAccess(department,5,'1')) BoxContainer(
                            heading: "Leads List Page",
                            image: "images/leads.png",
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const LeadsListPage()));
                              //  LeadDetailPage
                            },
                          ),
                          if (bloc.hasAccess(department, 6,'1'))BoxContainer(
                            heading: "Task",
                            image: "images/task.png",
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const TaskScreen()));
                            },
                          ),
                          if (bloc.hasAccess(department, 7,'1'))BoxContainer(
                            heading: "Notice Board",
                            image: "images/board.png",
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const NoticeBoardScreen()));
                            },
                          ),
                          if (bloc.hasAccess(department, 7,'1'))BoxContainer(
                            heading: "Payroll Salary",
                            image: "images/board.png",
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const sallary()));
                            },
                          ),
                          if (bloc.hasAccess(department, 8,'1'))BoxContainer(
                            heading: "Holidays",
                            image: "images/holiday.png",
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const HolidayScreen()));
                            },
                          ),
                          if (bloc.hasAccess(department,9,'1'))BoxContainer(
                            heading: "Expense",
                            image: "images/budget.png",
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const ExpenseList()));
                            },
                          ),
                          if (bloc.hasAccess(department, 10,'1'))BoxContainer(
                            heading: "Events",
                            image: "images/event.png",
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const EventScreen()));
                            },
                          ),
                          if (bloc.hasAccess(department,11,'1')) BoxContainer(
                            heading: "Team",
                            onTap: () {
                              // Navigator.of(context).push(MaterialPageRoute(
                              //     builder: (context) =>
                              //     const IntroductionPage()));
                            },
                            image: "images/team.png",
                          ),
                          if (bloc.hasAccess(department, 12,'1'))BoxContainer(
                            heading: "Notes",
                            image: "images/notes.png",
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const NotesList()));
                            },
                          ),
                          if (bloc.hasAccess(department, 13,'1'))BoxContainer(
                            heading: "Feedback",
                            image: "images/feedback.png",
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const FeedbackListScreen()));
                            },
                          ),
                          if (bloc.hasAccess(department, 28,'1'))BoxContainer(
                            heading: "Employee Feedback",
                            image: "images/feedback.png",
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const EmployeeFeedback()));
                            },
                          ),
                          if (bloc.hasAccess(department, 14,'1')) BoxContainer(
                            heading: "Setting",
                            image: "images/setting.png",
                            onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Setting()));
                            },
                          ),
                          if (bloc.hasAccess(department, 15,'1'))BoxContainer(
                            heading: "Credentials",
                            image: "images/credentials.png",
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const CredentialList()));
                            },
                          ),
                          if (bloc.hasAccess(department, 16,'1'))BoxContainer(
                            heading: "Complaints",
                            image: "images/bad.png",
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const ComplaintsListScreen()));
                            },
                          ),
                          if (bloc.hasAccess(department, 27,'1'))BoxContainer(
                            heading: "Employee Complaints",
                            image: "images/bad.png",
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const OwnComplainList()));
                            },
                          ),
                          if (bloc.hasAccess(department, 17,'1'))BoxContainer(
                            heading: "Policy",
                            image: "images/policy.png",
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const Policy()));
                            },
                          ),
                          if (bloc.hasAccess(department, 18,'1'))BoxContainer(
                            heading: "Water",
                            image: "images/notes.png",
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const AddWater()));
                            },
                          ),
                          if (bloc.hasAccess(department, 19,'1'))BoxContainer(
                            heading: "Bill",
                            image: "images/notes.png",
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const AddBill()));
                            },
                          ),
                          if (bloc.hasAccess(department, 20,'1'))BoxContainer(
                            heading: "Contacts",
                            image: "images/contacts.png",
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const ContactsScreen()));
                            },
                          ),
                          if (bloc.hasAccess(department, 24,'1'))BoxContainer(
                            heading: "Logout",
                            image: "images/logout.png",
                            onTap: () async {
                              SharedPreferences p =
                                  await SharedPreferences.getInstance();
                              p.clear();
                              FirebaseAuth.instance.signOut();
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => const LoginScreen()));
                            },
                          ),
                          const SizedBox(
                            height: 100,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          );
        });
  }
}

class BoxContainer extends StatelessWidget {
  final String? heading;
  final String? image;
  final VoidCallback? onTap;

  const BoxContainer({
    Key? key,
    @required this.heading,
    @required this.image,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20,),
        Center(
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              width: 0.9.sw,
              height: 50.h,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 3,
                      spreadRadius: 2)
                ],
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    height: 35,
                    width: 35,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.all(Radius.circular(50)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 3,
                                spreadRadius: 2),
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset(image!),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      heading!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const Icon(
                    PhosphorIcons.caret_right_bold,
                    color: Colors.black,
                    size: 20,
                  ),
                  const SizedBox(
                    width: 10,
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
