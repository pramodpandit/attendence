import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:office/bloc/notes_bloc.dart';
import 'package:office/data/model/notes_model.dart';
import 'package:office/data/repository/notes_repo.dart';
import 'package:office/ui/notes/notes_details.dart';
import 'package:office/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotesList extends StatefulWidget {
  const NotesList({Key? key}) : super(key: key);

  @override
  State<NotesList> createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  late NotesBloc bloc;
  late List<NotesModel>? data;
  @override
  void initState() {
    bloc = NotesBloc(context.read<NotesRepository>());
    super.initState();
    datas();
  }
  datas()async{
    data=await bloc.fetchNotesList();
  }
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      displacement: 200,
      backgroundColor: Colors.white,
      color: K.themeColorPrimary,
      strokeWidth: 3,
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      onRefresh: () async {
        await bloc.fetchNotesList();
      },
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            ValueListenableBuilder(
              valueListenable: bloc.loading,
              builder: (context, bool loading,__) {
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
                return ValueListenableBuilder(
                  valueListenable: bloc.notes,
                  builder: (context, List<NotesModel>? notes, __) {
                    if (notes == null) {
                      return const Center(
                        child: Text("User Details Not Found!"),
                      );
                    }
                    return Expanded(
                      child: ListView.builder(
                        physics: const ScrollPhysics(),
                          itemCount: notes.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            data?[index] = notes[index];
                            // print(data?[index].title);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      Provider.value(
                                        value: bloc,
                                        child:  NotesDetails(data: notes[index]),
                                      ),
                                )
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Container(
                             padding: const EdgeInsets.symmetric(horizontal: 10),
                              margin: const EdgeInsets.only(bottom: 20),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      blurRadius: 3,
                                      spreadRadius: 2)
                                ],
                                color: Colors.white,
                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                              ),
                              child:  Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 5,),
                                   Row(
                                     mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Flexible(
                                        child: Text(
                                            "Created By:${"${notes[index].fName??""} ${notes[index].mName??" "} ${notes[index].lName??""}"}",
                                          style: const TextStyle(
                                            color: Colors.black54,
                                            fontSize: 10
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Text(
                                        notes[index].title??"",
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                   Text(
                                       notes[index].createdAt!=null?DateFormat.yMMMMd().format(
                                           DateTime.parse(notes[index]
                                               .createdAt
                                               .toString() ??
                                               "")):"",
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontSize: 8
                                    ),
                                  ),
                                  const SizedBox(height: 5,),
                                  Html(
                                    // data:"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                                    data:notes[index].description!.length>250?"${notes[index].description!.substring(0,250)}......." :notes[index].description?? "",
                                    style: {
                                      "body": Style(
                                          color: Colors.black54,
                                          fontWeight:
                                          FontWeight.w500,
                                          fontFamily: "Poppins",
                                          display: Display.inline,
                                          fontSize: FontSize(11),
                                          textAlign: TextAlign.start
                                      ),
                                      "p": Style(
                                          color: Colors.black54,
                                          fontWeight:
                                          FontWeight.w500,
                                          // padding: EdgeInsets.zero,
                                          fontFamily: "Poppins",
                                          display: Display.inline,
                                          fontSize: FontSize(11),
                                          textAlign: TextAlign.start
                                      ),
                                    },
                                  ),
                                  const SizedBox(height: 15,)
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    );
                  }
                );
              }
            )
          ],
        ),
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: 40,
                width: 90,
                child: FloatingActionButton.extended(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0))
                    ),
                    onPressed: () async{
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => Provider.value(
                              value: bloc,
                              child:  NotesDetails(data: null,),
                            )),
                      );
                    },
                    backgroundColor: const  Color(0xFF009FE3),
                    label: AnimatedSwitcher(
                      duration: const Duration(seconds: 1),
                      transitionBuilder: (Widget child, Animation<double> animation) =>
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
                              PhosphorIcons.plus_circle_fill,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "Notes",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    )),
              ),
              SizedBox(height: 30,)
            ],
          ),
      ),
    );
  }
}
