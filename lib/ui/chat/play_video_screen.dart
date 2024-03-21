import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:video_player/video_player.dart';

class PlayVideoScreen extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final String animationTag;
  const PlayVideoScreen({super.key, required this.videoPlayerController, required this.animationTag});

  @override
  State<PlayVideoScreen> createState() => _PlayVideoScreenState();
}

class _PlayVideoScreenState extends State<PlayVideoScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.videoPlayerController.play();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    widget.videoPlayerController.pause();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Hero(
            tag: widget.animationTag,
            child: Material(
              child: Center(
                child: AspectRatio(
                  aspectRatio: widget.videoPlayerController.value.aspectRatio,
                  child: VideoPlayer(widget.videoPlayerController).onTap((){
                    widget.videoPlayerController.value.isPlaying?widget.videoPlayerController.pause():widget.videoPlayerController.play();
                  }),
                ),
              ),
            ),
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
