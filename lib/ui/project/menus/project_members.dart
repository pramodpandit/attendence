import 'package:flutter/material.dart';
import 'package:office/ui/community/communityProfile.dart';
import 'package:office/ui/profile/profileScreen.dart';

class ProjectMembers extends StatefulWidget {
  const ProjectMembers({Key? key}) : super(key: key);

  @override
  State<ProjectMembers> createState() => _ProjectMembersState();
}

class _ProjectMembersState extends State<ProjectMembers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15,vertical:0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Team Leader",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black),
                  ),
                  ListView.builder(
                    itemCount: 1,
                    padding: const EdgeInsets.only(top: 10),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const CommunityProfile()));
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          child: const Row(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                child: Icon(Icons.person),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Alex Smith",
                                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const Text(
                    "Team Members",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black),
                  ),
                  ListView.builder(
                    itemCount: 3,
                    padding: const EdgeInsets.only(top: 10),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const CommunityProfile()));
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          child: const Row(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                child: Icon(Icons.person),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Alex Smith",
                                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
