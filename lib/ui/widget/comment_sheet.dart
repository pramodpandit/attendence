import 'package:flutter/material.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:office/ui/community/communityProfile.dart';
import 'package:office/utils/message_handler.dart';

import '../../bloc/post_bloc.dart';

class CommentSheet extends StatefulWidget {
  final BuildContext ctx;
  final int postid;

  final PostBloc bloc;

  const CommentSheet({Key? key, required this.ctx,  required this.bloc, required this.postid}) : super(key: key);

  @override
  State<CommentSheet> createState() => _CommentSheetState();
}

class _CommentSheetState extends State<CommentSheet> {
  TextEditingController comment = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(widget.ctx).padding.top,
        bottom: MediaQuery.of(widget.ctx).viewInsets.bottom,
      ),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.75,
        minChildSize: 0.75,
        maxChildSize: 0.9, //0.9,
        snap: true,
        builder: (context, scrollController) {
          return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                ),
                child: Stack(
                  children: [
                    ValueListenableBuilder(
                      valueListenable: widget.bloc.isLoadingcomment,
                      builder: (context, loading, child) {
                        if(loading ==true){
                          return Center(child:CircularProgressIndicator(),);
                        }
                       return  ValueListenableBuilder(
                           valueListenable: widget.bloc.postCommentAllUserList,
                           builder: (context, postcomment, child) {
                             if (postcomment == null) {
                               return  Center(
                                   child: CircularProgressIndicator());
                             }else if ( postcomment!.isEmpty) {
                               return Center(child: Text('No comment found !',style: TextStyle(fontWeight: FontWeight.w500),),);
                             }else{
                               return Container(
                                 padding: EdgeInsets.only(),
                                 // margin: MediaQuery.of(context).viewInsets,
                                 clipBehavior: Clip.hardEdge,
                                 decoration: const BoxDecoration(
                                   borderRadius:
                                   BorderRadius.vertical(top: Radius.circular(
                                       15.0)),
                                 ),
                                 child: CustomScrollView(
                                   controller: scrollController,
                                   slivers: [
                                     SliverAppBar(
                                       automaticallyImplyLeading: true,
                                       title: Row(
                                         mainAxisSize: MainAxisSize.min,
                                         children: [
                                           const Icon(
                                             PhosphorIcons.chat_circle_dots,
                                           ),
                                           const SizedBox(width: 10),
                                           Text(
                                             "Comments (${postcomment!.length})",
                                             style: TextStyle(
                                               fontWeight: FontWeight.bold,
                                               fontSize: 16.sp,
                                             ),
                                           ),
                                         ],
                                       ),
                                       centerTitle: true,
                                       titleSpacing: 20.w,
                                       pinned: true,
                                     ),
                                     SliverPadding(
                                         padding: EdgeInsets.symmetric(
                                             horizontal: 20.w, vertical: 10.h),
                                         sliver: SliverList(
                                           delegate: SliverChildBuilderDelegate(
                                                   (context, i) {
                                                 return PostCommentView(
                                                   data: postcomment[i],);
                                               },
                                               childCount: postcomment!.length
                                           ),
                                         )),
                                     SliverToBoxAdapter(
                                         child: SizedBox(height: 60.h)),
                                   ],
                                 ),
                               );
                             }
                           }
                       );
                        },
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20)),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                spreadRadius: 0,
                                blurRadius: 3,
                                color: Colors.black.withOpacity(0.2),
                              )
                            ]),
                        padding: const EdgeInsets.only(
                            bottom: 10, top: 10, left: 10, right: 10),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              child: Icon(Icons.person),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: TextFormField(
                                textCapitalization: TextCapitalization.sentences,
                                controller: comment,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Add a comment",
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            InkWell(
                                onTap: (){
                                  if(comment.text ==''){
                                    widget.bloc.showMessage(MessageType.info('Please enter comment '));
                                  }else{
                                    widget.bloc.commentPost(widget.postid.toString(), comment.text).then((value) {
                                      if(value ==true){
                                        widget.bloc.postCommentAllUserList.value = null;
                                        widget.bloc.getCommentPostUserDetails(widget.postid.toString());

                                        FocusScope.of(context).requestFocus(FocusNode());
                                        comment.text = '';
                                        widget.bloc.fetchPostData();
                                      }
                                    });
                                  }
                                },
                                child: const Icon(PhosphorIcons.paper_plane_tilt)),
                                const SizedBox(
                                  width: 10,
                                ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },

      )
    );
  }
}

class PostCommentView extends StatefulWidget {
  final  data;
  const PostCommentView({Key? key, required this.data}) : super(key: key);

  @override
  State<PostCommentView> createState() => _PostCommentViewState();
}

class _PostCommentViewState extends State<PostCommentView> {
 
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CommunityProfile(userid: widget.data['user_id'],)));
            },
            child: ClipOval(
              child: Image.network(
                "https://freeze.talocare.co.in/public/${widget.data['user_details']['image']}",
                loadingBuilder: (context, child, loadingProgress) {
                  if(loadingProgress == null){
                    return child;
                  }
                  return CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes!=null?
                    loadingProgress.cumulativeBytesLoaded/
                        loadingProgress.expectedTotalBytes!:
                    null,
                    strokeWidth: 2,
                  );
                },
                height: 35.r,
                width: 35.r,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => CircleAvatar(
                  radius: 17.5.r,
                  backgroundColor: Colors.grey[200],
                  child: const Icon(
                    PhosphorIcons.user,
                    size: 20,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(10))
                        .copyWith(topRight: const Radius.circular(10)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Text(
                          "${widget.data['user_details']['name']}",
                          style: TextStyle(
                            fontSize: 12.sp,
                            height: 1,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        DateFormat('MMM d,yyyy').format(DateTime.parse(widget.data['created_at'])),
                        style: TextStyle(
                            fontSize: 12.sp,
                            color: const Color(0xff828080),
                            height: 1),
                      )
                    ],
                  ),
                  const SizedBox(height: 5),
                 Text(
                   '${widget.data['comment']}',
                    style: TextStyle(
                      height: 1.2,
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

