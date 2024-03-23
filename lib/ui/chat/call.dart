import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import '../../bloc/profile_bloc.dart';
import '../../data/repository/profile_repo.dart';

class CallPage extends StatefulWidget {
  final String type;
  final String? callId;
  final Map<String,dynamic>? user;
  const CallPage({Key? key, this.user, this.callId, required this.type}) : super(key: key);
  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  late ProfileBloc profileBloc;
  String? callId;
  String userId = DateTime.now().millisecondsSinceEpoch.toString();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    profileBloc = ProfileBloc(context.read<ProfileRepository>());
    if(widget.user != null){
      callId = DateTime.now().millisecondsSinceEpoch.toString();
      profileBloc.sendCallNotification(widget.user!,widget.type,callId!);
    }
    else{
      callId = widget.callId;
    }
 }
 @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      appID: 414043237, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
      appSign: 'ca80a415440612ae706f13661f48eb56d30cb3cbd58b0c7c3d55f967093dd102', // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
      userID: userId,
      userName: "user$userId",
      callID: callId!,
      config: widget.type == "videocall" ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall() : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall(),
      onDispose: () {
        Navigator.pop(context);
      },
    );
  }
}