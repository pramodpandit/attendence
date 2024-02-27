import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:office/bloc/leads_bloc.dart';
import 'package:office/data/repository/lead_repository.dart';
import 'package:provider/provider.dart';
import '../../../bloc/profile_bloc.dart';
import '../../../bloc/project_bloc.dart';
import '../../../data/model/user.dart';
import '../../../data/repository/profile_repo.dart';
import '../../../data/repository/project_repo.dart';
import '../../profile/menus/basic_info.dart';

class LeadOverview extends StatefulWidget {
  final data;
  const LeadOverview({Key? key,required this.data}) : super(key: key);

  @override
  State<LeadOverview> createState() => _LeadOverviewState();
}

class _LeadOverviewState extends State<LeadOverview> {
  _LeadOverviewState();

  late LeadsBloc bloc;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc = LeadsBloc(context.read<LeadsRepository>());
    bloc.getSpecificLeadData(widget.data.toString(),"user");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30,),
          ValueListenableBuilder(
            valueListenable: bloc.specificLeadData,
            builder: (context, specificLeadData, child) {
              if(specificLeadData ==null){
                return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: Center(child: CircularProgressIndicator()));
              }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  DetailsContainer(title: "${specificLeadData[0]['requirements']}", isHtml: true, heading: "Requirements"),
                  DetailsContainer(title: "${specificLeadData[0]['sourcename']}", isHtml: false, heading: "Source"),
                  DetailsContainer(title: "${specificLeadData[0]['dep_name']}", isHtml: false, heading: "Department"),
                  DetailsContainer(title: "${specificLeadData[0]['lead_for_status']}", isHtml: false, heading: "Lead For"),
                  Divider(),
                  DetailsContainer(title: "${specificLeadData[0]['clientsurname'] ?? ''} ${specificLeadData[0]['clientfirstname'] ?? ''} ${specificLeadData[0]['clientmiddlename'] ?? ''} ${specificLeadData[0]['clientlastname'] ?? ''}", isHtml: false, heading: "Client Name"),
                  DetailsContainer(title: "${specificLeadData[0]['clientemail'] ?? ''}", isHtml: false, heading: "Email"),
                  DetailsContainer(title: "${specificLeadData[0]['clientphone'] ?? ''}", isHtml: false, heading: "Phone"),
                  DetailsContainer(title: "${specificLeadData[0]['clientaddress'] ?? ''}", isHtml: true, heading: "Address"),
                ],
              ),
            );
          },)
          ],
        ),
      ),
    );
  }
}
