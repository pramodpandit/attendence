import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExpenseDetails extends StatefulWidget {
  final expensedata;
  const ExpenseDetails({Key? key, this.expensedata}) : super(key: key);

  @override
  State<ExpenseDetails> createState() => _ExpenseDetailsState();
}

class _ExpenseDetailsState extends State<ExpenseDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                        "Expense",
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     Expanded(
                        child: Text(
                          "${widget.expensedata['description']}",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 15),
                        ),
                      ),
                      Container(
                        padding:  EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration:  BoxDecoration(
                          color: widget.expensedata['paid'].toString()== "yes"?Color(0xFF3CEB43):Color(0xFFD41817),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child:  Text(
                        widget.expensedata['paid'].toString()== "yes"?"Approved":"Rejected",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "₹${widget.expensedata['amount']}",
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
               //    const SizedBox(
               //      height: 10,
               //    ),
               // Text(
               //      widget.expensedata['description'],
               //      textAlign: TextAlign.left,
               //      style: const TextStyle(
               //          color: Colors.black54,
               //          fontWeight: FontWeight.w500,
               //          fontFamily: "Poppins",
               //          fontSize: 12),
               //    ),
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
