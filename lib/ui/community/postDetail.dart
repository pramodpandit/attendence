import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:intl/intl.dart';
import 'package:office/ui/community/communityProfile.dart';
import 'package:office/ui/widget/app_bar.dart';
import 'package:office/ui/widget/more_sheet.dart';
import '../../data/model/community_list.dart';

class PostDetail extends StatefulWidget {
  final Data data;
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
      appBar: MyAppBar(title: "Post Detail"),
      body: Container(
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
                          builder: (context) => const CommunityProfile()));
                    },
                    child: const CircleAvatar(
                      minRadius: 20,
                      maxRadius: 25.5,
                      child: Icon(
                        Icons.person,
                      ),
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
                            'Alex Smith',
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
          
              const SizedBox(
                height: 23,
              ),
              //Post image::
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                ),
                child:widget.data.image ==null?Container(height: 0,width: 0,) : Image.network(
                  "https://freeze.talocare.co.in/${widget.data.image}",
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.fitHeight,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              //Like,Share,Comment
             // LikeShareComment(),
              SizedBox(
                height: 10,
              ),
              //Text Post
              Text(
                '${widget.data.text}',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: Color.fromRGBO(74, 74, 74, 1)),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 20,)
            ],
          ),
        ),
      ),
    );
  }
}
