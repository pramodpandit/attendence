import 'dart:async';
import 'dart:io';

import 'package:android_path_provider/android_path_provider.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:http/http.dart';
import 'package:office/data/model/user.dart';
import 'package:office/ui/chat/group_detail.dart';
import 'package:office/ui/chat/play_video_screen.dart';
import 'package:office/ui/community/communityProfile.dart';
import 'package:office/ui/widget/more_sheet.dart';
import 'package:office/utils/message_handler.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../bloc/profile_bloc.dart';
import '../../data/repository/profile_repo.dart';
import 'imageAnimation.dart';

class GroupChatScreen extends StatefulWidget {
  final Map<String,dynamic> group;
  final ProfileBloc bloc;
  final SharedPreferences prefs;
  const GroupChatScreen({Key? key,required this.group, required this.bloc, required this.prefs}) : super(key: key);

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  File? imageFile;
  File? videoFile;
  late VideoPlayerController videoPlayerController;
  late RecorderController recordController;
  bool recorder = false;
  ValueNotifier<bool> isRecording = ValueNotifier(false);
  final Completer<GoogleMapController> _completer = Completer();
  Position? position;
  late ProfileBloc profileBloc;

  Future<void> _openImagePicker(ImageSource source) async {
    Navigator.of(context).pop();
    print("Opening Image Picker");
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        profileBloc.image = imageFile;
      });
    }
  }
  Future<void> _openVideoPicker(ImageSource source) async {
    Navigator.of(context).pop();
    print("Opening Video Picker");
    final picker = ImagePicker();
    final pickedVideo = await picker.pickVideo(source: source);
    if (pickedVideo != null) {
      setState(() {
        videoFile = File(pickedVideo.path);
      });
      videoPlayerController = VideoPlayerController.file(File(pickedVideo.path))
        ..initialize().then((value){
          setState(() {});
          profileBloc.showMessage(MessageType.info("Tap on video to play/pause"));
        });
    }
  }

  Future<void> startRecorder() async{
    Navigator.of(context).pop();
    final hasPermission = await recordController.checkPermission();
    if(hasPermission){
      setState(() {
        recorder = true;
      });
      isRecording.value = true;
      await recordController.record();
    }
  }

  late Stream<List> chattingStream;
  @override
  void initState() {
    profileBloc=ProfileBloc(context.read<ProfileRepository>());
    profileBloc.msgController?.stream.listen((event) {
      AppMessageHandler().showSnackBar(context, event);
    });
    super.initState();
    initRecorder();
    chattingStream = profileBloc.getGroupChats(widget.group['id'].toString()).asBroadcastStream();
  }
  initRecorder(){
    recordController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..currentScrolledDuration
      ..sampleRate = 44100;
  }

  Future<void> getLocation() async {
    Navigator.of(context).pop();
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        getLocation();
      }else{
        Position currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        print(currentPosition);
      }
    }else{
      Position currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      print(currentPosition);
      setState(() {
        position = currentPosition;
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    recordController.dispose();
    videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget imageView = SizedBox.shrink();
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;
    if (imageFile != null) {
      imageView = Stack(
          children: [
        //image container:::
        Center(
          child: Container(
            height: heightScreen / 2,
            width: widthScreen *0.7,
            // margin: EdgeInsets.only(left: widthScreen*0.1,top: heightScreen*0.03),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: FileImage(
                    imageFile!,
                  )),
              //color: Colors.amber,
            ),
          ),
        ),
        //cross::::
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
              onPressed: () {
                setState(() {
                  imageFile = null;
                });
              },
              icon: Icon(Icons.highlight_remove)),
        ),

            Positioned(
              bottom: 10,
              right: 10,
              child: ValueListenableBuilder(
                valueListenable: profileBloc.isSending,
                builder: (context, isSending, child) {
                  if(isSending){
                    return Center(
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  }
                  return InkWell(
                    onTap: () {
                      profileBloc.sendMessage(widget.group['id'].toString(),"group","image",image: imageFile).then((value){
                        setState(() {
                          imageFile = null;
                        });
                      //   // if(widget.user['fcm_token'] != null && profileBloc.sendMessageController.text.isNotEmpty){
                      //   //   profileBloc.sendNotification(widget.user,image: galleryFile);
                      //   // }
                      });
                    },
                    child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black,
                        ),
                        child: const Icon(PhosphorIcons.paper_plane_tilt,color: Colors.white)),
                  );
                },),
            ),
      ]);
    }
    if (videoFile != null) {
      imageView = Stack(
          children: [
            //image container:::
            Center(
              child: Container(
                height: heightScreen / 2,
                width: widthScreen *0.7,
                child: AspectRatio(
                  aspectRatio: videoPlayerController.value.aspectRatio,
                  child: VideoPlayer(videoPlayerController).onTap((){
                    videoPlayerController.value.isPlaying?videoPlayerController.pause():videoPlayerController.play();
                  }).cornerRadiusWithClipRRect(10),
                ),
              ),
            ),
            //cross::::
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                  onPressed: () {
                    setState(() {
                      videoFile = null;
                    });
                  },
                  icon: Icon(Icons.highlight_remove)),
            ),

            Positioned(
              bottom: 10,
              right: 10,
              child: ValueListenableBuilder(
                valueListenable: profileBloc.isSending,
                builder: (context, isSending, child) {
                  if(isSending){
                    return Center(
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  }
                  return InkWell(
                    onTap: () {
                      profileBloc.sendMessage(widget.group['id'].toString(),"group","video",video: videoFile).then((value){
                        setState(() {
                          videoFile = null;
                        });
                        // if(widget.user['fcm_token'] != null && profileBloc.sendMessageController.text.isNotEmpty){
                        //   profileBloc.sendNotification(widget.user,image: galleryFile);
                        // }
                      });
                    },
                    child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black,
                        ),
                        child: const Icon(PhosphorIcons.paper_plane_tilt,color: Colors.white)),
                  );
                },),
            ),
          ]);
    }
    if (position != null) {
      imageView = Stack(children: [
        SizedBox(
            height: heightScreen / 2,
            width: widthScreen,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: GoogleMap(
                myLocationButtonEnabled: true,
                initialCameraPosition: CameraPosition(
                    target: LatLng(position!.latitude, position!.longitude),
                    zoom: 16,),
                mapType: MapType.terrain,
                markers: Set.of([Marker(markerId: MarkerId("1"),position: LatLng(position!.latitude,position!.longitude),icon: BitmapDescriptor.defaultMarker)]),
                onMapCreated: (controller) {
                  _completer.complete(controller);
                },
                buildingsEnabled: true,
                  ),
            )),
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
              onPressed: () {
                setState(() {
                  position = null;
                });
              },
              icon: Icon(Icons.highlight_remove)),
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: ValueListenableBuilder(
            valueListenable: profileBloc.isSending,
            builder: (context, isSending, child) {
              if(isSending){
                return Center(
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              }
              return InkWell(
                onTap: () {
                  profileBloc.sendMessage(widget.group['id'].toString(),"group","location",position: position).then((value){
                    setState(() {
                      position = null;
                    });
                  //   // if(widget.user['fcm_token'] != null && profileBloc.sendMessageController.text.isNotEmpty){
                  //   //   profileBloc.sendNotification(widget.user,image: galleryFile);
                  //   // }
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black,
                    ),
                    child: const Icon(PhosphorIcons.paper_plane_tilt,color: Colors.white)),
              );
            },),
        ),
      ]);
    }
    if (recorder) {
      imageView = Stack(children: [
        const SizedBox(height: 100),
        Positioned(
          bottom: 0,
          child: AudioWaveforms(
            enableGesture: true,
            size: Size(
                MediaQuery.of(context).size.width /2,
                50),
            recorderController: recordController,
            waveStyle: const WaveStyle(
              waveColor: Colors.white,
              extendWaveform: true,
              showMiddleLine: false,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: Colors.black,
            ),
            padding: const EdgeInsets.only(left: 18),
            margin: const EdgeInsets.symmetric(
                horizontal: 15),
          ),
        ),
        //cross::::
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
              onPressed: () {
                recordController.reset();
                setState(() {
                  recorder = false;
                });
              },
              icon: Icon(Icons.highlight_remove)),
        ),
        Positioned(
          bottom: 5,
          right: 55,
          child: InkWell(
            onTap: () {
              if(recordController.isRecording){
                isRecording.value = false;
                recordController.pause();
              }else{
                isRecording.value = true;
                recordController.record();
              }
            },
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
              ),
              child: ValueListenableBuilder(
                valueListenable: isRecording,
                builder: (context, isRecording, child) {
                  return Icon(isRecording?PhosphorIcons.pause:PhosphorIcons.play,color: Colors.white,size: 20);
                },),
            ),
          ),
        ),
        Positioned(
          bottom: 5,
          right: 10,
          child: ValueListenableBuilder(
            valueListenable: profileBloc.isSending,
            builder: (context, isSending, child) {
              if(isSending){
                return Center(
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              }
              return InkWell(
                onTap: () async{
                  // if(isRecording.value){
                  String? path = await recordController.stop();
                  recordController.reset();
                  // }
                  profileBloc.sendMessage(widget.group['id'].toString(),"group","audio",audioPath: path).then((value){
                    setState(() {
                      recorder = false;
                    });
                  });
                  // profileBloc.sendMessage(widget.user['user_id'].toString(),"one_to_one","file",image: galleryFile).then((value){
                  // if(widget.user['fcm_token'] != null && profileBloc.sendMessageController.text.isNotEmpty){
                  //   profileBloc.sendNotification(widget.user,image: galleryFile);
                  // }
                  // });
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                  ),
                  child: ValueListenableBuilder(
                    valueListenable: isRecording,
                    builder: (context, isRecording, child) {
                      return Icon(isRecording? PhosphorIcons.stop: PhosphorIcons.paper_plane_tilt,color: Colors.white,size: 20);
                    },),
                ),
              );
            },),
        ),
      ]);
    }
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: StreamBuilder(
          stream: chattingStream,
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if(snapshot.hasError){
              return Center(
                child: Text("Some error occured"),
              );
            }
            if(snapshot.hasData){
              if(snapshot.data == null){
                return Center(
                  child: CircularProgressIndicator(),
                );
              }else{
                return Column(
                  children: [
                    Container(
                      height:35,
                      color: Colors.grey.withOpacity(0.2),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.only(bottomRight: Radius.circular(25),bottomLeft: Radius.circular(25))
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.arrow_back,
                            ),
                          ),
                          const SizedBox(width: 5),
                          CircleAvatar(
                            radius: 20,
                            child: ClipOval(
                              child: widget.group['logo'] != null?Image.network(
                                "https://freeze.talocare.co.in/public/${widget.group['logo']}",
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                              ):const Icon(Icons.groups,color: Colors.blueGrey),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => GroupDetail(groupId: widget.group['id'].toString())));
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(widget.group['group_name']??'',
                                    maxLines: 1,
                                    style: const TextStyle(fontWeight: FontWeight.w500,overflow: TextOverflow.ellipsis),
                                  ),
                                  Text(
                                    widget.group['description'] ?? '',
                                    style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 12,
                                        color: Colors.green),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Spacer(),
                          SizedBox(
                            width: 15,
                          ),
                          GestureDetector(
                              onTap: () {},
                              child: Icon(
                                Icons.videocam,
                                color: Colors.blue,
                              )),
                          SizedBox(
                            width: 15,
                          ),
                          GestureDetector(
                              onTap: () {},
                              child: Icon(
                                Icons.call,
                                color: Colors.blue,
                                size: 20,
                              )),
                          SizedBox(
                            width: 15,
                          ),
                          GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: false,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20),
                                    ),
                                  ),
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  builder: (BuildContext context) {
                                    return MoreSheet(
                                      ctx: context,
                                      items: ["Report", "Block"],
                                      icons: [Icon(Icons.report), Icon(Icons.block)],
                                      deleteOnTap: () {

                                      },
                                    );
                                  },
                                );
                              },
                              child: Icon(Icons.more_vert)),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: snapshot.data!.isEmpty ? Offstage():
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: ListView.builder(
                          reverse: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: Column(
                                children: [
                                  index == snapshot.data!.length-1
                                      ?Container(
                                      padding: EdgeInsets.all(5),
                                      decoration : BoxDecoration(
                                        color : Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Text("${DateTime.parse(snapshot.data![index]['created_at']).isToday ? 'Today' :DateTime.parse(snapshot.data![index]['created_at']).isYesterday ? 'Yesterday' :DateFormat("dd/MM/yyyy").format(DateTime.parse(snapshot.data![index]['created_at']))}",
                                      ))
                                      : DateTime.parse(snapshot.data![index]['created_at']).day > DateTime.parse(snapshot.data![index+1]['created_at']).day
                                      ? Container(
                                      padding: EdgeInsets.all(5),
                                      decoration : BoxDecoration(
                                        color : Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Text("${DateTime.parse(snapshot.data![index]['created_at']).isToday ? 'Today' :DateTime.parse(snapshot.data![index]['created_at']).isYesterday ? 'Yesterday' :DateFormat("dd/MM/yyyy").format(DateTime.parse(snapshot.data![index]['created_at']))}",
                                      ))
                                      : Offstage(),
                                  const SizedBox(height: 10),
                                  Align(
                                    alignment: snapshot.data![index]['sender_id'].toString() == widget.prefs.getString("uid") ?Alignment.centerRight:Alignment.centerLeft,
                                    child: Row(
                                      mainAxisSize : MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          onTap : () {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => CommunityProfile(userid: int.parse(snapshot.data![index]['sender_id']))));
                                          },
                                          child: CircleAvatar(
                                            child: ClipRRect(
                                              borderRadius : BorderRadius.circular(1000),
                                              child: Image.network(
                                                "https://freeze.talocare.co.in/public/${snapshot.data![index]['image']}",
                                                loadingBuilder: (context, child, loadingProgress) {
                                                  if(loadingProgress == null){
                                                    return child;
                                                  }
                                                  return SizedBox(
                                                    height: 20,
                                                    width: 20,
                                                    child: Center(
                                                      child: CircularProgressIndicator(
                                                        value: loadingProgress.expectedTotalBytes != null?
                                                        loadingProgress.cumulativeBytesLoaded/
                                                            loadingProgress.expectedTotalBytes!
                                                            : null,
                                                        strokeWidth: 1,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                errorBuilder: (context, error, stackTrace) {
                                                  return Icon(PhosphorIcons.user);
                                                },
                                                width: double.infinity,
                                                height: double.infinity,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Container(
                                          padding: snapshot.data![index]['message_type'] == "location" || snapshot.data![index]['message_type'] == "image" || snapshot.data![index]['message_type'] == "video" || snapshot.data![index]['message_type'] == "audio" ?
                                          const EdgeInsets.symmetric(horizontal: 1,vertical: 1):
                                          const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 10),
                                          decoration: BoxDecoration(
                                            borderRadius: snapshot.data![index]['sender_id'].toString() == widget.prefs.getString("uid")
                                                ? const BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10),
                                              bottomLeft: Radius.circular(10),
                                            )
                                                : const BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10),
                                              bottomRight: Radius.circular(10),
                                            ),
                                            color: snapshot.data![index]['sender_id'].toString() == widget.prefs.getString("uid")
                                                ? Colors.blue
                                                : Colors.grey.withOpacity(0.3),
                                          ),
                                          child: snapshot.data![index]['message_type'] == "image" ?
                                          SizedBox(
                                            width : 150,
                                            height : 150,
                                            child: ClipRRect(
                                              borderRadius : BorderRadius.circular(10),
                                              child: InkWell(
                                                onTap:(){
                                                  Navigator.push(context, MaterialPageRoute(builder:(context)=>ChatImageAnimation(img: "https://freeze.talocare.co.in/public/${snapshot.data![index]['file_uploaded']}",tag: 'img${index}',)));

                                                },
                                                child: Hero(
                                                  tag:'img${index}',
                                                  child: Image.network(
                                                    "https://freeze.talocare.co.in/public/${snapshot.data![index]['file_uploaded']}",
                                                    loadingBuilder: (context, child, loadingProgress) {
                                                      if(loadingProgress == null){
                                                        return child;
                                                      }
                                                      return SizedBox(
                                                        height: 40,
                                                        width: 40,
                                                        child: Center(
                                                          child: CircularProgressIndicator(
                                                            value: loadingProgress.expectedTotalBytes != null?
                                                            loadingProgress.cumulativeBytesLoaded/
                                                                loadingProgress.expectedTotalBytes!
                                                                : null,
                                                            strokeWidth: 1,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                              : snapshot.data![index]['message_type'] == "video" ?
                                          VideoPlayerWidget(videoPath: snapshot.data![index]['file_uploaded'],index: index)
                                              : snapshot.data![index]['message_type'] == "audio" ?
                                          GroupAudioPlayerWidget(audioPath : snapshot.data![index]['file_uploaded'])
                                              : snapshot.data![index]['message_type'] == "location" ?
                                          SizedBox(
                                            height : 150,
                                            width : 150,
                                            child: ClipRRect(
                                              borderRadius : BorderRadius.circular(10),
                                              child: GoogleMap(
                                                myLocationButtonEnabled: true,
                                                initialCameraPosition: CameraPosition(
                                                  target: LatLng(double.parse(snapshot.data![index]['latitude']), double.parse(snapshot.data![index]['longitude'])),
                                                  zoom: 12,
                                                ),
                                                mapType: MapType.terrain,
                                                markers: Set.of([Marker(markerId: MarkerId("1"),position: LatLng(double.parse(snapshot.data![index]['latitude']), double.parse(snapshot.data![index]['longitude'])),icon: BitmapDescriptor.defaultMarker)]),
                                                onMapCreated: (controller) {
                                                  _completer.complete(controller);
                                                },
                                                zoomControlsEnabled: false,
                                                buildingsEnabled: true,
                                              ),
                                            ),
                                          )
                                              : Text(
                                            snapshot.data![index]['message'].toString(),
                                            style: TextStyle(
                                              color: snapshot.data![index]['sender_id'].toString() == widget.prefs.getString("uid")
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: snapshot.data![index]['sender_id'].toString() == widget.prefs.getString("uid")
                                        ? const EdgeInsets.only(right: 5)
                                        : const EdgeInsets.only(left: 5),
                                    child: Row(
                                      mainAxisAlignment: snapshot.data![index]['sender_id'].toString() == widget.prefs.getString("uid")
                                          ? MainAxisAlignment.end
                                          : MainAxisAlignment.start,
                                      children: [
                                        if (snapshot.data![index]['sender_id'].toString() == widget.prefs.getString("uid"))
                                          Icon(PhosphorIcons.checks_bold,
                                              size: 14,
                                              color: snapshot.data![index]['sender_id'].toString() == widget.prefs.getString("uid")
                                                  ? Colors.blue.shade700
                                                  : Colors.grey.withOpacity(0.8)),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "${DateFormat("hh:mm a").format(DateTime.parse(snapshot.data![index]['created_at']))}",
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.grey.withOpacity(0.8)),
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
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20)),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                spreadRadius: 1,
                                blurRadius: 3,
                                color: Colors.black.withOpacity(0.2),
                              )
                            ]),
                        padding: const EdgeInsets.only(
                            bottom: 10, top: 10, left: 10, right: 10),
                        child: Column(
                          children: [
                            imageView,
                            if(imageFile==null && videoFile==null && recorder==false && position == null)
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: profileBloc.sendMessageController,
                                      keyboardType: TextInputType.multiline,
                                      maxLines: 3,
                                      minLines: 1,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Send Message...",
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  InkWell(
                                      onTap: (){
                                        showModalBottomSheet(context: context, builder: (context) {
                                          return Container(
                                            color: Colors.white,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                ListTile(
                                                  onTap : () {
                                                    _openImagePicker(ImageSource.camera);
                                                  },
                                                  title: Text("Camera"),
                                                  leading: Icon(PhosphorIcons.camera),
                                                ),
                                                ListTile(
                                                  onTap : () {
                                                    _openVideoPicker(ImageSource.camera);
                                                  },
                                                  title: Text("Video"),
                                                  leading: Icon(PhosphorIcons.video_camera),
                                                ),
                                                ListTile(
                                                  onTap : () {
                                                    _openImagePicker(ImageSource.gallery);
                                                  },
                                                  title: Text("Gallery"),
                                                  leading: Icon(Icons.browse_gallery),
                                                ),
                                                ListTile(
                                                  onTap : () {
                                                    startRecorder();
                                                  },
                                                  title: Text("Audio"),
                                                  leading: Icon(PhosphorIcons.file_audio),
                                                ),
                                                ListTile(
                                                  onTap : () {
                                                    getLocation();
                                                  },
                                                  title: Text("Location"),
                                                  leading: Icon(Icons.location_on),
                                                ),
                                              ],
                                            ),
                                          );
                                        },);
                                      },
                                      child: const Icon(Icons.attach_file)),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  ValueListenableBuilder(
                                    valueListenable: profileBloc.isSending,
                                    builder: (context, isSending, child) {
                                      if(isSending){
                                        return Center(
                                          child: SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(strokeWidth: 2),
                                          ),
                                        );
                                      }
                                      return InkWell(
                                        onTap: () {
                                          if(profileBloc.sendMessageController.text.isEmpty){
                                            return;
                                          }
                                          profileBloc.sendMessage(widget.group['id'].toString(),"group","text");
                                          // if(widget.user['fcm_token'] != null){
                                          //   profileBloc.sendNotification(widget.user);
                                          // }
                                        },
                                        child: const Icon(PhosphorIcons.paper_plane_tilt),
                                      );
                                    },),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
            }
            return Offstage();
          },),
      ),
    );
  }
}

class GroupAudioPlayerWidget extends StatefulWidget {
  final String audioPath;
  const GroupAudioPlayerWidget({super.key, required this.audioPath});

  @override
  State<GroupAudioPlayerWidget> createState() => _GroupAudioPlayerWidgetState();
}

class _GroupAudioPlayerWidgetState extends State<GroupAudioPlayerWidget> {
  PlayerController playerController = PlayerController();
  File? audioFile;
  ValueNotifier<bool> isPermissionGranted = ValueNotifier(true);
  ValueNotifier<bool> showError = ValueNotifier(false);
  ValueNotifier<PlayerState> playerState = ValueNotifier(PlayerState.stopped);

  initPlayerController(String audioPath)async{
    PermissionStatus permissionStatus = await Permission.manageExternalStorage.request();
    if(permissionStatus.isGranted){
      isPermissionGranted.value = false;
      return;
    }
    isPermissionGranted.value = true;
    try{
      var downloadsPath = await AndroidPathProvider.downloadsPath;
      Response response = await get(Uri.parse(audioPath));
      Uint8List bytes = response.bodyBytes;
      audioFile = File("$downloadsPath/${audioPath.split('/').last}");
      if(response.statusCode == 200){
        await audioFile!.writeAsBytes(bytes);
        await playerController.preparePlayer(path: audioFile!.path).then((value){
          playerState.value = playerController.playerState;
        });
      }else{
        showError.value = true;
      }

      playerController.onPlayerStateChanged.listen((event) {
        playerState.value = event;
      });
    }catch(e){
      showError.value = true;
      debugPrint("this is the error $e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPlayerController("https://freeze.talocare.co.in/public/${widget.audioPath}");
  }

  @override
  void dispose() async{
    // TODO: implement dispose
    super.dispose();
    if(playerController.playerState == PlayerState.playing){
      await playerController.pausePlayer();
    }
    playerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isPermissionGranted,
      builder: (context, isPermissionGranted, child) {
        if(!isPermissionGranted){
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize : MainAxisSize.min,
              children: [
                Icon(Icons.error_outline,color: Colors.white),
                SizedBox(width: 5),
                SizedBox(
                  width : 150,
                  child: Text("Permission not granted to view audio",style: TextStyle(color: Colors.white, overflow: TextOverflow.ellipsis)),
                ),
              ],
            ),
          );
        }
        return ValueListenableBuilder(
          valueListenable: showError,
          builder: (context, showError, child) {
            if(showError){
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize : MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline,color: Colors.white),
                    SizedBox(width: 5),
                    SizedBox(
                      width : 150,
                      child: Text("Error downloading audio",style: TextStyle(color: Colors.white, overflow: TextOverflow.ellipsis)),
                    ),
                  ],
                ),
              );
            }
            return ValueListenableBuilder(
              valueListenable: playerState,
              builder: (context, playerState, child) {
                if(playerState == PlayerState.stopped){
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize : MainAxisSize.min,
                      children: [
                        Icon(Icons.stacked_line_chart_outlined,color: Colors.white),
                        SizedBox(width: 5),
                        SizedBox(
                          width : 150,
                          child: Text("Downloading audio...",style: TextStyle(color: Colors.white, overflow: TextOverflow.ellipsis)),
                        ),
                      ],
                    ),
                  );
                }
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(onPressed: () async{
                      PlayerState res = playerController.playerState;
                      if(res==PlayerState.playing) {
                        await playerController.pausePlayer();
                      } else {
                        await playerController.startPlayer(finishMode: FinishMode.pause);
                      }
                    }, icon: Icon(playerState == PlayerState.playing ? PhosphorIcons.pause_fill:PhosphorIcons.play_fill,color: Colors.white)),
                    AudioFileWaveforms(
                      size: Size(MediaQuery.of(context).size.width / 3, 40.0),
                      playerController: playerController,
                      enableSeekGesture: true,
                      waveformType: WaveformType.long,
                      waveformData: playerController.waveformData,
                      playerWaveStyle: const PlayerWaveStyle(
                        fixedWaveColor: Colors.white54,
                        liveWaveColor: Colors.green,
                        spacing: 5,
                      ),
                    )
                  ],
                );
              },);
          },);
      },);
  }
}


class VideoPlayerWidget extends StatefulWidget {
  final String videoPath;
  final int index;
  const VideoPlayerWidget({super.key, required this.videoPath, required this.index});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController videoPlayerController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    videoPlayerController = VideoPlayerController.networkUrl(Uri.parse("https://freeze.talocare.co.in/public/${widget.videoPath}"))
      ..initialize().then((value){
        setState(() {});
      })..setLooping(false);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    videoPlayerController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Hero(
          tag: "animateVideo${widget.index}",
          child: Material(
            child: SizedBox(
              width: 150,
              height: 150,
              child: AspectRatio(
                aspectRatio: videoPlayerController.value.aspectRatio,
                child: VideoPlayer(videoPlayerController).onTap((){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => PlayVideoScreen(videoPlayerController: videoPlayerController,animationTag: "animateVideo${widget.index}")));
                }),
              ),
            ),
          ).cornerRadiusWithClipRRect(10),
        ),
        IconButton(
          color: Colors.white,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => PlayVideoScreen(videoPlayerController: videoPlayerController,animationTag: "animateVideo")));
          },
          icon: Icon(PhosphorIcons.play_fill),
        )
      ],
    );
  }
}
