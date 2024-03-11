import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:office/ui/community/communityProfile.dart';
import 'package:office/ui/widget/app_bar.dart';
import 'package:office/ui/widget/more_sheet.dart';
import '../../data/model/community_list.dart';

class PostDetail extends StatefulWidget {
  final Community data;
  const PostDetail({super.key, required this.data});

  @override
  State<PostDetail> createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {

  @override
  Widget build(BuildContext context) {
    var date = widget.data.dateTime!.split(' ');
    var date1 = date[0] ;
    var time = date[1].split(':');
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 100,
                width: 1.sw,
                decoration: const BoxDecoration(
                    color: Color(0xFF009FE3),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20))
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 56,),
                    Text(
                      "Post Detail",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 56,
                left: 10,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 15,
                    child: Icon(Icons.arrow_back, size: 18,),
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 15),
            padding: EdgeInsets.only(left: 13, right: 13),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  //Brief of post
                  Row(
                    children: [
                      //avtar
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>CommunityProfile(userid: widget.data.userId.toInt(),)));
                        },
                        child:  CircleAvatar(
                          minRadius: 20,
                          maxRadius: 25.5,
                          backgroundImage: widget.data.userDetails!.image!=null?NetworkImage('https://freeze.talocare.co.in/public/${widget.data.userDetails!.image}'):null,
                          child: widget.data.userDetails!.image==null?Icon(
                            Icons.person,
                          ):null,
                        ),
                      ),
                      const SizedBox(
                        width: 9,
                      ),
                      //brief detail
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //uploaded by
                          Row(
                            children: [
                              // const Text(
                              //   'Uploaded By:',
                              //   style: TextStyle(
                              //       fontWeight: FontWeight.w500,
                              //       fontSize: 15,
                              //       color: Color.fromRGBO(51, 51, 51, 1)),
                              // ),
                              Text(
                                '${widget.data.userDetails!.name}',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 16),
                              )
                            ],
                          ),
                          //Uploaded Date
                          Row(
                            children: [
                              // const Text(
                              //   'Uploaded Date:',
                              //   style: TextStyle(
                              //       fontWeight: FontWeight.w500,
                              //       fontSize: 15,
                              //       color: Color.fromRGBO(51, 51, 51, 1)),
                              // ),
                              Text(
                              DateFormat.yMMMd().format(DateTime.parse(date1)),
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                '${time[0]}:${time[1]}',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 14),
                              )
                            ],
                          ),
                          //Uploaded Time
                          Row(
                            children: [
                              // const Text(
                              //   'Uploaded Time:',
                              //   style: TextStyle(
                              //       fontWeight: FontWeight.w500,
                              //       fontSize: 15,
                              //       color: Color.fromRGBO(51, 51, 51, 1)),
                              // ),
                              // Text(
                              //   '10:00 Am',
                              //   style: TextStyle(
                              //       fontWeight: FontWeight.w600, fontSize: 15),
                              // )
                            ],
                          ),
                        ],
                      ),
                      Spacer(),
                      //Option showmodalBottom-report,share..
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: false,
                            //backgroundColor: Colors.white,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            builder: (BuildContext context) {
                              return Container(
                                //padding: EdgeInsets.only(top: 300),
                                child: MoreSheet(
                                  deleteOnTap: () {

                                  },
                                  ctx: context,
                                  icons: [
                                    Icon(PhosphorIcons.flag),
                                    Icon(PhosphorIcons.prohibit),
                                    Icon(Icons.cancel_outlined),
                                    Icon(PhosphorIcons.share),
                                  ],
                                  items: [
                                    'Report',
                                    "Don't recommend Post",
                                    'Not interested',
                                    'Share',
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: const Icon(
                          Icons.more_horiz,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${widget.data.text}',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: Color.fromRGBO(74, 74, 74, 1)),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  //Post image::
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child:widget.data.image ==null?Container(height: 0,width: 0,) : Image.network(
                      "https://freeze.talocare.co.in/${widget.data.image}",
                      width: double.infinity,
                      // height: 300,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  //Like,Share,Comment
                 // LikeShareComment(),
                  SizedBox(height: 20,)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
