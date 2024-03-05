import 'package:animations/animations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:office/bloc/leads_bloc.dart';
import 'package:office/data/model/ClientDetail.dart';
import 'package:office/ui/leads/technology_modal.dart';
import 'package:office/ui/widget/app_button.dart';
import 'package:office/ui/widget/app_dropdown.dart';
import 'package:office/ui/widget/app_text_field.dart';
import 'package:office/ui/widget/profile_image_picker.dart';
import 'package:office/utils/constants.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:office/utils/message_handler.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateNewLeadPage extends StatefulWidget {
  const CreateNewLeadPage({Key? key}) : super(key: key);

  @override
  State<CreateNewLeadPage> createState() => _CreateNewLeadPageState();
}

class _CreateNewLeadPageState extends State<CreateNewLeadPage> {
  late final LeadsBloc bloc;
  List selectedData = [];
  final countryPicker = const FlCountryCodePicker(
    favorites: ["US", 'IN'],
    favoritesIcon: Icon(PhosphorIcons.push_pin_bold),
  );

  @override
  void initState() {
    bloc = context.read<LeadsBloc>();
    bloc.msgController?.stream.listen((event) {
      AppMessageHandler().showSnackBar(context, event);
    });
    super.initState();
    bloc.getLeadSourceData();
    bloc.getAllDesignationData();
    bloc.getAllDepartmentData();
    bloc.getAllClientsData();
    bloc.getTechnologyData();
    bloc.getPortfolioCategoryData();
    bloc.getAllCountryData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Create New Lead", style: TextStyle(
      //     color: Colors.black,
      //   ),),
      //   backgroundColor: K.themeColorSecondary,
      // ),
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
                          bottomRight: Radius.circular(20))),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 56,
                      ),
                      Text(
                        "Create New Lead",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
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
                      child: Icon(
                        Icons.arrow_back,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Form(
              key: bloc.formState,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        // ProfileImagePicker(
                        //   path: bloc.imageURL ?? bloc.image.value?.path,
                        //   onImageSelect: (v) {
                        //     if(v.isNotEmpty) {
                        //       bloc.image.value = File(v);
                        //     }
                        //   },
                        // ),
                        // const Positioned(
                        //   bottom: 5,
                        //   right: 0,
                        //   child: CircleAvatar(
                        //     radius: 13,
                        //     backgroundColor: K.themeColorPrimary,
                        //     child: CircleAvatar(
                        //       radius: 12,
                        //       backgroundColor: Colors.white,
                        //       child: Icon(PhosphorIcons.camera, size: 14, color: K.themeColorPrimary,),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // ValueListenableBuilder(
                    //   valueListenable: bloc.clients,
                    //   builder: (context, List<ClientDetail> clients, _) {
                    //     return AppDropdown(
                    //       value: bloc.clientId,
                    //       onChanged: (v) => bloc.updateClient(v!),
                    //       items: clients.map((e) => DropdownMenuItem(
                    //           value: '${e.id}',
                    //           child: Text('${e.name}'))).toList(),
                    //       hintText: 'Select Client',
                    //     );
                    //   },
                    // ),
                    // const SizedBox(height: 10),
                    AppTextField(
                      controller: bloc.title,
                      title: 'Lead Title',
                      showTitle: false,
                    ),
                    const SizedBox(height: 10),
                    ValueListenableBuilder(
                      valueListenable: bloc.allLeadSource,
                      builder: (context, allLeadSource, child) {
                        if(allLeadSource == null){
                          return AppDropdown(
                            items: [
                              DropdownMenuItem(child: Text("Select Source"),value: "",enabled: false,)
                            ],
                            onChanged: (value) {
                              bloc.source.value = value;
                            },
                            value: null,
                            hintText: "Select Source",
                          );
                        }
                      return AppDropdown(
                        items: allLeadSource.map((e) => DropdownMenuItem<String>(child: Text(e['name']),value: e['id'].toString(),)).toList(),
                        onChanged: (value) {
                        bloc.source.value = value.toString();
                      },
                        value: bloc.source.value,
                        hintText: "Select Source",
                      );
                    },),
                    const SizedBox(height: 10,),
                    AppTextField(
                      controller: bloc.remark,
                      title: 'Remark',
                      showTitle: false,
                    ),
                    const SizedBox(height: 10,),
                    AppDropdown(items: [
                      DropdownMenuItem(child: Text("Open"),value: "open",),
                      DropdownMenuItem(child: Text("Dead"),value: "dead",),
                      DropdownMenuItem(child: Text("Converted"),value: "converted",)
                    ], onChanged: (value) {
                      bloc.leadStatus.value = value;
                    },
                      value: bloc.leadStatus.value,
                      hintText: "Select Status",
                    ),
                    ValueListenableBuilder(
                      valueListenable: bloc.leadStatus,
                      builder: (context, status, child) {
                        if(status != "open"){
                          return Offstage();
                        }
                      return Column(
                        children: [
                          const SizedBox(height: 10),
                          InkWell(
                            onTap: () {
                              showDatePicker(context: context,
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(3000)).then((value) => value !=null ?bloc.nextFollowUp.text = value.toString().split(" ").first.split("-").reversed.join("-"): null);
                            },
                            child: AppTextField(
                              controller: bloc.nextFollowUp,
                              title: 'Next follow up date',
                              showTitle: false,
                              enabled: false,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      );
                    },),
                    const SizedBox(height: 10,),
                    AppDropdown(items: [
                      DropdownMenuItem(child: Text("On Product"),value: "1",),
                      DropdownMenuItem(child: Text("Offsite"),value: "0",)
                    ], onChanged: (value) {
                      bloc.forLead.value = value;
                    },
                      value: bloc.forLead.value,
                      hintText: "Lead for",
                    ),
                    ValueListenableBuilder(
                      valueListenable: bloc.forLead,
                      builder: (context, forLead, child) {
                        if(forLead == "1") {
                          return Column(
                            children: [
                              const SizedBox(height: 10,),
                              ValueListenableBuilder(
                                valueListenable: bloc.allPortfolioCategory,
                                builder: (context, allPortfolioCat, child) {
                                  if(allPortfolioCat == null){
                                    return AppDropdown(
                                      items: [
                                      ],
                                      onChanged: (value) {
                                        bloc.portfolioCat.value = value;
                                      },
                                      value: null,
                                      hintText: "Portfolio Category",
                                    );
                                  }
                                  return AppDropdown(
                                    items: allPortfolioCat.map((e) => DropdownMenuItem<String>(child: Text(e['name']),value: e['id'].toString(),)).toList(),
                                    onChanged: (value) {
                                      bloc.portfolioCat.value = value.toString();
                                    },
                                    value: bloc.portfolioCat.value,
                                    hintText: "Portfolio Category",
                                  );
                                },),
                            ],
                          );
                        }
                        return Offstage();
                    },),
                    const SizedBox(height: 10,),
                    ValueListenableBuilder(
                      valueListenable: bloc.allDesignationData,
                      builder: (context, allDesignationData, child) {
                        if(allDesignationData == null){
                          return AppDropdown(
                            items: [
                            ],
                            onChanged: (value) {
                              bloc.designation.value = value;
                            },
                            value: null,
                            hintText: "Select Designation",
                          );
                        }
                        return AppDropdown(
                          items: allDesignationData.map((e) => DropdownMenuItem<String>(child: Text(e['name']),value: e['id'].toString(),)).toList(),
                          onChanged: (value) {
                            bloc.designation.value = value.toString();
                          },
                          value: bloc.designation.value,
                          hintText: "Select Designation",
                        );
                      },),
                    const SizedBox(height: 10,),
                    ValueListenableBuilder(
                      valueListenable: bloc.allDepartmentData,
                      builder: (context, allDepartmentData, child) {
                        if(allDepartmentData == null){
                          return AppDropdown(
                            items: [
                            ],
                            onChanged: (value) {
                              bloc.yourDepartment.value = value;
                            },
                            value: bloc.yourDepartment.value,
                            hintText: "Select Department",
                          );
                        }
                        return AppDropdown(
                          items: allDepartmentData.map((e) => DropdownMenuItem<String>(child: Text(e['name']),value: e['id'].toString(),)).toList(),
                          onChanged: (value) {
                            bloc.yourDepartment.value = value.toString();
                          },
                          value: bloc.yourDepartment.value,
                          hintText: "Select Department",
                        );
                      },),
                    const SizedBox(height: 10),
                    AppTextField(
                      controller: bloc.requirements,
                      maxLines: 5,
                      title: 'Requirements',
                      showTitle: false,
                    ),
                    const SizedBox(height: 10,),
                    AppDropdown(
                      items: [
                        DropdownMenuItem(child: Text("Yes"),value: "1",),
                        DropdownMenuItem(child: Text("No"),value: "0",)
                    ], onChanged: (value) {
                      bloc.alreadyClient.value = value;
                    },
                      value: bloc.alreadyClient.value,
                      hintText: "Already a client",
                    ),
                    ValueListenableBuilder(
                      valueListenable: bloc.alreadyClient,
                      builder: (context, alreadyClient, child) {
                        if(alreadyClient == "1"){
                          return Column(
                            children: [
                              const SizedBox(height: 10,),
                              ValueListenableBuilder(
                                valueListenable: bloc.allClientData,
                                builder: (context, allClientData, child) {
                                  if(allClientData == null){
                                    return AppDropdown(
                                      items: [
                                      ],
                                      onChanged: (value) {
                                        bloc.selectClient.value = value;
                                      },
                                      value: bloc.selectClient.value,
                                      hintText: "Select Client",
                                    );
                                  }
                                  return AppDropdown(
                                    items: allClientData.map((e) => DropdownMenuItem<String>(child: Text("${e['sarname'] ?? ''} ${e['first_name'] ?? ''} ${e['middle_name'] ?? ''} ${e['last_name'] ?? ''}"),value: e['id'].toString(),)).toList(),
                                    onChanged: (value) {
                                      bloc.selectClient.value = value.toString();
                                    },
                                    value: bloc.selectClient.value,
                                    hintText: "Select Client",
                                  );
                                },),
                            ],
                          );
                        }else if(alreadyClient == "0"){
                          return Column(
                            children: [
                              const SizedBox(height: 10,),
                              AppTextField(
                                controller: bloc.firstName,
                                title: 'First Name',
                                showTitle: false,
                              ),
                              const SizedBox(height: 10),
                              AppTextField(
                                controller: bloc.middleName,
                                title: 'Middle name',
                                showTitle: false,
                              ),
                              const SizedBox(height: 10),
                              AppTextField(
                                controller: bloc.lastName,
                                title: 'Last name',
                                showTitle: false,
                              ),
                              const SizedBox(height: 10),
                              AppTextField(
                                controller: bloc.email,
                                title: 'Email',
                                showTitle: false,
                              ),
                              const SizedBox(height: 10),
                              AppTextField(
                                controller: bloc.alternateEmail,
                                title: 'Alternate Email',
                                showTitle: false,
                              ),
                              const SizedBox(height: 10),
                              AppTextField(
                                controller: bloc.phone,
                                title: 'Phone',
                                showTitle: false,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(10)
                                ],
                                keyboardType: TextInputType.number,
                              ),
                              const SizedBox(height: 10),
                              AppTextField(
                                controller: bloc.alternatePhone,
                                title: 'Alternate Phone',
                                showTitle: false,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(10)
                                ],
                                keyboardType: TextInputType.number,
                              ),
                              const SizedBox(height: 10),
                              AppDropdown(
                                items: [
                                  DropdownMenuItem(child: Text("Male"),value: "male",),
                                  DropdownMenuItem(child: Text("Female"),value: "female",),
                                  DropdownMenuItem(child: Text("Other"),value: "other",),
                                ], onChanged: (value) {
                                bloc.clientGender.value = value;
                              },
                                value: bloc.clientGender.value,
                                hintText: "Select Gender",
                              ),
                              const SizedBox(height: 10),
                              AppTextField(
                                controller: bloc.address,
                                title: 'Address',
                                showTitle: false,
                              ),
                              const SizedBox(height: 10),
                              ValueListenableBuilder(
                                valueListenable: bloc.allCountryData,
                                builder: (context, allCountryData, child) {
                                  if(allCountryData == null){
                                    return AppDropdown(
                                      items: [],
                                      onChanged: (value) {},
                                      value: null,
                                      hintText: "Select Country",
                                    );
                                  }
                                  return AppDropdown(
                                    items: allCountryData.map((e) => DropdownMenuItem<String>(child: Text(e['name']),value: e['id'].toString(),)).toList(),
                                    onChanged: (value) {
                                      bloc.country.value = value.toString();
                                      bloc.getAllStateData(value.toString());
                                    },
                                    value: bloc.country.value,
                                    hintText: "Select Country"
                                  );
                                },),
                              const SizedBox(height: 10),
                              ValueListenableBuilder(
                                valueListenable: bloc.allStateData,
                                builder: (context, allStateData, child) {
                                  if(allStateData == null){
                                    return AppDropdown(
                                      items: [],
                                      onChanged: (value) {},
                                      value: null,
                                      hintText: "Select State",
                                    );
                                  }
                                  return AppDropdown(
                                      items: allStateData.map((e) => DropdownMenuItem<String>(child: Text(e['name']),value: e['id'].toString(),)).toList(),
                                      onChanged: (value) {
                                        bloc.countryState.value = value.toString();
                                        bloc.getAllCityData(bloc.country.value! ,value.toString());
                                      },
                                      value: bloc.countryState.value,
                                      hintText: "Select State"
                                  );
                                },),
                              const SizedBox(height: 10),
                              ValueListenableBuilder(
                                valueListenable: bloc.allCityData,
                                builder: (context, allCityData, child) {
                                  if(allCityData == null){
                                    return AppDropdown(
                                      items: [],
                                      onChanged: (value) {},
                                      value: null,
                                      hintText: "Select City",
                                    );
                                  }
                                  return AppDropdown(
                                      items: allCityData!.map((e) => DropdownMenuItem<String>(child: Text(e['name']),value: e['id'].toString(),)).toList(),
                                      onChanged: (value) {
                                        bloc.city.value = value.toString();
                                      },
                                      value: bloc.city.value,
                                      hintText: "Select City"
                                  );
                                },),
                              const SizedBox(height: 10),
                              AppTextField(
                                controller: bloc.pincode,
                                title: 'Pincode',
                                showTitle: false,
                                keyboardType: TextInputType.number,
                              ),
                              const SizedBox(height: 10),
                              AppDropdown(
                                items: [
                                  DropdownMenuItem(child: Text("Aarvy Technologies"),value: "Aarvy Technologies",)
                                ], onChanged: (value) {
                                bloc.companyName.value = value;
                              },
                                value: bloc.companyName.value,
                                hintText: "Select Company",
                              ),
                            ],
                          );
                        }
                        return Offstage();
                    },),
                    const SizedBox(height: 10),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Select Technology",style: GoogleFonts.dmSans(fontWeight: FontWeight.w500),)),
                    const SizedBox(height: 5),
                    ValueListenableBuilder(
                      valueListenable: bloc.allTechnologyData,
                      builder: (context, List? allTechnologyData, child) {
                        if(allTechnologyData == null){
                          return Align(
                            alignment: Alignment.centerLeft,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(minHeight: 50),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Wrap(
                                      spacing: 5,
                                      children: [],
                                    ),
                                    InkWell(
                                      onTap: () {
                                        showDialog(
                                          barrierDismissible: true,
                                          context: context,
                                          builder: (context) {
                                            return Padding(
                                              padding: const EdgeInsets.all(50.0),
                                              child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(10),
                                                  child: TechnologyModal(allData: [],leadsBloc: bloc,)),
                                            );
                                          },);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 5.0),
                                        child: Text("Select",style: GoogleFonts.lato(color: Colors.grey),),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(minHeight: 50),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: ValueListenableBuilder(
                                    valueListenable: bloc.preferenceTechnology,
                                    builder: (context, technology, child) {
                                      selectedData = technology;
                                    return Wrap(
                                      spacing: 5,
                                      children: bloc.preferenceTechnology.value.map((e) =>
                                          Chip(label: Text(e['name']),onDeleted: () {
                                            bloc.preferenceTechnology.value.remove(e);
                                            selectedData.remove(e);
                                            setState(() { });
                                          },
                                            deleteIconColor: Colors.red.shade800,
                                          ),).toList(),
                                    );
                                  },),
                                ),
                                InkWell(
                                    onTap: () {
                                      showDialog(
                                        barrierDismissible: true,
                                        context: context,
                                        builder: (context) {
                                        return Padding(
                                          padding: const EdgeInsets.all(50.0),
                                          child: ClipRRect(
                                              borderRadius: BorderRadius.circular(10),
                                              child: TechnologyModal(allData: allTechnologyData,leadsBloc: bloc,)),
                                        );
                                      },);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 5.0),
                                      child: Text("Select",style: GoogleFonts.lato(color: Colors.grey),),
                                    ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },),
                    const SizedBox(height: 10),
                    AppTextField(
                      controller: bloc.probabilityConversion,
                      title: 'Probability Conversion',
                      showTitle: false,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: () {
                        showDatePicker(context: context,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(3000)).then((value) => value !=null ?bloc.lastFollowUp.text = value.toString().split(" ").first.split("-").reversed.join("-"): null);
                      },
                      child: AppTextField(
                        controller: bloc.lastFollowUp,
                        title: 'Last follow up date',
                        showTitle: false,
                        enabled: false,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ValueListenableBuilder(
                      valueListenable: bloc.creating,
                      builder: (context, bool loading, _) {
                        return AppButton(
                          title: 'Submit',
                          onTap: () {
                            if(bloc.formState.currentState!.validate()){
                              bloc.createNewEmployee(context);
                            }
                          },
                          margin: EdgeInsets.zero,
                          loading: loading,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
