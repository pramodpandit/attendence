import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../bloc/post_bloc.dart';
import '../../data/repository/community.dart';
import '../../data/repository/post_repo.dart';

class MoreSheet extends StatefulWidget {
  final BuildContext ctx;
  final List<String> items;
  final List<Widget> icons;
  final VoidCallback deleteOnTap;
  //final ScrollController _scrollController = ScrollController();

  MoreSheet(
      {super.key, required this.ctx, required this.items, required this.icons,required this.deleteOnTap});

  @override
  State<MoreSheet> createState() => _MoreSheetState();
}

class _MoreSheetState extends State<MoreSheet> {
  late PostBloc bloc;
  @override
  void initState() {
    // TODO: implement initState
    bloc = PostBloc(context.read<PostRepository>(), context.read<CommunityRepositary>()  );
    super.initState();
    bloc.fetchPostData();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(widget.ctx).padding.top,
        bottom: MediaQuery.of(widget.ctx).viewInsets.bottom,
      ),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: (widget.items.length * 0.11) + 0.15,
        minChildSize: 0.10,
        // maxChildSize: 1, //0.9,
        snap: true,
        builder: (context, scrollController) {
          //_scrollController.physics =  NeverScrollableScrollPhysics();
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            ),
            child: Stack(
              children: [
                Container(
                  //padding: EdgeInsets.only(top: 10.h),
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
                        title: Text(
                          "Options",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          ),
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
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                  ),
                                  margin: EdgeInsets.only(bottom: 20),
                                  child: Row(
                                    children: [
                                      widget.icons[i],
                                      SizedBox(
                                        width: 10,
                                      ),
                                      widget.items[i] == 'Share'
                                          ? InkWell(
                                              onTap: () {
                                                //Link share of post:::::::::::::::::::::::::::::::::::::::::::
                                                Share.share(
                                                    'check out my dummy post link https://google.com');
                                              },
                                              child: Text(
                                                widget.items[i],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14),
                                              ),
                                            ):widget.items[i] == 'Delete'?InkWell(onTap: widget.deleteOnTap,child:  Text(
                                                widget.items[i],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14),
                                              ),)
                                          : Text(
                                              widget.items[i],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14),
                                            ),
                                    ],
                                  ),
                                );
                              },
                              childCount: widget.items.length,
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
