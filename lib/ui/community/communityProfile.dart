import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:office/data/repository/project_repo.dart';
import 'package:office/ui/community/postDetail.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../bloc/post_bloc.dart';
import '../../bloc/profile_bloc.dart';
import '../../bloc/project_bloc.dart';
import '../../data/repository/community.dart';
import '../../data/repository/post_repo.dart';
import '../../data/repository/profile_repo.dart';
import '../chat/chatScreen.dart';
import '../project/menus/User_profile.dart';
import '../widget/like_comment_view.dart';
import '../widget/more_sheet.dart';

class CommunityProfile extends StatefulWidget {
  final int userid;
  const CommunityProfile({Key? key, required this.userid}) : super(key: key);

  @override
  State<CommunityProfile> createState() => _CommunityProfileState();
}

class _CommunityProfileState extends State<CommunityProfile> {
  late ProjectBloc bloc;
  late ProfileBloc profileBloc;
  List<Widget> menusWidgets = [
  ];
  List<String> menuItems = [
    "My Timeline",
    "Documents",
    "other",
  ];
  ValueNotifier<int> selectedMenuIndex = ValueNotifier(0);
  selectMenu(int index) {
    selectedMenuIndex.value = index;
  }
  late SharedPreferences prefs;
  void sharedPref()async{
    prefs = await SharedPreferences.getInstance();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    profileBloc=ProfileBloc(context.read<ProfileRepository>());
    menusWidgets = [
      PostData(id: widget.userid.toInt()),
      ProfileInfo(userid: widget.userid.toString()),
      AboutInfo(userid: widget.userid.toString()),
    ];
    bloc = ProjectBloc(context.read<ProjectRepository>());
    bloc.fetchUserDetail(int.parse(widget.userid.toString()));
    sharedPref();
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

class PostData extends StatefulWidget {
  final int id;

  const PostData({super.key, required this.id});

  @override
  State<PostData> createState() => _PostDataState();
}

class _PostDataState extends State<PostData> {
  late PostBloc bloc;
  @override
  void initState() {
    // TODO: implement initState
    bloc = PostBloc(context.read<PostRepository>(), context.read<CommunityRepositary>()  );
    super.initState();
    bloc.deleteStream.stream.listen((event) {
      if (event == 'Post') {
        setState(() {
        });}});
    bloc.fetchPost(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    ValueNotifier<bool> isLike = ValueNotifier(false);
    return  ValueListenableBuilder(
        valueListenable: bloc.isUserDetailLoad,
        builder: (BuildContext context,bool isLoading,Widget? child){
          if(isLoading){
            return const Center(
              //child: CircularProgressIndicator(),
            );
          }
          return ValueListenableBuilder(
            valueListenable: bloc.userPost,
            builder: (context, PostData, child) {
              if(PostData ==null){
                return CircularProgressIndicator();
              }
              if(PostData.isEmpty){
                return Center(child: Text('Post not found'));
              }
              return Container(
                height: MediaQuery.of(context).size.height *0.9,
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount:PostData.length,
                    itemBuilder: (context, index){
                      var data  = PostData[index];
                      var date = data.dateTime!.split(' ');
                      var date1 = date[0];
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        margin: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                spreadRadius: 0,
                                blurRadius: 3,
                                color: Colors.black.withOpacity(0.2),
                              ),
                            ]),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {},
                                  child:  CircleAvatar(
                                    backgroundImage: data.userDetails!.image!=null?NetworkImage('https://freeze.talocare.co.in/public/${data.userDetails!.image}'):null,
                                    child:data.userDetails!.image==null? Icon(Icons.person):null,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${data.userDetails!.name}",
                                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),maxLines: 1,
                                    ),
                                    Text(
                                      DateFormat.yMMMd().format(DateTime.parse(date1)),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          color: Colors.grey),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                GestureDetector(
                                  onTap: () async{
                                    final SharedPreferences prefs =await SharedPreferences.getInstance();
                                    showModalBottomSheet(
                                      context: context,
                                      isDismissible: true,
                                      // isScrollControlled: false,
                                      //backgroundColor: Colors.white,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20),
                                        ),
                                      ),
                                      // clipBehavior: Clip.antiAliasWithSaveLayer,
                                      builder: (BuildContext context) {
                                        return Container(
                                          // padding: EdgeInsets.only(top: 150),
                                          child: MoreSheet(
                                            ctx: context,
                                            deleteOnTap: () {
                                              Navigator.pop(context);
                                              var result= bloc.DeletePost(data.postId!);
                                              if(result !=null){
                                                print(result.toString());
                                                bloc.feedbackData.value!.remove(data);
                                              }
                                            },
                                            icons: [
                                              Icon(PhosphorIcons.flag),
                                              Icon(PhosphorIcons.prohibit),
                                              Icon(Icons.cancel_outlined),
                                              Icon(PhosphorIcons.share),
                                              prefs.getString('uid')==data.userId?Icon(Icons.delete):Icon(Icons.border_all,color: Colors.white,)
                                            ],
                                            items: [
                                              'Report',
                                              "Don't recommend Post",
                                              'Not interested',
                                              'Share',
                                              prefs.getString('uid')==data.userId?'Delete':''
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Icon(
                                    Icons.more_horiz,
                                    color: Colors.grey,
                                  ),
                                ),
                                // Expanded(
                                //   child: DropdownButtonFormField(
                                //     // underline: const SizedBox(),
                                //     icon: const Icon(
                                //       Icons.more_horiz,
                                //       color: Colors.grey,
                                //     ),
                                //     items: items.map((String items) {
                                //       return DropdownMenuItem(
                                //         value: items,
                                //         child: Text(""),
                                //       );
                                //     }).toList(),
                                //     onChanged: (String? newValue) {},
                                //   ),
                                // ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            //text Post
                            RichText(
                              text: TextSpan(
                                text:data.text,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    height: 1.3,
                                    color: Color.fromRGBO(74, 74, 74, 1)),
                              ),
                              textAlign: TextAlign.start,
                              maxLines: 4,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(height: 200,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(builder: (context) => PostDetail(data: data,)));
                                },
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(30),
                                    bottomLeft: Radius.circular(30),
                                  ),
                                  child:data.image ==null?Container(height: 0,width: 0,):Image.network(
                                    "https://freeze.talocare.co.in/${data.image}",
                                    width: double.infinity,
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if(loadingProgress == null){
                                        return child;
                                      }
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress.expectedTotalBytes == null?
                                          loadingProgress.cumulativeBytesLoaded
                                              /loadingProgress.expectedTotalBytes!
                                              :null
                                          ,
                                        ),
                                      );
                                    },
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            LikeShareComment(data: data,bloc: bloc)
                            // Row(
                            //   children: [
                            //     ValueListenableBuilder(
                            //       valueListenable: isLike,
                            //       builder: (BuildContext context, bool liked, Widget? child) {
                            //         return GestureDetector(
                            //           onTap: () {
                            //             isLike.value = !isLike.value;
                            //           },
                            //           child: Icon(
                            //             liked ? Icons.favorite : Icons.favorite_border,
                            //             color: Colors.red,
                            //             size: 18,
                            //           ),
                            //         );
                            //       },
                            //     ),
                            //     const SizedBox(
                            //       width: 5,
                            //     ),
                            //     GestureDetector(
                            //       onTap: () {
                            //         showModalBottomSheet(
                            //           context: context,
                            //           isScrollControlled: true,
                            //           shape: const RoundedRectangleBorder(
                            //             borderRadius: BorderRadius.vertical(
                            //               top: Radius.circular(20),
                            //             ),
                            //           ),
                            //           clipBehavior: Clip.antiAliasWithSaveLayer,
                            //           builder: (BuildContext context) {
                            //             return LikeSheet(ctx: context);
                            //           },
                            //         );
                            //       },
                            //       child: const Text(
                            //         "1.1K",
                            //         style: TextStyle(fontWeight: FontWeight.w600),
                            //       ),
                            //     ),
                            //     const SizedBox(
                            //       width: 15,
                            //     ),
                            //     GestureDetector(
                            //       onTap: () {
                            //         showModalBottomSheet(
                            //           context: context,
                            //           isScrollControlled: true,
                            //           shape: const RoundedRectangleBorder(
                            //             borderRadius: BorderRadius.vertical(
                            //               top: Radius.circular(20),
                            //             ),
                            //           ),
                            //           clipBehavior: Clip.antiAliasWithSaveLayer,
                            //           builder: (BuildContext context) {
                            //             return CommentSheet(ctx: context);
                            //           },
                            //         );
                            //       },
                            //       child: Row(
                            //         children: [
                            //           Icon(
                            //             Icons.comment,
                            //             color: Colors.yellow.shade700,
                            //             size: 18,
                            //           ),
                            //           const SizedBox(
                            //             width: 5,
                            //           ),
                            //           const Text(
                            //             "59 comments",
                            //             style: TextStyle(fontWeight: FontWeight.w600),
                            //           ),
                            //         ],
                            //       ),
                            //     ),
                            //     const SizedBox(
                            //       width: 15,
                            //     ),
                            //     const Icon(
                            //       Icons.remove_red_eye,
                            //       color: Colors.black,
                            //       size: 18,
                            //     ),
                            //     const SizedBox(
                            //       width: 5,
                            //     ),
                            //     const Text(
                            //       "33,456",
                            //       style: TextStyle(fontWeight: FontWeight.w600),
                            //     ),
                            //     // Spacer(),
                            //     // Container(
                            //     //   padding: EdgeInsets.symmetric(horizontal: 8,vertical: 5),
                            //     //   decoration: BoxDecoration(
                            //     //     borderRadius: BorderRadius.only(
                            //     //       topRight: Radius.circular(10),
                            //     //       bottomLeft: Radius.circular(10),
                            //     //     ),
                            //     //     color: Colors.blue,
                            //     //   ),
                            //     //   child: Text("View Post",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500),),
                            //     // ),
                            //   ],
                            // ),
                          ],
                        ),
                      );
                    }),
              );
            },

          );
        });

  }
}
