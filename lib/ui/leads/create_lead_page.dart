import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:office/bloc/leads_bloc.dart';
import 'package:office/data/model/ClientDetail.dart';
import 'package:office/ui/widget/app_button.dart';
import 'package:office/ui/widget/app_dropdown.dart';
import 'package:office/ui/widget/app_text_field.dart';
import 'package:office/ui/widget/profile_image_picker.dart';
import 'package:office/utils/constants.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
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
  final countryPicker = const FlCountryCodePicker(
    favorites: ["US", 'IN'],
    favoritesIcon: Icon(PhosphorIcons.push_pin_bold),
  );

  @override
  void initState() {
    bloc = context.read<LeadsBloc>();
    super.initState();
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
      body: Column(
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
          SingleChildScrollView(
            child: Form(
              key: bloc.formState,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        ProfileImagePicker(
                          path: bloc.imageURL ?? bloc.image.value?.path,
                          onImageSelect: (v) {
                            if(v.isNotEmpty) {
                              bloc.image.value = File(v);
                            }
                          },
                        ),
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
                      controller: bloc.name,
                      title: 'Name',
                      showTitle: false,
                      validate: true,
                    ),
                    const SizedBox(height: 10),
                    AppTextField(
                      controller: bloc.phone,
                      title: 'Number',
                      showTitle: false,
                      validate: true,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(10),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 10),
                    AppTextField(
                      controller: bloc.phone2,
                      title: 'Phone number 2',
                      showTitle: false,
                      // validate: true,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(10),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 10),
                    AppTextField(
                      controller: bloc.requirement,
                      title: 'Lead requirement',
                      showTitle: false,
                      validate: true,
                    ),
                    const SizedBox(height: 10),
                    // Consumer<SharedPreferences>(
                    //   builder: (context, pref, _) {
                    //     bool isAdmin = pref.getBool('isAdmin')==true;
                    //     if(isAdmin) {
                    //       return Column(
                    //         children: [
                    //           ValueListenableBuilder(
                    //             valueListenable: bloc.employees,
                    //             builder: (context, List<UserDetail> employees, _) {
                    //               return AppDropdown(
                    //                 value: bloc.selectedEmpId,
                    //                 onChanged: (v) => bloc.updateEmployee(v!),
                    //                 items: employees.map((e) => DropdownMenuItem(
                    //                     value: '${e.id}',
                    //                     child: Text('${e.name}'))).toList(),
                    //                 hintText: 'Select Employee',
                    //               );
                    //             },
                    //           ),
                    //           const SizedBox(height: 10),
                    //         ],
                    //       );
                    //     }
                    //     return const SizedBox(height: 0);
                    //   }
                    // ),
                    AppTextField(
                      controller: bloc.email,
                      title: 'Email',
                      showTitle: false,
                      validate: true,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) => v!.isEmpty ? null : !Validate.emailValidation.hasMatch(v) ? "Please enter valid email" : null,
                    ),
                    const SizedBox(height: 10),
                    ValueListenableBuilder(
                      valueListenable: bloc.creating,
                      builder: (context, bool loading, _) {
                        return AppButton(
                          title: 'Submit',
                          onTap: () {
                            bloc.createNewEmployee();
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
          ),
        ],
      ),
    );
  }
}
