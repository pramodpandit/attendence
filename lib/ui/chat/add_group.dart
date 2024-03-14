import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:office/bloc/profile_bloc.dart';
import 'package:office/data/repository/profile_repo.dart';
import 'package:office/ui/widget/app_button.dart';
import 'package:office/ui/widget/app_dropdown.dart';
import 'package:office/ui/widget/app_text_field.dart';
import 'package:provider/provider.dart';

class AddGroup extends StatefulWidget {
  const AddGroup({super.key});

  @override
  State<AddGroup> createState() => _AddGroupState();
}

class _AddGroupState extends State<AddGroup> {
  late ProfileBloc bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc = ProfileBloc(context.read<ProfileRepository>());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        bottomRight: Radius.circular(20))
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 56,),
                    Text(
                      "Add Expenses",
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

            ],
          ),
          Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            SizedBox(width: 10),
                            Text("Expense type"),
                            Text("*",style: TextStyle(color: Colors.red),)
                          ],
                        ),
                        const SizedBox(height: 10),
                        AppDropdown(
                          items: [],
                          onChanged: (value) {

                          },
                          value: null,
                          hintText: "Expense type",
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Row(
                          children: [
                            SizedBox(width: 10),
                            Text("Select Date"),
                            Text("*",style: TextStyle(color: Colors.red),)
                          ],
                        ),
                        const SizedBox(height: 10),
                        InkWell(
                          onTap: () async {
                            await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(3000),
                            ).then((value) {
                              if(value != null){
                                // widget.bloc.date.value = value.toString().split(" ").first;
                              }
                            });
                          },
                          child: Container(
                            height: 50,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              children: [
                                Icon(PhosphorIcons.clock),
                                SizedBox(width: 15),
                                Text(
                                  "Select Date",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        AppTextField(
                          controller: TextEditingController(),
                          title: "Description",
                          validate: true,
                          maxLines: 5,
                          inputAction: TextInputAction.done,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        AppTextField(
                          controller: TextEditingController(),
                          title: "Amount",
                          validate: true,
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        AppButton(
                          title: "Submit",
                          loading: false,
                          onTap: () {
                            // if (widget.bloc.formKey.currentState!.validate()) {
                            //   widget.bloc.addExpense(context);
                            // }
                          },
                          margin: EdgeInsets.zero,
                          // loading: loading,
                        )
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
