import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:office/bloc/policy_bloc.dart';
import 'package:office/data/model/policy_model.dart';
import 'package:office/data/repository/profile_repo.dart';
import 'package:provider/provider.dart';

class Policy extends StatefulWidget {
  const Policy({Key? key}) : super(key: key);

  @override
  State<Policy> createState() => _PolicyState();
}

class _PolicyState extends State<Policy> {
  late PolicyBloc bloc;
  @override
  void initState() {
    bloc = PolicyBloc(context.read<ProfileRepository>());
    super.initState();
    bloc.fetchUserPolicy();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     "Policy",
      //   ),
      // ),
      body: Stack(
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
                  "Policy",
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
          Column(
            children: [
              const SizedBox(height: 100,),
              Expanded(
                child: ValueListenableBuilder(
                    valueListenable: bloc.isPolicyLoad,
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
                      return ValueListenableBuilder(
                          valueListenable: bloc.policy,
                          builder: (context, List<PolicyModel>? policy, __) {
                            if (policy == null) {
                              return const Center(
                                child: Text("User Details Not Found!"),
                              );
                            }
                            return Column(
                              children: [
                                Container(
                                  height: 55,
                                  padding: const EdgeInsets.only(top: 18),
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      scrollDirection: Axis.horizontal,
                                      itemCount: policy.length,
                                      itemBuilder: (context, index) {
                                        return Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                bloc.selectMenu(index);
                                              },
                                              child: ValueListenableBuilder(
                                                  valueListenable:
                                                      bloc.selectedMenuIndex,
                                                  builder: (context, snapshot, __) {
                                                    return Container(
                                                      padding: const EdgeInsets.all(
                                                          10.0),
                                                      alignment: Alignment.center,
                                                      decoration: BoxDecoration(
                                                          color:
                                                              bloc.selectedMenuIndex
                                                                          .value ==
                                                                      index
                                                                  ? const Color(
                                                                      0xFF009FE3)
                                                                  : const Color(
                                                                      0xffd1cdcd),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  10.0)),
                                                      child: Text(
                                                        "${policy[index].title}",
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontFamily: "Poppins",
                                                            color:
                                                                bloc.selectedMenuIndex
                                                                            .value ==
                                                                        index
                                                                    ? Colors.white
                                                                    : Colors.black),
                                                      ),
                                                    );
                                                  }),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            )
                                          ],
                                        );
                                      }),
                                ),
                                Expanded(
                                  child: Container(
                                    width: 1.sw,
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 10),
                                    child: ValueListenableBuilder(
                                        valueListenable: bloc.selectedMenuIndex,
                                        builder: (context, int index, __) {
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 1.sw,
                                                alignment: Alignment.center,
                                                padding: const EdgeInsets.symmetric(
                                                    vertical: 10),
                                                decoration: const BoxDecoration(
                                                    color: Color(0xFF009FE3)),
                                                child: Text(
                                                  "${policy[index].title}",
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      fontFamily: "Poppins",
                                                      fontWeight: FontWeight.w600,
                                                      color: Colors.white),
                                                ),
                                              ),
                                              Expanded(
                                                // height: MediaQuery.of(context).size.width * 1.5,
                                                child: SingleChildScrollView(
                                                  physics: const ScrollPhysics(),
                                                  child: Container(
                                                    // color: Colors.black,
                                                    padding: const EdgeInsets.only(
                                                        left: 20,
                                                        right: 20,
                                                        top: 30,
                                                        bottom: 10),
                                                    child: Html(
                                                      // data:"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                                                      data:
                                                          "${policy[index].description}",
                                                      style: {
                                                        "body": Style(
                                                            color: Colors.black,
                                                            //fontWeight:
                                                            // FontWeight.w600,
                                                            fontFamily: "Poppins",
                                                            display: Display.inline,
                                                            fontSize: FontSize(14),
                                                            textAlign:
                                                                TextAlign.start),
                                                        "p": Style(
                                                            color: Colors.black,
                                                            //fontWeight:
                                                            // FontWeight.w600,
                                                            // padding:
                                                            //     EdgeInsets.zero,
                                                            fontFamily: "Poppins",
                                                            display: Display.inline,
                                                            fontSize: FontSize(14),
                                                            textAlign:
                                                                TextAlign.start),
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        }),
                                  ),
                                )
                              ],
                            );
                          });
                    }),
              ),
            ],
          )
        ],
      ),
    );
  }
}
