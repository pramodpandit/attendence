import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import '../../bloc/profile_bloc.dart';
import '../../data/repository/profile_repo.dart';

class CallPage extends StatefulWidget {
  final String type;
  final fcm;
  final username;
  final user;
  const CallPage({Key? key, this.fcm, this.username, this.user, required this.type}) : super(key: key);
  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  late ProfileBloc profileBloc;
 // late SharedPreferences  pref ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // shared();
    profileBloc = ProfileBloc(context.read<ProfileRepository>());
    profileBloc.sendCallNotification(widget.user,widget.type);
 }
 // shared()async{
 //   pref  = await SharedPreferences.getInstance();
 // }

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      appID: 414043237, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
      appSign: 'ca80a415440612ae706f13661f48eb56d30cb3cbd58b0c7c3d55f967093dd102', // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
      userID: '${widget.fcm}',
      userName: widget.username,
      callID: '109112',
      // You can also use groupVideo/groupVoice/oneOnOneVoice to make more types of calls.
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall()
        ..topMenuBarConfig.isVisible = true
        ..topMenuBarConfig.buttons = [
      ZegoMenuBarButtonName.minimizingButton,
      ZegoMenuBarButtonName.showMemberListButton,
        ]
    );
  }
  Future<void> sendPushNotification()async{
    try{

    }catch(e){

    }
  }
}