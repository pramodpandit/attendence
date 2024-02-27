import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddLeadFiles extends StatefulWidget {
  const AddLeadFiles({super.key});

  @override
  State<AddLeadFiles> createState() => _AddLeadFilesState();
}

class _AddLeadFilesState extends State<AddLeadFiles> {
  File? imageFile;

  Future<void> _openImagePicker(ImageSource source) async {
    Navigator.of(context).pop();
    print("Opening Image Picker");
    final filePicker =await FilePicker.platform.pickFiles();
    final pickedFile = File(filePicker!.files.single.path!);

    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        // profileBloc.image = galleryFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF009FE3),
        foregroundColor: Colors.white,
        title: Text("Add Lead File"),
      ),
      body: Column(
        children: [
          Center(
            child: InkWell(
              onTap: () {
                _openImagePicker(ImageSource.gallery);
              },
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.circle,
                  image: imageFile == null? null: DecorationImage(
                    image: FileImage(imageFile!),
                    fit: BoxFit.fill,
                  ),
                ),
                child: imageFile == null ?Icon(Icons.man,color: Colors.white,size: 70,):Offstage()
              ),
            ),
          )
        ],
      ),
    );
  }
}
