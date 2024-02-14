import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:office/bloc/leads_bloc.dart';
import 'package:office/ui/widget/app_bar.dart';
import 'package:provider/provider.dart';

import '../../utils/constants.dart';
import '../widget/app_button.dart';
import '../widget/app_dropdown.dart';
import '../widget/app_text_field.dart';

class AddLead extends StatefulWidget {
  const AddLead({Key? key}) : super(key: key);

  @override
  State<AddLead> createState() => _AddLeadState();
}

class _AddLeadState extends State<AddLead> {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late LeadsBloc bloc;
  @override
  void initState() {
    bloc = context.read<LeadsBloc>();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
                  "Add Lead",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18
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
          Column(
            children: [
              const SizedBox(height: 100,),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 40),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppTextField(
                            controller: bloc.leadTitleController,
                            title: "Lead Title",
                            validate: true,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Row(
                              children: [
                                Text("Source", style: TextStyle(fontSize: 13)),
                                Text("*", style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),)
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          AppDropdown(
                            items: bloc.leadSource.map((e) => DropdownMenuItem(value: '${e.id}', child: Text("${e.name}"))
                            ).toList(),
                            onChanged: (v) {bloc.updateLC(v);},
                            value: bloc.selectedLeadSource,
                            hintText: "Choose Source",
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          AppTextField(
                            controller: bloc.remarkController,
                            title: "Remark",
                            validate: true,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Row(
                              children: [
                                Text("Status", style: TextStyle(fontSize: 13)),
                                Text("*", style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),)
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          DropdownButtonFormField<String>(
                            icon: const Icon(
                              Icons.keyboard_arrow_down_sharp,
                              color: Colors.grey,
                            ),
                            iconSize: 24,
                            elevation: 16,
                            style: const TextStyle(color: Colors.black, fontSize: 15),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey[200],
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Color(0xffF4F5F7)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Color(0xffF2F2F2)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 10),
                              hintText: "Select",
                              hintStyle:
                               TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 15,fontWeight: FontWeight.w500),
                            ),
                            onChanged: (String? data) {
                              bloc.selectStatus(data!);
                            },
                            items: bloc.status.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value,style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w500),),
                              );
                            }).toList(),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Row(
                              children: [
                                Text("Lead For", style: TextStyle(fontSize: 13)),
                                Text("*", style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),)
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          AppDropdown(
                            items: bloc.leadForList.map((e) => DropdownMenuItem(value: '${e.id}', child: Text(e.name??""))
                            ).toList(),
                            onChanged: (v) {bloc.updateLeadFor(v);},
                            value: bloc.selectedLeadFor,
                            hintText: "Select",
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Row(
                              children: [
                                Text("Department", style: TextStyle(fontSize: 13)),
                                Text("*", style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),)
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          AppDropdown(
                            items: bloc.departmentList.map((e) => DropdownMenuItem(value: '${e.id}', child: Text(e.name??""))
                            ).toList(),
                            onChanged: (v) {bloc.updateDepartment(v);},
                            value: bloc.selectedDepartment,
                            hintText: "Choose Designation",
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Row(
                              children: [
                                Text("Manage By", style: TextStyle(fontSize: 13)),
                                Text("*", style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),)
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          AppDropdown(
                            items: bloc.manageBy.map((e) => DropdownMenuItem(value: '${e.id}', child: Text("${e.firstName??""} ${e.middleName??""}${e.lastName??""}"))
                            ).toList(),
                            onChanged: (v) {bloc.updateMB(v);},
                            value: bloc.selectedManageBy,
                            hintText: "Manage By",
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          AppTextField(
                            controller: bloc.requirementsController,
                            title: "Requirements",
                            validate: true,
                            maxLines: 4,
                            keyboardType: TextInputType.text,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          AppTextField(
                            controller: bloc.nameController,
                            title: "Name",
                            validate: false,
                            keyboardType: TextInputType.name,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          AppTextField(
                            controller: bloc.emailController,
                            title: "Email",
                            validate: false,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          AppTextField(
                            controller: bloc.alternativeEmailController,
                            title: "Alternate Email",
                              validate: false,
                              keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          AppTextField(
                            controller: bloc.phoneController,
                            title: "Phone",
                            validate: false,
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          AppTextField(
                            controller: bloc.alternativePhoneController,
                            title: "Alternate Phone",
                            validate: false,
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text("Gender", style: TextStyle(fontSize: 13)),
                          ),
                          const SizedBox(height: 5),
                          DropdownButtonFormField<String>(
                            icon: const Icon(
                              Icons.keyboard_arrow_down_sharp,
                              color: Colors.grey,
                            ),
                            iconSize: 24,
                            elevation: 16,
                            style: const TextStyle(color: Colors.black, fontSize: 15),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey[200],
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Color(0xffF4F5F7)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Color(0xffF2F2F2)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 10),
                              hintText: "Gender",
                              hintStyle:
                               TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 15,fontWeight: FontWeight.w500),
                            ),
                            onChanged: (String? data) {
                              bloc.selectGender(data!);
                            },
                            items: bloc.gender.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value,style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w500),),
                              );
                            }).toList(),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          AppTextField(
                            controller: bloc.addressController,
                            title: "Address",
                            validate: false,
                            maxLines: 4,
                            inputAction: TextInputAction.done,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          AppTextField(
                            controller: bloc.companyNameController,
                            title: "Company Name",
                            validate: false,
                           keyboardType: TextInputType.text,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text("Preference Technology", style: TextStyle(fontSize: 13)),
                          ),
                          const SizedBox(height: 5),
                          AppDropdown(
                            items: bloc.technologyList.map((e) => DropdownMenuItem(value: '${e.id}', child: Text("${e.name}"))
                            ).toList(),
                            onChanged: (v) {bloc.updateTechnology(v);},
                            value: bloc.selectedTechnology,
                            hintText: "Choose Technology",
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          AppTextField(
                            controller: bloc.probabilityConversionController,
                            title: "Probability Conversion",
                            validate: false,
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text("Last Followup", style: TextStyle(fontSize: 13)),
                          ),
                          const SizedBox(height: 5),
                          ValueListenableBuilder(
                              valueListenable: bloc.lastFollowup,
                              builder: (context, DateTime? date, _) {
                                return InkWell(
                                  onTap: () async {
                                    DateTime? dt = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now().subtract(Duration(days: 15)), lastDate:  DateTime.now().add(Duration(days: 30)),);
                                    if(dt!=null) {
                                      await bloc.updateLastFollowup(dt);
                                    }
                                  },
                                  child: Container(
                                    height: 50,
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(PhosphorIcons.clock),
                                        const SizedBox(width: 15),
                                        Text(date==null ?  DateFormat('MMM dd, yyyy').format(DateTime.now()) : DateFormat('MMM dd, yyyy').format(date), style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),),
                                      ],
                                    ),
                                  ),
                                );
                              }
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          AppButton(
                            title: "Submit",
                            onTap: () {
                              if (formKey.currentState!.validate()) {
                                // bloc.addComplaint();
                              }
                            },
                            margin: EdgeInsets.zero,
                            // loading: loading,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
