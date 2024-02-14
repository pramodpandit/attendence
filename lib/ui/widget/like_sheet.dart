import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:office/ui/community/communityProfile.dart';

class LikeSheet extends StatefulWidget {
  final BuildContext ctx;
  const LikeSheet({super.key, required this.ctx});

  @override
  State<LikeSheet> createState() => _LikeSheetState();
}

class _LikeSheetState extends State<LikeSheet> {
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
                              PhosphorIcons.heart,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "Likes (1.1K)",
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
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                  ),
                                  margin: const EdgeInsets.only(bottom: 20),
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CommunityProfile()));
                                        },
                                        child: CircleAvatar(
                                          child: Icon(Icons.person),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "User name",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                      // Spacer(),
                                      // GestureDetector(
                                      //   onTap: () {
                                      //     Navigator.of(context).push(
                                      //         MaterialPageRoute(
                                      //             builder: (context) =>
                                      //                 CommunityProfile()));
                                      //   },
                                      //   child: Container(
                                      //     padding: EdgeInsets.symmetric(
                                      //         horizontal: 10, vertical: 5),
                                      //     decoration: BoxDecoration(
                                      //       borderRadius:
                                      //           BorderRadius.circular(5),
                                      //       color: Colors.blue,
                                      //     ),
                                      //     child: Text(
                                      //       "View Profile",
                                      //       style:
                                      //           TextStyle(color: Colors.white),
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                );
                              },
                              childCount: 3,
                            ),
                          )),
                      SliverToBoxAdapter(child: SizedBox(height: 60.h)),
                    ],
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
