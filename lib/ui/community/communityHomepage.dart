import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:office/data/repository/post_repo.dart';
import 'package:office/ui/community/addPost.dart';
import 'package:office/ui/community/communityProfile.dart';
import 'package:office/ui/community/postDetail.dart';
import 'package:office/ui/widget/like_comment_view.dart';
import 'package:office/ui/widget/more_sheet.dart';
import 'package:office/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../bloc/post_bloc.dart';
import '../../data/repository/community.dart';

class CommunityHomePage extends StatefulWidget {
  const CommunityHomePage({Key? key}) : super(key: key);

  @override
  State<CommunityHomePage> createState() => _CommunityHomePageState();
}

class _CommunityHomePageState extends State<CommunityHomePage> {
  ScrollController _scrollController = ScrollController();
  List<int> _data = List.generate(10, (index) => index); // Initial data

  bool _isFirstLoadRunning = false;
  bool _hasNextPage = true;

  bool _isLoadMoreRunning = false;

  late PostBloc block;
  @override
  void initState() {
    // TODO: implement initState
    block = PostBloc(context.read<PostRepository>(), context.read<CommunityRepositary>()  );
    super.initState();
    block.fetchPostData();
    _scrollController.addListener(_loadMoreData);
    block.fetchPostData();
    block.deleteStream.stream.listen((event) {
      if (event == 'Post') {
      setState(() {
      });
      }
    });
  }
  @override
  void dispose() {
    _scrollController.dispose();
    block.postStream.close();
    super.dispose();
  }

  void _loadMoreData() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // User has reached the end of the list
      // Load more data or trigger pagination in flutter
      setState(() {
        _data.addAll(List.generate(10, (index) => _data.length + index));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      displacement: 200,
      backgroundColor: Colors.white,
      color: K.themeColorPrimary,
      strokeWidth: 3,
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      onRefresh: () async {
        await Future.delayed(Duration(milliseconds: 1500));
      },
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 60,
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  const Text(
                    "Community",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  // Text(
                  //   "Check your Community",
                  //   style: TextStyle(
                  //     fontSize: 16,
                  //     fontWeight: FontWeight.w400,
                  //     color: Colors.grey,
                  //   ),
                  // ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () async{
                      var result =await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => Provider.value(
                            value: block,
                            child: const AddPost(),
                          ),
                        ),
                      );
                      if (result == "refresh") {
                      }

                      //block.fetchPostData();

                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      margin: const EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.blue,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.add_circle,
                            color: Colors.blue,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Post",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ValueListenableBuilder(
                  valueListenable: block.isUserDetailLoad,
                  builder: (BuildContext context,bool isLoading,Widget? child){
                  if(isLoading){
                  return const Center(
                  child: CircularProgressIndicator(),
                  );
                  }
                return ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.only(top: 10),
                  itemCount: _data.length,
                  itemBuilder: (context, index) {
                    return const PostList();
                  },
                );}
              ),
            ),
            const SizedBox(
              height: 70,
            ),
          ],
        ),
      ),
    );
  }
}

class PostList extends StatefulWidget {

  const PostList({super.key});

  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  late PostBloc block;
  @override
  void initState() {
    // TODO: implement initState
    block = PostBloc(context.read<PostRepository>(), context.read<CommunityRepositary>()  );
    super.initState();
    block.deleteStream.stream.listen((event) {
      if (event == 'Post') {
        setState(() {
        });
      }
    });

    block.fetchPostData();
  }

  @override
  Widget build(BuildContext context) {
    ValueNotifier<bool> isLike = ValueNotifier(false);
    return  ValueListenableBuilder(
        valueListenable: block.isUserDetailLoad,
        builder: (BuildContext context,bool isLoading,Widget? child){
          if(isLoading){
            return const Center(
              //child: CircularProgressIndicator(),
            );
          }
          return Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                block.feedbackData.isEmpty?
                    Column(
                      children: [
                        200.height,
                        Text("No posts yet"),
                      ],
                    ):
                Expanded(
                  child:
                  ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: block.feedbackData.length,
                      itemBuilder: (context, index){
                        var data  = block.feedbackData[index];
                        var date = data.dateTime!.split(' ');
                        var date1 = date[0] ;
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          margin: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
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
                                    onTap: () {
                                      Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) => const CommunityProfile()));
                                    },
                                    child: const CircleAvatar(
                                      child: Icon(Icons.person),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Jhon Smith",
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
                                            padding: EdgeInsets.only(top: 150),
                                            child: MoreSheet(
                                              ctx: context,
                                              deleteOnTap: () {
                                                Navigator.pop(context);
                                                var result= block.DeletePost(data.postId!);
                                                if(result !=null){
                                                  print(result.toString());
                                                  block.feedbackData.remove(data);
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
                              GestureDetector(
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
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              LikeShareComment(data: data,)
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
                ),
                SizedBox(height: 120,)
              ],
            ),
          );
        });

  }
}
