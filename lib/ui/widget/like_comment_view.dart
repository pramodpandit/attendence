import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:office/ui/widget/comment_sheet.dart';
import 'package:office/ui/widget/like_sheet.dart';

import '../../data/model/community_list.dart';

class LikeShareComment extends StatefulWidget {
  final Data data;

  const LikeShareComment({super.key, required this.data});

  @override
  State<LikeShareComment> createState() => _LikeShareCommentState();
}

class _LikeShareCommentState extends State<LikeShareComment> {
 var valueLike = 0;

  @override
  Widget build(BuildContext context) {
    ValueNotifier<bool> isLike = ValueNotifier(false);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          children: [
            ValueListenableBuilder(
              valueListenable: isLike,
              builder: (BuildContext context, bool liked, Widget? child) {
                return GestureDetector(
                  onTap: () {
                    isLike.value = !isLike.value;
                  },
                  child: Icon(
                    liked ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red,
                    size: 18,
                  ),
                );
              },
            ),
            5.width,
            GestureDetector(
              onTap: () {
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
                    return LikeSheet(ctx: context);
                  },
                );
              },
              child: Text(
                "${widget.data.totalLike! }",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        const SizedBox(
          width: 15,
        ),
        GestureDetector(
          onTap: () {
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
                return CommentSheet(ctx: context);
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
               Text(
                "${widget.data.totalComments}",
                style: TextStyle(fontWeight: FontWeight.w600),
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
