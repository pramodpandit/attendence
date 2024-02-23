import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:office/bloc/post_bloc.dart';
import 'package:office/data/repository/post_repo.dart';
import 'package:office/ui/widget/app_bar.dart';
import 'package:office/ui/widget/top_snackbar/top_snack_bar.dart';
import 'package:provider/provider.dart';

import '../../utils/constants.dart';
import '../../utils/message_handler.dart';
import 'communityHomepage.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  late PostBloc bloc;
  File? galleryFile;
  final picker = ImagePicker();

  @override
  void initState() {
    bloc = context.read<PostBloc>();
    super.initState();
    bloc.msgController?.stream.listen((event) {
      AppMessageHandler().showSnackBar(context, event);
    });

    bloc.postTextController.text = '';
    bloc.image = File('');
    bloc.postStream.stream.listen((event) {
      if (event == 'Post successfully') {
        bloc.fetchPostData();
        Navigator.pop(context);
      }
    });

  }
  Future<void> _openGallery() async {
    print("Opening Image Picker");
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        galleryFile = File(pickedFile.path);
        bloc.image = galleryFile;
        print("Image selected: ${pickedFile.path}-${galleryFile}");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget imageView = SizedBox.shrink();
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;
    print("Height:${heightScreen} Width:${widthScreen}");
    if (galleryFile != null) {
      imageView = Stack(children: [
        //image container:::
        Container(
          height: heightScreen / 2,
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
    return Scaffold(
      appBar: MyAppBar(title: "Add Post"),
      body: ListView(
          physics: NeverScrollableScrollPhysics(),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                height: heightScreen / 1.15,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[100]),
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: bloc.postTextController,
                          minLines: 1,
                          maxLines: 8,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "What do you want to talk about?"),
                        ),
                        imageView,
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        _openGallery();
                                      },
                                      icon: Icon(Icons.photo)),
                                  ValueListenableBuilder(
                                      valueListenable: bloc.isAddPostLoading,
                                      builder: (BuildContext context,bool isLoading,Widget? child){
                                        return Row(children: [
                                          isLoading?CircularProgressIndicator():
                                          ElevatedButton(
                                            onPressed: () {
                                              if(bloc.postTextController.text.toString() == ''|| galleryFile ==null){
                                                bloc.showMessage(MessageType.info('Please Select all field'));
                                              }else{
                                                bloc.addPost(context);
                                              }
                                            },
                                            child: Text(
                                              "Add Post",
                                              style: TextStyle(color: Colors.white),
                                            ),
                                            style: ButtonStyle(
                                                backgroundColor:
                                                MaterialStatePropertyAll(
                                                    K.themeColorPrimary)),
                                          ),
                                        ],
                                        );
                                      })
                                ]),
                          ),
                        ),
                      ]),
                ),
              ),
            ),
          ]),
    );
  }
}
