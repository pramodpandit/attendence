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
import 'package:nb_utils/nb_utils.dart';
import 'package:office/data/model/user.dart';
import 'package:office/ui/community/communityProfile.dart';
import 'package:office/ui/widget/more_sheet.dart';
import 'package:provider/provider.dart';

import '../../bloc/profile_bloc.dart';
import '../../data/repository/profile_repo.dart';

class ChatScreen extends StatefulWidget {
  final User user;
  const ChatScreen(this.user,{Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController sendmessage = TextEditingController();
  File? galleryFile;
  PlayerController playerController = PlayerController();
  // var waveFormData;
  FilePickerResult? filePickerResult;
  final Completer<GoogleMapController> _completer = Completer();
  Position? position;
  late ProfileBloc profileBloc;
  List<String> messageType = ["r", "s", "s", "r", "s", "s", "r", "s"];

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

  @override
  void initState() {
    profileBloc=ProfileBloc(context.read<ProfileRepository>());
    super.initState();
  }

  Future<void> getLocation() async {
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
      imageView = Stack(children: [
        //image container:::
        Container(
          height: heightScreen / 2,
          width: widthScreen *0.7,
          margin: EdgeInsets.only(left: widthScreen*0.1,top: heightScreen*0.03),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            image: DecorationImage(
                fit: BoxFit.fill,
                image: FileImage(
                  galleryFile!,
                )),
            //color: Colors.amber,
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
        )
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
        )
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
        )
      ]);
    }
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: Column(
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
                      child: widget.user.image != null?Image.network(
                        "https://freeze.talocare.co.in/public/${widget.user.image}",
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                      ):const Icon(PhosphorIcons.user_bold),
                  ),
                   ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CommunityProfile()));
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Text(
                             "${widget.user.firstName??""} ${widget.user.middleName??""} ${widget.user.lastName??""}",
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ListView.builder(
                  itemCount: 8,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Column(
                        children: [
                          Container(
                            margin: messageType[index] == "r"
                                ? const EdgeInsets.only(right: 80)
                                : const EdgeInsets.only(left: 80),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius: messageType[index] == "r"
                                  ? const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    )
                                  : const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                    ),
                              color: messageType[index] == "r"
                                  ? Colors.grey.withOpacity(0.3)
                                  : Colors.blue,
                            ),
                            child: Text(
                              "Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipi",
                              style: TextStyle(
                                color: messageType[index] == "r"
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                          ),
                          Padding(
                            padding: messageType[index] == "r"
                                ? const EdgeInsets.only(left: 10)
                                : const EdgeInsets.only(right: 10),
                            child: Row(
                              mainAxisAlignment: messageType[index] == "r"
                                  ? MainAxisAlignment.start
                                  : MainAxisAlignment.end,
                              children: [
                                if (messageType[index] == "r")
                                  Icon(PhosphorIcons.checks_bold,
                                      size: 14,
                                      color: messageType[index] == "r"
                                          ? Colors.blue.shade700
                                          : Colors.grey.withOpacity(0.8)),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "1:30 AM",
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
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: sendmessage,
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
                        const Icon(PhosphorIcons.paper_plane_tilt),
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
        ),
      ),
    );
  }
}
