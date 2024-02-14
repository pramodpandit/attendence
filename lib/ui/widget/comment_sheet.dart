import 'package:flutter/material.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:office/ui/community/communityProfile.dart';

class CommentSheet extends StatefulWidget {
  final BuildContext ctx;
  const CommentSheet({Key? key, required this.ctx}) : super(key: key);

  @override
  State<CommentSheet> createState() => _CommentSheetState();
}

class _CommentSheetState extends State<CommentSheet> {
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
                Container(
                  padding: EdgeInsets.only(top: 10.h),
                  // margin: MediaQuery.of(context).viewInsets,
                  clipBehavior: Clip.hardEdge,
                  decoration: const BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(15.0)),
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
                              "Comments (59)",
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
                                return const PostCommentView();
                              },
                              childCount: 3,
                            ),
                          )),
                      SliverToBoxAdapter(child: SizedBox(height: 60.h)),
                    ],
                  ),
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
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Add a comment",
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Icon(PhosphorIcons.paper_plane_tilt),
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
      ),
    );
  }
}

class PostCommentView extends StatefulWidget {
  const PostCommentView({Key? key}) : super(key: key);

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
                  MaterialPageRoute(builder: (context) => CommunityProfile()));
            },
            child: ClipOval(
              child: Image.network(
                "https://images.wallpaperscraft.com/image/single/laptop_keys_gradient_167934_1920x1080.jpg",
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
                          "Alex Smith",
                          style: TextStyle(
                            fontSize: 12.sp,
                            height: 1,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'april 24,2000',
                        style: TextStyle(
                            fontSize: 12.sp,
                            color: const Color(0xff828080),
                            height: 1),
                      )
                    ],
                  ),
                  const SizedBox(height: 5),
                  const TextCommentView(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class TextCommentView extends StatelessWidget {
  const TextCommentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      "Hello this is an example of the ParsedText, links like http://www.google.com or http://www.facebook.com are clickable and phone number 444-555-6666 can call too. But you can also do more with this package, for example Bob will change style and David too. foo@gmail.com And the magic number is 42! #react #react-native",
      style: TextStyle(
        height: 1.2,
        fontSize: 13.sp,
      ),
    );
  }
}
