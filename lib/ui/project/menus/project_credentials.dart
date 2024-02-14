import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:intl/intl.dart';

class ProjectCredentialList extends StatefulWidget {
  const ProjectCredentialList({Key? key}) : super(key: key);

  @override
  State<ProjectCredentialList> createState() => _ProjectCredentialListState();
}

class _ProjectCredentialListState extends State<ProjectCredentialList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 6,
                padding: EdgeInsets.only(top: 10),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 3,
                                spreadRadius: 2)
                          ],
                          color: Colors.white,
                          borderRadius:
                          const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Flexible(
                                  child: Text(
                                    "Created By:Rajan Sir",
                                    style: const TextStyle(
                                        color: Colors.black54, fontSize: 10),
                                  ),
                                )
                              ],
                            ),
                            Text(
                              "Development",
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              DateFormat.yMMMMd().format(DateTime.now()),
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                  color: Colors.black54, fontSize: 8),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipi.Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipi. Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipi.Neque porro quisquam.",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Poppins",
                                  fontSize: 11),
                            ),
                            const SizedBox(
                              height: 15,
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
