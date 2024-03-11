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

 @override
  void initState() {
    // TODO: implement initState
    super.initState();

    widget.bloc.getLikedPostUserDetails(widget.data.postId.toString());
    shared();
      }
  shared()async{
   pref = await SharedPreferences.getInstance();
  }
  
  @override
  Widget build(BuildContext context) {
    ValueNotifier<int?> totalLike = ValueNotifier(widget.data.totalLike);
    ValueNotifier<int?> totalcomment = ValueNotifier(widget.data.totalComments);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                widget.bloc.liked.value = !widget.bloc.liked.value!;
                widget.bloc.likePost(widget.data.postId.toString(),widget.bloc.liked.value! ? "1": "0");
                totalLike.value = widget.bloc.liked.value!? totalLike.value!+1 :totalLike.value!-1;
              },
              child: ValueListenableBuilder(
                valueListenable: widget.bloc.liked,
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
            GestureDetector(
              onTap: () {
                widget.bloc.postLikedAllUserList.value = null;
                widget.bloc.getLikedPostUserDetails(widget.data.postId.toString());
                if(widget.bloc.postLikedAllUserList.value != null){
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
                      return LikeSheet(ctx: context,users: widget.bloc.postLikedAllUserList.value!);
                    },
                  );
                }
              },
              child: ValueListenableBuilder(
                valueListenable: totalLike,
                builder: (context, totalLike, child) {
                return Text(
                  "${totalLike}",
                  style: TextStyle(fontWeight: FontWeight.w600),
                );
              },),
            ),
          ],
        ),
        const SizedBox(
          width: 15,
        ),
        GestureDetector(
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
