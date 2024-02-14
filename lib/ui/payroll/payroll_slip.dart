import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class payroll_slip extends StatefulWidget {
  const payroll_slip({Key? key}) : super(key: key);

  @override
  State<payroll_slip> createState() => _payroll_slip();
}

class _payroll_slip extends State<payroll_slip> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   leading: GestureDetector(
      //       onTap: () {
      //         Navigator.pop(context);
      //       },
      //       child: const CircleAvatar(
      //       backgroundColor: Colors.white,
      //       radius: 15,
      //       child: Icon(
      //       Icons.arrow_back,
      //       size: 18,
      //       ),
      //       ),
      // ),),
      body: SingleChildScrollView(
        child: Column(

          children: [
            Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Image.asset('images/back.png')],),
                Positioned(
                  top: 50,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_back,
                            size: 20,
                          ),
                        ),
                        SizedBox(height: 10,),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Payroll",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20,
                                    letterSpacing: 0.5,
                                    color: Colors.black),
                              ),
                              SizedBox(width: 140.w,),
                              InkWell(
                                  onTap: () {
                                    downloadFile('images/1.pdf','images/1.pdf');
                                  },
                                  child: Image.asset('images/print.png'))
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 60,
                        ),


                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20,),
            Container(
              height: 500,
              width: 500.w,
              child: SfPdfViewer.asset(
                  'images/salary.pdf'),
            ),


          ],
        ),
      ),
    );
  }

  downloadFile(var filePath, var documentUrl) async {
    try {
      /// setting filename
      final filename = filePath;
      String dir = (await getApplicationDocumentsDirectory()).path;
      if (await File('$dir/$filename').exists()) return File('$dir/$filename');

      String url = documentUrl;

      /// requesting http to get url
      var request = await HttpClient().getUrl(Uri.parse(url));

      /// closing request and getting response
      var response = await request.close();

      /// getting response data in bytes
      var bytes = await consolidateHttpClientResponseBytes(response);

      /// generating a local system file with name as 'filename' and path as '$dir/$filename'
      File file = new File('$dir/$filename');

      /// writing bytes data of response in the file.
      await file.writeAsBytes(bytes);

      return file;
    }
    catch (err) {
      print(err);
    }
  }
}
