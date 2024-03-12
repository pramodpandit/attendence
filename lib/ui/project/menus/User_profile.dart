import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../bloc/profile_bloc.dart';
import '../../../bloc/project_bloc.dart';
import '../../../data/repository/profile_repo.dart';
import '../../../data/repository/project_repo.dart';
import '../../chat/chatScreen.dart';
import '../../profile/menus/basic_info.dart';

class UserProfile extends StatefulWidget {
  final String userid;
  const UserProfile({Key? key, required this.userid}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  late ProjectBloc bloc;
  late ProfileBloc profileBloc;


  List<Widget> menusWidgets = [

  ];
  List<String> menuItems =[
    // "My Timeline",
    "Profile Info",
    "About",
  ];
  ValueNotifier<int> selectedMenuIndex = ValueNotifier(0);
  selectMenu(int index) {
    selectedMenuIndex.value = index;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    profileBloc=ProfileBloc(context.read<ProfileRepository>());
    sharedPref();
     menusWidgets = [
      // ListView.builder(
      //   itemCount: 7,
      //   physics: ScrollPhysics(),
      //   // shrinkWrap: true,
      //   itemBuilder: (context, index) {
      //     return PostList();
      //   },
      // ),
      ProfileInfo(userid: widget.userid),
       AboutInfo(userid: widget.userid),
     ];
    bloc = ProjectBloc(context.read<ProjectRepository>());
    bloc.fetchUserDetail(int.parse(widget.userid));
  }
  late SharedPreferences prefs;
  void sharedPref()async{
    prefs = await SharedPreferences.getInstance();
  }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: bloc.userDetail,
        builder: (context, userdata, child) {
          if(userdata ==null){
            return SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: Center(child: CircularProgressIndicator()));
          }
          if(userdata.isEmpty){
            return SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: Center(child: Text("No data available")));
          }
          return Column(
            children: [
              Stack(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Container(
                    height: 190,
                    width: 1.sw,
                    decoration: const BoxDecoration(
                        color: Color(0xFF009FE3),
                        borderRadius:
                        BorderRadius.only(bottomLeft: Radius.circular(30))),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 56,
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 130,
                        ),
                        Container(
                          height: 130,
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
                              SizedBox(
                                height: 40.h,
                              ),
                               Text(
                                "${userdata['Name']??''}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              Text(
                                "${userdata['designationname']??''}",
                                textAlign: TextAlign.center,
                                style:
                                TextStyle(color: Colors.black87, fontSize: 12),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                               Text(
                                "Employee Id: ${userdata['employee_code']}",
                                textAlign: TextAlign.center,
                                style:
                                TextStyle(color: Colors.black54, fontSize: 12),
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
                        const SizedBox(
                          height: 100,
                        ),
                        CircleAvatar(
                          radius: 33,
                          backgroundColor: Colors.white,
                          child: SizedBox(
                            height: 60,
                            width: 60,
                            child: GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                      child: Container(
                                        height: height / 2.5,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            image: DecorationImage(
                                                image: NetworkImage(userdata['image']==null? 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_640.png':
                                                    "https://freeze.talocare.co.in/public/${userdata['image']}"),
                                                fit: BoxFit.cover)),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: ClipOval(
                                child: Image.network(userdata['image']==null?'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_640.png':
                                  "https://freeze.talocare.co.in/public/${userdata['image']}",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  prefs.getString('uid').toString() == userdata['user_id'].toString()?Offstage():
                  Positioned(
                      right: 25,
                      top: 60,
                      child: InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatScreen(user: userdata, bloc: profileBloc, prefs: prefs,)));
                          },
                          child: Icon(Icons.chat,color: Colors.white,size: 25,))),
                  Positioned(
                    top: 56,
                    left: 10,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 18,
                        child: Icon(
                          Icons.arrow_back,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 55,
                padding: const EdgeInsets.only(top: 18),
                child: ValueListenableBuilder(
                    valueListenable: selectedMenuIndex,
                    builder: (context, int menuindex, _) {
                      return ListView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          scrollDirection: Axis.horizontal,
                          itemCount: menuItems.length,
                          itemBuilder: (context, index) {
                            return Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    selectMenu(index);
                                    // userDetailsNotifier.selectMenu(index);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10.0),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: selectedMenuIndex.value == index
                                            ? const Color(0xFF009FE3)
                                            : Colors.grey.shade300,
                                        borderRadius: BorderRadius.circular(30.0)),
                                    child: Text(
                                      menuItems[index],
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: "Poppins",
                                          color: selectedMenuIndex.value == index
                                              ? Colors.white
                                              : Colors.black),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                )
                              ],
                            );
                          });
                    }),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: selectedMenuIndex,
                  builder: (BuildContext context, int index, Widget? child) {
                    return menusWidgets[index];
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
class ProfileInfo extends StatefulWidget {
  final String userid;
  const ProfileInfo({super.key, required this.userid});

  @override
  State<ProfileInfo> createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> {
  late ProjectBloc bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc = ProjectBloc(context.read<ProjectRepository>());
    bloc.fetchUserDetail(int.parse(widget.userid));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: bloc.userDetail,
        builder: (context, userdata, child) {
          if(userdata ==null){
            return SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: Center(child: CircularProgressIndicator()));
          }
          if(userdata.isEmpty){
            return SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: Center(child: Text("No data available")));
          }
          return Padding(
            padding: const EdgeInsets.only(right: 15,left: 15),
            child: SingleChildScrollView(
              child: Column(
                children: [
                SizedBox(height: 10,),
                  DetailsContainer(
                    title: userdata['gender'],
                    heading: 'Gender', isHtml: false,
                  ),
                  Dash(
                    dashColor: Colors.grey.withOpacity(0.3),
                    dashGap: 3,
                    length: 340.w,
                  ),
                  const SizedBox(height: 10,),
                  DetailsContainer(
                    title: userdata['join_date'],
                    heading: 'Joining Date', isHtml: false,
                  ),
                  Dash(
                    dashColor: Colors.grey.withOpacity(0.3),
                    dashGap: 3,
                    length: 340.w,
                  ),
                  const SizedBox(height: 10,),
                  DetailsContainer(
                    title: userdata['date_of_birth'],
                    heading: 'Date Of Birth', isHtml: false,
                  ),
                  Dash(
                    dashColor: Colors.grey.withOpacity(0.3),
                    dashGap: 3,
                    length: 340.w,
                  ),
                  const SizedBox(height: 10,),
                  DetailsContainer(
                    title: userdata['current_address'],
                    heading: 'Current Address', isHtml: true,
                  ),
                  Dash(
                    dashColor: Colors.grey.withOpacity(0.3),
                    dashGap: 3,
                    length: 340.w,
                  ),
                  const SizedBox(height: 10,),
                  DetailsContainer(
                    title: userdata['permanent_address'],
                    heading: 'Permanent Address', isHtml: true,
                  ),
                  Dash(
                    dashColor: Colors.grey.withOpacity(0.3),
                    dashGap: 3,
                    length: 340.w,
                  ),
                  const SizedBox(height: 10,),
                  DetailsContainer(
                    title: userdata['designationname'],
                    heading: 'Designation', isHtml: false,
                  ),
                  Dash(
                    dashColor: Colors.grey.withOpacity(0.3),
                    dashGap: 3,
                    length: 340.w,
                  ),
                  const SizedBox(height: 10,),
                  DetailsContainer(
                    title: userdata['departmentname'],
                    heading: 'Department', isHtml: false,
                  ),
                  Dash(
                    dashColor: Colors.grey.withOpacity(0.3),
                    dashGap: 3,
                    length: 340.w,
                  ),
                  const SizedBox(height: 10,),
                  DetailsContainer(
                    title: userdata['skillName'],
                    heading: 'Skills', isHtml: false,
                  ),
                  Dash(
                    dashColor: Colors.grey.withOpacity(0.3),
                    dashGap: 3,
                    length: 340.w,
                  ),
                  const SizedBox(height: 10,),
                  DetailsContainer(
                    title: userdata['Qualification']??'',
                    heading: 'Qualification', isHtml: false,
                  ),
                  Dash(
                    dashColor: Colors.grey.withOpacity(0.3),
                    dashGap: 3,
                    length: 340.w,
                  ),
                  const SizedBox(height: 10,),
                  DetailsContainer(
                    title: userdata['employee_status']??'',
                    heading: 'Type', isHtml: false,
                  ),
                  Dash(
                    dashColor: Colors.grey.withOpacity(0.3),
                    dashGap: 3,
                    length: 340.w,
                  ),
                  const SizedBox(height: 10,),
                  DetailsContainer(
                    title: userdata['shift_title']??'',
                    heading: 'Time Slot', isHtml: false,
                  ),
                  Dash(
                    dashColor: Colors.grey.withOpacity(0.3),
                    dashGap: 3,
                    length: 340.w,
                  ),
                  const SizedBox(height: 10,),
                  DetailsContainer(
                    title: userdata['marital_status']??'',
                    heading: 'Marital Status', isHtml: false,
                  ),
                  Dash(
                    dashColor: Colors.grey.withOpacity(0.3),
                    dashGap: 3,
                    length: 340.w,
                  ),
                  const SizedBox(height: 10,),
                  DetailsContainer(
                    title: userdata['work_type']??'',
                    heading: 'Employment Type', isHtml: false,
                  ),
                  Dash(
                    dashColor: Colors.grey.withOpacity(0.3),
                    dashGap: 3,
                    length: 340.w,
                  ),
                  const SizedBox(height: 10,),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class AboutInfo extends StatefulWidget {
  final String userid;
  const AboutInfo({super.key, required this.userid});

  @override
  State<AboutInfo> createState() => _AboutInfoState();
}

class _AboutInfoState extends State<AboutInfo> {
  late ProjectBloc bloc;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc = ProjectBloc(context.read<ProjectRepository>());
    bloc.fetchUserDetail(int.parse(widget.userid));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: bloc.userDetail,
        builder: (context, userdata, child) {
          if(userdata ==null){
            return SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: Center(child: CircularProgressIndicator()));
          }
          if(userdata.isEmpty){
            return SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: Center(child: Text("No data available")));
          }
          return Padding(
            padding: const EdgeInsets.only(right: 15,left: 15),
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('About',style: TextStyle(fontWeight: FontWeight.w700),),
                Html(data: userdata['about_us']??''),
                // DetailsContainer(
                //   title: userdata['about_us'],
                //   heading: 'About', isHtml: true,
                // ),
              ],
            )
          );
        },
      ),
    );
  }
}



