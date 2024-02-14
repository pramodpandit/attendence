import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:intl/intl.dart';
import 'package:office/ui/credentials/credential_details.dart';
import 'package:office/utils/constants.dart';

class CredentialList extends StatefulWidget {
  const CredentialList({Key? key}) : super(key: key);

  @override
  State<CredentialList> createState() => _CredentialListState();
}

class _CredentialListState extends State<CredentialList> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      displacement: 200,
      backgroundColor: Colors.white,
      color: K.themeColorPrimary,
      strokeWidth: 3,
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      onRefresh: () async {
        await Future.delayed(Duration(milliseconds: 1500));
      },
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                Image.asset("images/back.png",fit: BoxFit.cover,height: 220,width: double.infinity,),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60,),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        PhosphorIcons.caret_left_bold,
                        color: Colors.black,
                      )),
                ),
                const SizedBox(height: 10,),
                const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    "Credentials",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        letterSpacing: 0.5,
                        color: Colors.black),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: ListView.builder(
                      physics: const ScrollPhysics(),
                      itemCount: 6,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const CredentialDetails()));
                          },
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
                      }),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
