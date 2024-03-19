import 'dart:async';
import 'dart:io';

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
import 'package:office/data/model/user.dart';
import 'package:office/ui/community/communityProfile.dart';
import 'package:office/ui/widget/more_sheet.dart';
import 'package:office/utils/message_handler.dart';
import 'package:provider/provider.dart';

import '../../bloc/profile_bloc.dart';
import '../../data/repository/profile_repo.dart';
import 'imageAnimation.dart';

class ChatScreen extends StatefulWidget {
  final Map<String,dynamic> user;
  final ProfileBloc bloc;
  final SharedPreferences prefs;
  const ChatScreen({Key? key,required this.user, required this.bloc, required this.prefs}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  File? galleryFile;
  PlayerController playerController = PlayerController();
  // var waveFormData;
  FilePickerResult? filePickerResult;
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
        galleryFile = File(pickedFile.path);
        profileBloc.image = galleryFile;
      });
    }
  }

  Future<void> openFilePicker() async{
    filePickerResult = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );
    File audioFile = File(filePickerResult!.files.single.path!);
    // waveFormData = await playerController.extractWaveformData(
    //   path: filePickerResult.paths,
    //   // noOfSamples: 100,
    // );
    setState(() { });
// Or directly extract from preparePlayer and initialise audio player
    await playerController.preparePlayer(
      path: audioFile.path,
      shouldExtractWaveform: true,
      noOfSamples: 100,
      volume: 1.0,
    );
    // AudioPlayer audioPlayer = AudioPlayer();
    // audioPlayer.play(DeviceFileSource(audioFile.path));
  }

  late Stream<List> chattingStream;
  @override
  void initState() {
    profileBloc=ProfileBloc(context.read<ProfileRepository>());
    profileBloc.msgController?.stream.listen((event) {
      AppMessageHandler().showSnackBar(context, event);
    });
    super.initState();
    chattingStream = profileBloc.getOneToOneChat(widget.user['user_id'].toString()).asBroadcastStream();
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
  Widget build(BuildContext context) {
    Widget imageView = SizedBox.shrink();
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;
    if (galleryFile != null) {
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
                    galleryFile!,
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
                  galleryFile = null;
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
                      profileBloc.sendMessage(widget.user['user_id'].toString(),"one_to_one","image",image: galleryFile).then((value){
                        setState(() {
                          galleryFile = null;
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
                  profileBloc.sendMessage(widget.user['user_id'].toString(),"one_to_one","location",position: position).then((value){
                    setState(() {
                      position = null;
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
    if (filePickerResult != null) {
      imageView = Stack(children: [
        //image container:::
        Text("ui"),
        AudioFileWaveforms(
            size: Size(MediaQuery.of(context).size.width,100.0),
            playerController: playerController,
          waveformType: WaveformType.long,
          waveformData: const [10.0,20.0],
          playerWaveStyle: const PlayerWaveStyle(
              fixedWaveColor: Colors.white54,
              liveWaveColor: Colors.blueAccent,
              spacing: 6,
          ),
        ),
        //cross::::
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
              onPressed: () {
                setState(() {
                  filePickerResult = null;
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
                  profileBloc.sendMessage(widget.user['user_id'].toString(),"one_to_one","file",image: galleryFile).then((value){
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
                              child: widget.user['image'] != null?Image.network(
                                "https://freeze.talocare.co.in/public/${widget.user['image']}",
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                              ):const Icon(Icons.person),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                // Navigator.of(context).push(MaterialPageRoute(
                                //     builder: (context) => CommunityProfile()));
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("${widget.user['first_name']??''} ${widget.user['middle_name']??''} ${widget.user['last_name']??''}",
                                    maxLines: 1,
                                    style: const TextStyle(fontWeight: FontWeight.w500,overflow: TextOverflow.ellipsis),
                                  ),
                                  Text(
                                    "online",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 12,
                                        color: Colors.blue.shade400),
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
                                  Align(
                                    alignment: snapshot.data![index]['sender_id'].toString() == widget.prefs.getString("uid") ?Alignment.centerRight:Alignment.centerLeft,
                                    child: Container(
                                      padding: snapshot.data![index]['message_type'] == "location" || snapshot.data![index]['message_type'] == "image" ?
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
                                              Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatImageAnimation(img: "https://freeze.talocare.co.in/public/${snapshot.data![index]['file_uploaded']}",)));
                                            },
                                            child: Hero(
                                              tag:'imageAnimation',
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
                                                        backgroundColor: Colors.grey,
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
                            if(galleryFile==null && filePickerResult==null && position == null)
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
                                                  _openImagePicker(ImageSource.gallery);
                                                },
                                                title: Text("Gallery"),
                                                leading: Icon(Icons.browse_gallery),
                                              ),
                                              ListTile(
                                                onTap : () {
                                                  openFilePicker();
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
                                        profileBloc.sendMessage(widget.user['user_id'].toString(),"one_to_one","text");
                                        if(widget.user['fcm_token'] != null){
                                          profileBloc.sendNotification(widget.user);
                                        }
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
