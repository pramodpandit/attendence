import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:office/bloc/leads_bloc.dart';
import 'package:provider/provider.dart';

class TechnologyModal extends StatefulWidget {
  List allData;
  LeadsBloc leadsBloc;
  TechnologyModal({super.key,required this.allData,required this.leadsBloc});

  @override
  State<TechnologyModal> createState() => _TechnologyModalState();
}

class _TechnologyModalState extends State<TechnologyModal> {
  List selectData = [];
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectData.addAll(widget.leadsBloc.preferenceTechnology.value);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          10.height,
          Text("Select Technology",style: GoogleFonts.dmSans(fontSize: 18,fontWeight: FontWeight.bold),),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: widget.allData.map<Widget>((e) =>CheckboxListTile(
                      title: Text(e['name']),
                      value: widget.leadsBloc.preferenceTechnology.value.contains(e),
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (value) {
                        if(!widget.leadsBloc.preferenceTechnology.value.contains(e)){
                          selectData.add(e);
                          widget.leadsBloc.preferenceTechnology.value.add(e);
                        }else{
                          selectData.remove(e);
                          widget.leadsBloc.preferenceTechnology.value.remove(e);
                        }
                        setState(() { });
                      },
                    )
                ).toList(),
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(onPressed: () {
                widget.leadsBloc.preferenceTechnology.value = [];
                Navigator.of(context).pop();
              }, child: Text("Cancel")),
              TextButton(onPressed: () {
                widget.leadsBloc.preferenceTechnology.value = selectData;
                Navigator.of(context).pop();
              }, child: Text("Select")),
              10.width,
            ],
          )
        ],
      ),
    );
  }
}
