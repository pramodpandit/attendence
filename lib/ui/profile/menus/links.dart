import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:office/bloc/profile_bloc.dart';
import 'package:office/data/model/links_model.dart';
import 'package:office/data/repository/profile_repo.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/message_handler.dart';

class Links extends StatefulWidget {
  const Links({Key? key}) : super(key: key);

  @override
  State<Links> createState() => _LinksState();
}

class _LinksState extends State<Links> {
  late ProfileBloc bloc;
  @override
  void initState() {
    bloc = ProfileBloc(context.read<ProfileRepository>());
    super.initState();
    bloc.fetchLinks();
    bloc.msgController?.stream.listen((event) {
      AppMessageHandler().showSnackBar(context, event);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ValueListenableBuilder(
                valueListenable: bloc.isLinksLoad,
                builder: (context, bool loading, __) {
                  if (loading == true) {
                    return Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.5,
                        ),
                        const Center(child: CircularProgressIndicator()),
                      ],
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.only(
                        left: 25, right: 25, top: 10, bottom: 10),
                    child: ValueListenableBuilder(
                        valueListenable: bloc.userLinks,
                        builder: (context, List<LinksModel>? links, __) {
                          if (links == null) {
                            return const Center(
                              child: Text("User Details Not Found!",style: TextStyle(
                                color: Colors.black
                              ),),
                            );
                          }
                          return ListView.builder(
                              physics: const ScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: links.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  width: 1.sw,
                                  padding: const EdgeInsets.all(12),
                                  margin: const EdgeInsets.only(bottom: 20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          blurRadius: 3,
                                          spreadRadius: 1,
                                          color: Colors.grey.withOpacity(0.3))
                                    ],
                                    // border: Border.all(color: Colors.black),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            links[index].linkNameType ?? "",
                                            // "${document[index].name}",
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                                fontFamily: "Poppins"),
                                          ),
                                          const Spacer(),
                                          Text(
                                            DateFormat.yMMMMd().format(
                                                DateTime.parse(links[index]
                                                        .createdDate
                                                        .toString() ??
                                                    "")),
                                            // "${document[index].name}",
                                            style: const TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12,
                                                fontFamily: "Poppins"),
                                          ),
                                        ],
                                      ),
                                      if(links[index].otherLinkInfo!=null)const SizedBox(
                                        height: 5,
                                      ),
                                      if(links[index].otherLinkInfo!=null)Text(
                                        links[index].otherLinkInfo ?? "",
                                        //  "${document[index].other}",
                                        style: const TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 11,
                                            fontFamily: "Poppins"),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              final Uri url = Uri.parse(
                                                  '${links[index].links}');
                                              try {
                                                await launchUrl(url);
                                              } catch (e) {
                                                bloc.showMessage(MessageType.info('${links[index].links} does not exist'));
                                                // ScaffoldMessenger.of(context)
                                                //     .showSnackBar(SnackBar(
                                                //         content: Text(
                                                //             '${links[index].links} does not exist')));
                                              }
                                            },
                                            child: Container(
                                                padding: const EdgeInsets.all(6),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(100),
                                                    color: Colors.white,
                                                    boxShadow: [
                                                      BoxShadow(
                                                          spreadRadius: 0,
                                                          blurRadius: 3,
                                                          color: Colors.black
                                                              .withOpacity(0.2))
                                                    ]),
                                                child: const Icon(
                                                  PhosphorIcons.link_bold,
                                                  color: Colors.black,
                                                  size: 20,
                                                )),
                                          ),
                                          const SizedBox(width: 10,),
                                          Flexible(child: Text(links[index].links ?? "",)),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              });
                        }),
                  );
                })
          ],
        ),
      ),
    );
  }
}
