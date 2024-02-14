import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final  String content;
  final double size;
  final FontWeight weight;
  final Color color;
  const TextWidget({Key? key,required this.content,required this.size,required this.color,required this.weight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text("$content",
    style: TextStyle(
      color: color,
      fontSize: size,
      fontFamily: "Poppins",
      fontWeight: weight
    ),);
  }
}