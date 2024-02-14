import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:office/bloc/profile_bloc.dart';
import 'package:office/data/model/document.dart';
import 'package:office/data/repository/profile_repo.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class DocumentScreen extends StatefulWidget {
  const DocumentScreen({Key? key}) : super(key: key);

  @override
  State<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
  late ProfileBloc bloc;
  int progress = 0;
  final ReceivePort _port = ReceivePort();
  @override
  void initState() {
    bloc = ProfileBloc(context.read<ProfileRepository>());
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((message) {
      setState(() {
        progress = message;
      });
    });
    FlutterDownloader.registerCallback(downloadCallback);
    super.initState();
    bloc.fetchUserDocuments();
  }

  static downloadCallback(id, status, progress) {
    SendPort? sendPort =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    sendPort?.send(progress);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          ValueListenableBuilder(
              valueListenable: bloc.isUserDocumentLoad,
              builder: (context, bool loading, __) {
                if (loading == true) {
                  return Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.5,
                      ),
                      const Center(child: CircularProgressIndicator()),
                    ],
                  );
                }
                return Padding(
                    padding: const EdgeInsets.only(
                        left: 25, right: 25, top: 10, bottom: 10),
                    child: ValueListenableBuilder(
                        valueListenable: bloc.userDocuments,
                        builder: (context, List<Document>? document, __) {
                          if (document == null) {
                            return const Center(
                              child: Text("User Details Not Found!"),
                            );
                          }
                          return ListView.builder(
                              physics: const ScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: document.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  width: 1.sw,
                                  padding: const EdgeInsets.all(12),
                                  margin: const EdgeInsets.only(bottom: 20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        spreadRadius: 1,
                                        blurRadius: 3,
                                        color: Colors.grey.withOpacity(0.3),
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            document[index].name ?? "",
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight:
                                                    FontWeight.w600,
                                                fontSize: 13,
                                                fontFamily: "Poppins"),
                                          ),
                                          const Spacer(),
                                          GestureDetector(
                                            onTap: () async {
                                              final androidInfo = await DeviceInfoPlugin().androidInfo;
                                              print("object");
                                              String url =
                                                  "https://freeze.talocare.co.in/public/${document[index].file}";
                                              if (androidInfo.version.sdkInt <= 32) {
                                                var status = await
                                                  Permission.storage.request();
                                                if (status.isGranted) {
                                                  var firstPath =
                                                      "/storage/emulated/0/Documents/images/";
                                                  var path =
                                                  await Directory(firstPath)
                                                      .create(
                                                      recursive: true);
                                                  // final baseStorage=await getExternalStorageDirectory();
                                                  await FlutterDownloader.enqueue(
                                                    url: url,
                                                    savedDir: path.path,
                                                    saveInPublicStorage: true,
                                                    fileName:
                                                    "${document[index].name}",
                                                  );
                                                }
                                              } else {
                                                var status = await Permission.photos.request();
                                                if (status.isGranted) {
                                                  var firstPath =
                                                      "/storage/emulated/0/Documents/images/";
                                                  var path =
                                                  await Directory(firstPath)
                                                      .create(
                                                      recursive: true);
                                                  // final baseStorage=await getExternalStorageDirectory();
                                                  await FlutterDownloader.enqueue(
                                                    url: url,
                                                    savedDir: path.path,
                                                    saveInPublicStorage: true,
                                                    fileName:
                                                    "${document[index].name}",
                                                  );
                                                }
                                              }
                                              // await FlutterDownloader.enqueue(
                                              //   url: url,
                                              //   fileName: "${document[index].name}",
                                              //   allowCellular: true,
                                              //   headers: {"auth": "test_for_sql_encoding"},
                                              //   savedDir:path.path,
                                              //   saveInPublicStorage: true,
                                              //   showNotification: true, // show download progress in status bar (for Android)
                                              //   openFileFromNotification: true, // click on notification to open downloaded file (for Android)
                                              //
                                              // );
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(6),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(100),
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                        spreadRadius: 0,
                                                        blurRadius: 3,
                                                        color: Colors.black.withOpacity(0.2)
                                                    )
                                                  ]
                                              ),
                                              child: const Icon(
                                                Icons.download,
                                                color: Colors.black,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      if(document[index].other!=null)Text(
                                        document[index].other ?? "",
                                        //  "${document[index].other}",
                                        style: const TextStyle(
                                            color: Colors.black45,
                                            fontWeight:
                                                FontWeight.w600,
                                            fontSize: 11,
                                            fontFamily: "Poppins"),
                                      ),
                                    ],
                                  ),
                                );
                              });
                        }));
              })
        ],
      ),
    ));
  }
}
