import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:office/bloc/profile_bloc.dart';
import 'package:office/data/model/community_list.dart';
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
  // List<int> _data = List.generate(10, (index) => index); // Initial data

  bool _isFirstLoadRunning = false;
  bool _hasNextPage = true;

  bool _isLoadMoreRunning = false;

  late PostBloc bloc;
  @override
  void initState() {
    // TODO: implement initState
    bloc = PostBloc(context.read<PostRepository>(), context.read<CommunityRepositary>()  );
    super.initState();
    bloc.fetchPostData();
    _scrollController.addListener(_loadMoreData);
    bloc.deleteStream.stream.listen((event) {
      if (event == 'Post') {
      setState(() {
      });
      }
    });
  }
  @override
  void dispose() {
    _scrollController.dispose();
    bloc.postStream.close();
    super.dispose();
  }

  void _loadMoreData() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // User has reached the end of the list
      // Load more data or trigger pagination in flutter
      // setState(() {
      //   _data.addAll(List.generate(10, (index) => _data.length + index));
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      displacement: 100,
      backgroundColor: Colors.white,
      color: K.themeColorPrimary,
      strokeWidth: 3,
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      onRefresh: () async {
        bloc.fetchPostData();
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
                            value: bloc,
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
                  valueListenable: bloc.isUserDetailLoad,
                  builder: (BuildContext context,bool isLoading,Widget? child){
                  if(isLoading){
                  return const Center(
                  child: CircularProgressIndicator(),
                 );
                }
                return ValueListenableBuilder(
                    valueListenable: bloc.feedbackData,
                    builder: (BuildContext context,feedbackData,Widget? child){
                      if(feedbackData == null){
                        return const Center(
                          child: Text("No post available"),
                        );
                      }
                      return Container(
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          children: [
                            feedbackData.isEmpty?
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
                                  itemCount: feedbackData.length,
                                  itemBuilder: (context, index){
                                    Community data  = feedbackData[index];
                                    return PostData(bloc : bloc,data: data);
                                  }),
                            ),
                            // SizedBox(height: 120,)
                          ],
                        ),
                      );
                    });
                  }
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

class PostData extends StatefulWidget {
  final PostBloc bloc;
  final Community data;

  const PostData({super.key,required this.data, required this.bloc});

  @override
  State<PostData> createState() => _PostDataState();
}

class _PostDataState extends State<PostData> {

  @override
  Widget build(BuildContext context) {
    ValueNotifier<bool> isLike = ValueNotifier(false);
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
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CommunityProfile(userid: widget.data.userId.toInt(),)));
                },
                child:  CircleAvatar(
                  backgroundImage: widget.data.userDetails!.image!=null?NetworkImage('https://freeze.talocare.co.in/public/${widget.data.userDetails!.image}'):null,
                  child:widget.data.userDetails!.image==null? Icon(Icons.person):null,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${widget.data.userDetails!.name}",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),maxLines: 1,
                  ),
                  Text(
                    DateFormat.yMMMd().format(DateTime.parse(widget.data.dateTime!.split(" ").first)),
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
                            var result= widget.bloc.DeletePost(widget.data.postId!);
                            if(result !=null){
                              print(result.toString());
                              widget.bloc.feedbackData.value!.remove(widget.data);
                            }
                          },
                          icons: [
                            Icon(PhosphorIcons.flag),
                            Icon(PhosphorIcons.prohibit),
                            Icon(Icons.cancel_outlined),
                            Icon(PhosphorIcons.share),
                            prefs.getString('uid')==widget.data.userId?Icon(Icons.delete):Icon(Icons.border_all,color: Colors.white,)
                          ],
                          items: [
                            'Report',
                            "Don't recommend Post",
                            'Not interested',
                            'Share',
                            prefs.getString('uid')==widget.data.userId?'Delete':''
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
              text:widget.data.text,
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
                  .push(MaterialPageRoute(builder: (context) => PostDetail(data: widget.data)));
            },
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
              ),
              child:Container(
                height: 200,
                child: Image.network(
                  "https://freeze.talocare.co.in/${widget.data.image}",
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
                        :null,
                        strokeWidth: 2,
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
          LikeShareComment(data: widget.data,bloc: widget.bloc)
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

  }
}
