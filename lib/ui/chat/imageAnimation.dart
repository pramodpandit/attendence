import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatImageAnimation extends StatelessWidget {
  final String img;
  final String tag;
  const ChatImageAnimation({super.key, required this.img, required this.tag});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Container(
                child: Hero(
                    tag: tag,
                    child: Image.network(img,fit: BoxFit.cover,))),
          ),
          Positioned(
            top: 56,
            left: 10,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.grey,blurRadius: 1)
                    ]
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.arrow_back,
                    size: 18,
                  ),
                ),
              ),
            ),
          ),
        ],

      ),
    );
  }
}
