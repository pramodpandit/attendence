import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:office/bloc/notes_bloc.dart';
import 'package:office/data/model/notes_model.dart';
import 'package:provider/provider.dart';

class NotesDetails extends StatefulWidget {
  const NotesDetails({Key? key,required this.data}) : super(key: key);
  final NotesModel? data;
  @override
  State<NotesDetails> createState() => _NotesDetailsState();
}

class _NotesDetailsState extends State<NotesDetails> {
  late NotesBloc bloc;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ValueNotifier<bool> readonlyValue = ValueNotifier(true);
  @override
  void initState() {
    bloc = context.read<NotesBloc>();
    super.initState();
    bloc.descriptionController.clear();
    bloc.tittleController.clear();
    bloc.fetchNotesList();
    if(widget.data!=null){
      bloc.tittleController.text=widget.data?.title ?? "";
      bloc.descriptionController.text=widget.data?.description ?? "";
    }
    // bloc.tittleController.text=widget.data?.title ?? "";
    // bloc.descriptionController.text=widget.data?.description ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        Navigator.pop(context);
        // bloc.descriptionController.clear();
        // bloc.tittleController.clear();
        bloc.fetchNotesList();
        return false;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: 100,
                    width: 1.sw,
                    decoration: const BoxDecoration(
                        color: Color(0xFF009FE3),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20))
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 56,),
                        Text(
                          "Notes",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 56,
                    left: 10,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 15,
                        child: Icon(Icons.arrow_back, size: 18,),
                      ),
                    ),
                  ),
                ],
              ),
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          const SizedBox(
                            height: 50,
                          ),
                          if(widget.data!=null)Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Flexible(
                                child: Text(
                                  "Created By:${widget.data?.fName??""} ${widget.data?.mName??" "} ${widget.data?.lName??""}",
                                  style: const TextStyle(
                                      color: Colors.black54, fontSize: 10),
                                ),
                              )
                            ],
                          ),
                          ValueListenableBuilder(
                            valueListenable: readonlyValue,
                            builder: (context,bool isTrue,_) {
                              return TextFormField(
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                readOnly: widget.data==null?false:isTrue,
                                style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w700,),
                                controller: bloc.tittleController,
                                decoration: const InputDecoration(
                                  // filled: true,
                                  fillColor: Color(0xffffffff),
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  hintText: "Title",
                                  focusColor: Colors.white,
                                  counterStyle: TextStyle(color: Colors.white),
                                  hintStyle: TextStyle(
                                      color: Color(0xff777777),
                                      fontWeight: FontWeight.w700,
                                      fontFamily: "Poppins"),
                                ),
                                textAlign: TextAlign.left,
                                validator: (value) {
                                  if (value.toString().isEmpty) {
                                    return "Title is required";
                                  }
                                  return null;
                                },
                                onTap: () {},
                              );
                            }
                          ),
                          Text(
                            widget.data==null?"${DateFormat.yMMMMd().format(DateTime.now())}":"${widget.data?.updatedAt!=null?DateFormat.yMMMMd().format(DateTime.parse(widget.data?.updatedAt.toString()?? "")):""}",
                            textAlign: TextAlign.start,
                            style:
                                const TextStyle(color: Colors.black54, fontSize: 8),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          ValueListenableBuilder(
                            valueListenable: readonlyValue,
                            builder: (context,bool isTrue,_) {
                              return TextFormField(
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                readOnly: widget.data==null?false:isTrue,
                                controller: bloc.descriptionController,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                    color: Colors.black54),
                                decoration: const InputDecoration(
                                  // filled: true,
                                  fillColor: Color(0xffffffff),
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  hintText: "Description",
                                  focusColor: Colors.white,
                                  counterStyle: TextStyle(color: Colors.white),
                                  hintStyle: TextStyle(
                                      color: Color(0xff777777),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                      fontFamily: "Poppins"),
                                ),
                                validator: (value) {
                                  if (value.toString().isEmpty) {
                                    return "Title is required";
                                  }
                                  return null;
                                },
                                onTap: () {},
                              );
                            }
                          ),
                          const SizedBox(
                            height: 15,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
          floatingActionButton:Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if(widget.data==null)ValueListenableBuilder(
              valueListenable: bloc.isSubmit,
              builder: (context, bool submit,__) {
                if(submit){
                  return Container(
                      margin: EdgeInsets.only(right: 20),
                      child: CircularProgressIndicator()
                  );
                }
                return SizedBox(
                  height: 40,
                  width: 90,
                  child: FloatingActionButton.extended(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0))
                      ),
                      onPressed: () async{
                        if(formKey.currentState!.validate()){
                          await bloc.addNotes();
                          bloc.descriptionController.clear();
                          bloc.tittleController.clear();
                          bloc.fetchNotesList();
                          Navigator.pop(context);
                        }
                      },
                      backgroundColor: const Color(0xFF009FE3),
                      label: AnimatedSwitcher(
                        duration: const Duration(seconds: 1),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) =>
                                FadeTransition(
                          opacity: animation,
                          child: SizeTransition(
                            sizeFactor: animation,
                            axis: Axis.horizontal,
                            child: child,
                          ),
                        ),
                        child: const Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 5.0),
                              child: Icon(
                                Icons.save,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                            Text(
                              "Save",
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      )),
                );
              }
            ),
            if(widget.data!=null)ValueListenableBuilder(
              valueListenable: bloc.isEdit,
              builder: (context, bool edit,__) {
                if(edit){
                  return Container(
                      margin: EdgeInsets.only(right: 20),
                      child: CircularProgressIndicator()
                  );
                }
                return SizedBox(
                  height: 40,
                  width: 90,
                  child: ValueListenableBuilder(
                    valueListenable: readonlyValue,
                    builder: (context, bool isEdit,__) {
                      return FloatingActionButton.extended(
                          onPressed: ()  async{
                            readonlyValue.value = false;
                            if(formKey.currentState!.validate() && isEdit==false){
                               await bloc.editNotes(widget.data?.id??0);
                               bloc.fetchNotesList();
                               // Navigator.pop(context);
                              readonlyValue.value = true;
                            }
                          },
                          backgroundColor: const Color(0xFF009FE3),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5.0))
                          ),
                          label: AnimatedSwitcher(
                            duration: const Duration(seconds: 1),
                            transitionBuilder:
                                (Widget child, Animation<double> animation) =>
                                FadeTransition(
                                  opacity: animation,
                                  child: SizeTransition(
                                    sizeFactor: animation,
                                    axis: Axis.horizontal,
                                    child: child,
                                  ),
                                ),
                            child:  Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 5.0),
                                  child: Icon(
                                    isEdit?PhosphorIcons.eraser_bold:Icons.save,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                                Text(
                                  isEdit?"Edit":"Save",
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                          ));
                    }
                  ),
                );
              }
            ),
            SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}
