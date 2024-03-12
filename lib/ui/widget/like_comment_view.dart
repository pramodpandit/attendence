import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:office/bloc/post_bloc.dart';
import 'package:office/ui/widget/comment_sheet.dart';
import 'package:office/ui/widget/like_sheet.dart';

import '../../data/model/community_list.dart';

class LikeShareComment extends StatefulWidget {
  final Community data;
  final PostBloc bloc;
  const LikeShareComment({super.key, required this.data, required this.bloc});

  @override
  State<LikeShareComment> createState() => _LikeShareCommentState();
}

class _LikeShareCommentState extends State<LikeShareComment> {
 var valueLike = 0;
 late SharedPreferences pref;
 ValueNotifier<bool> liked = ValueNotifier(false);
 ValueNotifier<List?> postLikedAllUserList = ValueNotifier(null);
  ValueNotifier<int?> totalLike = ValueNotifier(0);
  ValueNotifier<int?> totalcomment = ValueNotifier(0);

 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shared();
    totalLike.value = widget.data.totalLike;
    totalcomment.value = widget.data.totalComments;
    widget.bloc.getLikedPostUserDetails(widget.data.postId.toString()).then((List result){
      postLikedAllUserList.value = result;
      liked.value = result.where((element) => element['user_id'].toString()==pref.getString("uid").toString()).toList().isNotEmpty;
    });
 }
  shared()async{
   pref = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                liked.value = !liked.value;
                widget.bloc.likePost(widget.data.postId.toString(),liked.value ? "1": "0").then((value){
                  widget.bloc.getLikedPostUserDetails(widget.data.postId.toString()).then((List result){
                    postLikedAllUserList.value = result;
                    liked.value = result.where((element) => element['user_id'].toString()==pref.getString("uid").toString()).toList().isNotEmpty;
                  });
                });
                totalLike.value = liked.value? totalLike.value!+1 :totalLike.value!-1;
              },
              child: ValueListenableBuilder(
                valueListenable: liked,
                builder: (context,bool? alreadyLiked, child) {
                  if(alreadyLiked== null){
                    return Icon(Icons.favorite_border,size: 18);
                  }
                  return Icon(
                    alreadyLiked ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red,
                    size: 18,
                  );
                },),
            ),
            5.width,
            InkWell(
              onTap: () {
                // widget.bloc.getLikedPostUserDetails(widget.data.postId.toString());
                if(postLikedAllUserList.value != null){
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    builder: (BuildContext context) {
                      return LikeSheet(ctx: context,users: postLikedAllUserList.value!);
                    },
                  );
                }
              },
              child: ValueListenableBuilder(
                valueListenable: totalLike,
                builder: (context, totalLike, child) {
                return SizedBox(
                  height: 20,
                  child: Text(
                    "${totalLike}",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                );
              },),
            ),
          ],
        ),
        const SizedBox(
          width: 15,
        ),
        InkWell(
          onTap: () {
            widget.bloc.postCommentAllUserList.value = null;
            widget.bloc.getCommentPostUserDetails(widget.data.postId.toString());
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                builder: (BuildContext context) {
                  return CommentSheet(ctx: context, bloc: widget.bloc, postid: widget.data.postId!.toInt());
                },
              );

            },
          child: Row(
            children: [
              Icon(
                Icons.comment,
                color: Colors.yellow.shade700,
                size: 18,
              ),
              const SizedBox(
                width: 5,
              ),
               ValueListenableBuilder(
                 valueListenable: totalcomment,
                 builder: (context, value, child) {
                   return  Text(
                     "${value}",
                     style: TextStyle(fontWeight: FontWeight.w600),
                   );
                 },

               ),
            ],
          ),
        ),
        // const SizedBox(
        //   width: 15,
        // ),
        // const Icon(
        //   Icons.remove_red_eye,
        //   color: Colors.black,
        //   size: 18,
        // ),
        // Text(
        //   "${widget.data.totalView}",
        //   style: TextStyle(fontWeight: FontWeight.w600),
        // ),
        // Spacer(),
        // Container(
        //   padding: EdgeInsets.symmetric(horizontal: 8,vertical: 5),
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.only(
        //       topRight: Radius.circular(10),
        //       bottomLeft: Radius.circular(10),
        //     ),
        //     color: Colors.blue,
        //   ),
        //   child: Text("View Post",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500),),
        // ),
      ],
    );
  }
}
