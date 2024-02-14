import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

class ProjectComments extends StatefulWidget {
  const ProjectComments({Key? key}) : super(key: key);

  @override
  State<ProjectComments> createState() => _ProjectCommentsState();
}

class _ProjectCommentsState extends State<ProjectComments> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 15,right: 20),
              child: ListView.builder(
                itemCount: 15,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: 40,
            width: 110,
            child: FloatingActionButton.extended(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0))
                ),
                onPressed: () async{
                },
                backgroundColor: const  Color(0xFF009FE3),
                label: AnimatedSwitcher(
                  duration: const Duration(seconds: 1),
                  transitionBuilder: (Widget child, Animation<double> animation) =>
                      FadeTransition(
                        opacity: animation,
                        child: SizeTransition(
                          sizeFactor: animation,
                          axis: Axis.horizontal,
                          child: child,
                        ),
                      ),
                  child: const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 5.0),
                        child: Icon(
                          PhosphorIcons.plus_circle_fill,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Comment",
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                )),
          ),
          SizedBox(height: 30,)
        ],
      ),
    );
  }
}
