import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

class ExpenseDetails extends StatefulWidget {
  const ExpenseDetails({Key? key}) : super(key: key);

  @override
  State<ExpenseDetails> createState() => _ExpenseDetailsState();
}

class _ExpenseDetailsState extends State<ExpenseDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              PhosphorIcons.caret_left_bold,
              color: Colors.black,
            )),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Expense",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        letterSpacing: 0.5,
                        color: Colors.black),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(
                        child: Text(
                          "Mobile App Design",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 15),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: const BoxDecoration(
                          color: Color(0xFF3CEB43),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: const Text(
                          "Approved",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    "₹15000",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipi.Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipi. Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipi.Neque porro quisquam. Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipi.Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipi. Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipi.Neque porro quisquam.Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipi.Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipi. Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipi.Neque porro quisquam. Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipi.Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipi. Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipi.Neque porro quisquam. Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipi.Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipi. Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipi.Neque porro quisquam.Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, ",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Poppins",
                        fontSize: 12),
                  ),
                  const SizedBox(
                    height: 20,
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
