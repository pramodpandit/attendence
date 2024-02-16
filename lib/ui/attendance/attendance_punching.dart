
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:office/bloc/bloc.dart';
import 'package:office/utils/message_handler.dart';
import 'package:open_settings/open_settings.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_digital_clock/slide_digital_clock.dart';

import '../../bloc/profile_bloc.dart';
import '../../data/repository/profile_repo.dart';

class AttendancePunching extends StatefulWidget {
  const AttendancePunching({Key? key}) : super(key: key);

  @override
  State<AttendancePunching> createState() => _AttendancePunchingState();
}

class _AttendancePunchingState extends State<AttendancePunching> {
  late ProfileBloc bloc;
  late SharedPreferences _prefs;
  bool isPunching = true;
  String location = '';
  String notificationPermissionStatus = '';
  DateTime? punchInTime;
  DateTime? punchOutTime;
  double distance = 0.0;
  var targetLatitude = "28.4875647";
  var targetLongitude = "77.0646938";

  var currentLatitude = "";
  var currentLongitude = "";

  @override
  void initState() {
    bloc = ProfileBloc(context.read<ProfileRepository>());
    super.initState();
    bloc.fetchUserDetail();
    bloc.fetchTodayWorkingDetail();
    // requestLocationPermission();
    // getCurrentLocation();
    _initSharedPreferences();
    getLocation();
  }

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    // Load punch in, punch out, and working hours from SharedPreferences
    setState(() {
      punchInTime = _getDateTime('punchInTime');
      punchOutTime = _getDateTime('punchOutTime');
    });
  }

  void _saveDateTime(String key, DateTime? dateTime) {
    if (dateTime != null) {
      _prefs.setString(key, dateTime.toIso8601String());
    } else {
      _prefs.remove(key);
    }
  }

  DateTime? _getDateTime(String key) {
    final String? dateString = _prefs.getString(key);
    return dateString != null ? DateTime.parse(dateString) : null;
  }

  Future<void> getLocation() async {
    await requestLocationPermission();
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (serviceEnabled) {
      getCurrentLocation();
    } else {
      showLocationServiceDialog();
    }
  }

  Future<void> requestLocationPermission() async {
    var status = await Permission.location.status;
    if (status.isDenied) {
      await Permission.location.request();
    }

    // Check permission status again after the request
    status = await Permission.location.status;

    if (status.isDenied) {
      // Location permission is still denied, show dialog
      showLocationServiceDialog();
    }
  }

  void showLocationServiceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Enable Location Services"),
          content: Text("Please enable location services to use this feature."),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                // Open device settings to enable location services
                //Geolocator.openAppSettings();
                OpenSettings.openLocationSourceSetting();
                },
            ),
          ],
        );
      },
    );
  }
  void getCurrentLocation() async {
    try {
      var status = await Permission.location.status;
      if (status.isGranted) {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        setState(() {
          currentLatitude = position.latitude.toString();
          currentLongitude = position.longitude.toString();
        });
        var calculatedDistance = Geolocator.distanceBetween(position.latitude, position.longitude, targetLatitude.toDouble(), targetLongitude.toDouble());
        setState(() {
          distance = calculatedDistance;
        });
        getAddress(position.latitude, position.longitude);
      } else {
        setState(() {
          location = 'Location permission denied';
        });
      }
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  Future<void> getAddress(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        Placemark adr = placemarks.first;
        String address = "";
        address += adr.name ?? '';
        address += adr.street != null && adr.street!.isNotEmpty ? ", ${adr.street}" : '';
        address += adr.subLocality != null && adr.subLocality!.isNotEmpty ? ", ${adr.subLocality}" : '';
        address += adr.locality != null && adr.locality!.isNotEmpty ? ", ${adr.locality}" : '';
        address += adr.postalCode != null && adr.postalCode!.isNotEmpty ? "-${adr.postalCode}" : '';
        address += adr.administrativeArea != null && adr.administrativeArea!.isNotEmpty ? ", ${adr.administrativeArea}" : '';
        address += adr.country != null && adr.country!.isNotEmpty ? ", ${adr.country}" : '';
        setState(() {
          location = address;
        });
      }
    } catch (e, s) {
      print(e);
      print(s);
    }
  }

  File? imageFile;
  TextEditingController punchWorkController = TextEditingController();

  void showDailyWorkDialog(){
    showInDialog(
        context,
      dialogAnimation: DialogAnimation.SLIDE_TOP_BOTTOM,
      builder: (p0) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Today Work",style: GoogleFonts.nunito(fontSize: 20,fontWeight: FontWeight.bold)),
              10.height,
              InkWell(
                onTap: () async{
                  final ImagePicker picker = ImagePicker();
                  XFile? image = await picker.pickImage(source: ImageSource.camera);
                  setState(() {
                    imageFile = File(image!.path);
                  });
                  Navigator.of(context).pop();
                  showDailyWorkDialog();
                },
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                     border: Border.all(width: 1,color: Colors.grey),
                     image: imageFile==null ?
                         const DecorationImage(image: AssetImage("images/user_icon.png"),scale: 3):
                    DecorationImage(
                      fit: BoxFit.fill,
                      image: FileImage(
                        imageFile!,
                      )
                    )
                  ),
                ),
              ),
              10.height,
              TextFormField(
                controller: punchWorkController,
                maxLines: 4,
                style: GoogleFonts.lato(),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  hintText: "Write Work",
                  border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black,width: 1))
                ),
              )
            ],
          ),
        );
      },
      actions: [
        OutlinedButton(onPressed: () {
          Navigator.of(context).pop();
        }, child: Text("Cancel")),
        OutlinedButton(onPressed: () {
          if(bloc.todayWorkingDetail.value["selfi"]== "yes" && imageFile == null){
            toast('Please capture an image',bgColor: Colors.red,textColor: Colors.white);
          }else if(punchWorkController.text.isEmpty){
            toast("Please enter some work",bgColor: Colors.red,textColor: Colors.white);
          }else{
            Navigator.of(context).pop();
            showPunchConfirmationDialog();
          }
        }, child: Text("Punch")),
      ]
    );
  }
  void showPunchConfirmationDialog() {
    String punchType = bloc.todayWorkingDetail.value["checkin"] == "" ? "Punch In" : "Punch Out";
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm $punchType"),
          content: Text("Are you sure you want to $punchType?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Confirm"),
              onPressed: () {
                // Toggle the state when confirmed
                setState(() {
                  if (isPunching) {
                    bloc.markAttendance([]);
                    punchInTime = DateTime.now();
                    punchOutTime=null;
                    _saveDateTime('punchInTime', punchInTime);
                  } else {
                    punchOutTime = DateTime.now();
                    _saveDateTime('punchOutTime', punchOutTime);
                  }
                  isPunching = !isPunching;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String calculateTimeGap() {
    if (punchInTime != null && punchOutTime != null) {
      Duration timeGap = punchOutTime!.difference(punchInTime!);
      int hours = timeGap.inHours;
      int minutes = (timeGap.inMinutes - hours * 60);
      int seconds = (timeGap.inSeconds - hours * 3600 - minutes * 60);

      return "${hours.toString().padLeft(2,'0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
    } else {
      return "----";
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: ValueListenableBuilder(
              valueListenable: bloc.isUserDetailLoad,
              builder: (context, bool loading, __) {
                if (loading == true) {
                  return Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 1,
                      ),
                      const Center(child: CircularProgressIndicator()),
                    ],
                  );
                }
                return ValueListenableBuilder(
                  valueListenable: bloc.todayWorkingDetail,
                  builder: (context, workingDetail, child) {
                    if(workingDetail == null){
                      return Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.width * 1,
                          ),
                          const Center(child: CircularProgressIndicator()),
                        ],
                      );
                    }
                    return ValueListenableBuilder(
                        valueListenable: bloc.userDetail,
                        builder: (context, user, _) {
                          if (user == null) {
                            return Column(
                              children: [
                                SizedBox(
                                  height: MediaQuery.of(context).size.width * 1,
                                ),
                                const Center(
                                  child: Text("User Details Not Found!"),
                                ),
                              ],
                            );
                          }
                          return Stack(
                            children: [
                              Column(
                                children: [
                                  Image.asset(
                                    "images/back.png",
                                    fit: BoxFit.cover,
                                    height: 200,
                                    width: double.infinity,
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 50,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "Hello,",
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontSize: 17,
                                                  overflow: TextOverflow.ellipsis,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Text(
                                                "${user.name}",
                                                maxLines: 1,
                                                style: const TextStyle(
                                                  fontSize: 17,
                                                  overflow: TextOverflow.ellipsis,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 50,
                                        ),
                                        CircleAvatar(
                                          radius: 20,
                                          backgroundColor:
                                          Colors.blue.withOpacity(0.7),
                                          child: ClipOval(
                                            child: user.image != null
                                                ? Image.network(
                                              "https://freeze.talocare.co.in/public/${user.image}",
                                              height: 60,
                                              width: 60,
                                              fit: BoxFit.cover,
                                            )
                                                : const Icon(PhosphorIcons.user_bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 45,
                                    ),
                                    Center(
                                      child: Column(
                                        children: [
                                          DigitalClock(
                                            showSecondsDigit: false,
                                            is24HourTimeFormat: false,
                                            digitAnimationStyle: Curves.easeOut,
                                            areaAligment: AlignmentDirectional.center,
                                            secondDigitTextStyle: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 30,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            colon:Text(':',style:  TextStyle(
                                              color: Colors.black,
                                              fontSize: 30,
                                              fontWeight: FontWeight.w600,
                                            ),),

                                            hourMinuteDigitTextStyle: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 30,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            amPmDigitTextStyle: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 30,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                            DateFormat("EEEE, d MMMM y")
                                                .format(DateTime.now()),
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 13),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          workingDetail["working"]==1?
                                          workingDetail["checkin"] == "" && workingDetail["checkout"] ==""?
                                          workingDetail["location"] == "yes"?
                                          GestureDetector(
                                            onTap: () {
                                              // Toggle the state on tap
                                              // setState(() {
                                              //   isPuchin = !isPuchin;
                                              // });
                                              if(location ==''){
                                                getLocation();
                                              } else{
                                                if(isPunching){
                                                  if(workingDetail["dailyworkcheckin"]=="yes") {
                                                    showDailyWorkDialog();
                                                  }else{
                                                    showPunchConfirmationDialog();
                                                  }
                                                }else{
                                                  if(workingDetail["dailyworkcheckout"]=="yes") {
                                                    showDailyWorkDialog();
                                                  }else{
                                                    showPunchConfirmationDialog();
                                                  }
                                                }
                                              }
                                            },
                                            child: Image.asset(
                                              // "images/puchin.png",
                                              workingDetail["checkin"] == "" ? "images/puchin.png" : "images/puchout.png",
                                              height: 230,
                                            ),
                                          ):
                                          distance <= 300.0?
                                          GestureDetector(
                                            onTap: () {
                                              // Toggle the state on tap
                                              // setState(() {
                                              //   isPuchin = !isPuchin;
                                              // });
                                              if(location ==''){
                                                getLocation();
                                              } else{
                                                if(isPunching){
                                                  if(workingDetail["dailyworkcheckin"]=="yes") {
                                                    showDailyWorkDialog();
                                                  }else{
                                                    showPunchConfirmationDialog();
                                                  }
                                                }else{
                                                  if(workingDetail["dailyworkcheckout"]=="yes") {
                                                    showDailyWorkDialog();
                                                  }else{
                                                    showPunchConfirmationDialog();
                                                  }
                                                }
                                              }
                                            },
                                            child: Image.asset(
                                              // "images/puchin.png",
                                              workingDetail["checkin"] == "" ? "images/puchin.png" : "images/puchout.png",
                                              height: 230,
                                            ),
                                          )
                                              :SizedBox(
                                              height: 230,
                                              child: Center(child: Text("You are out of range")))
                                              :SizedBox(
                                              height: 230,
                                              child: Center(child: Text("You Punched Out Succesfully")))
                                              :SizedBox(
                                              height: 230,
                                              child: Center(child: Text("Today is Weekend Day"))),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          workingDetail["working"]==1?
                                          Column(
                                            children: [
                                              Text(
                                                "Location",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18),
                                              ),
                                              Text(
                                                // "75C, Sector 18, Gurugram, Haryana 122001",
                                                location,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 11),
                                              ),
                                              const SizedBox(
                                                height: 30,
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: [
                                                  Column(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment.center,
                                                        children: [
                                                          Icon(
                                                            PhosphorIcons.arrow_up,
                                                            size: 18,
                                                            color: Colors.green,
                                                          ),
                                                          Icon(
                                                            PhosphorIcons.clock_bold,
                                                            size: 25,
                                                          ),
                                                        ],
                                                      ),
                                                      Text(
                                                        punchInTime != null
                                                            ? DateFormat("hh:mm:ss").format(punchInTime!)
                                                            : "-----",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight: FontWeight.w600,
                                                            fontSize: 13),
                                                      ),
                                                      Text(
                                                        "Punch-in",
                                                        style: TextStyle(
                                                            color: Colors.black54,
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 10),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    width: 20,
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment.center,
                                                        children: [
                                                          Icon(
                                                            PhosphorIcons.arrow_down,
                                                            size: 18,
                                                            color: Colors.red,
                                                          ),
                                                          Icon(
                                                            PhosphorIcons.clock_bold,
                                                            size: 25,
                                                          ),
                                                        ],
                                                      ),
                                                      Text(
                                                        punchOutTime  != null
                                                            ? DateFormat("hh:mm:ss").format(punchOutTime!)
                                                            : "-----",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight: FontWeight.w600,
                                                            fontSize: 13),
                                                      ),
                                                      Text(
                                                        "Punch-out",
                                                        style: TextStyle(
                                                            color: Colors.black54,
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 10),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    width: 20,
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                    children: [
                                                      Icon(
                                                        PhosphorIcons.clock_bold,
                                                        size: 25,
                                                      ),
                                                      Text(
                                                        calculateTimeGap()??"-----",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight: FontWeight.w600,
                                                            fontSize: 13),
                                                      ),
                                                      Text(
                                                        "Working hours",
                                                        style: TextStyle(
                                                            color: Colors.black54,
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 10),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )
                                            ],
                                          ):Offstage(),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          );
                        });
                  },);
              }),
        ),
      ),
    );
  }
}
