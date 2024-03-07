import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:office/bloc/leads_bloc.dart';
import 'package:office/ui/widget/app_dropdown.dart';
import 'package:office/ui/widget/custom_button.dart';
import 'package:provider/provider.dart';
import '../../../../bloc/project_bloc.dart';
import '../../../../data/repository/lead_repository.dart';

class AddLeadBranch extends StatefulWidget {
  final int leadId;
  final  LeadsBloc bloc;
  const AddLeadBranch({Key? key, required this.leadId, required this.bloc,}) : super(key: key);
  @override
  State<AddLeadBranch> createState() => _AddLeadBranchState();
}

class _AddLeadBranchState extends State<AddLeadBranch> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool light = false;
  final MultiSelectController _controller = MultiSelectController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.bloc.cname.text ='';
    widget.bloc.c_phone.text ='';
    widget.bloc.c_email.text ='';
    widget.bloc.cp_email.text ='';
    widget.bloc.c_address.text ='';
    widget.bloc.cp_mobile.text ='';
    widget.bloc.cp_location.text ='';
    widget.bloc.cp_name.text ='';
  }
    var emailcp;
     var email;
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
                    bottomRight: Radius.circular(20))),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 56,
                ),
                Text(
                  "Add Branch",
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
          Column(
            children: [
              const SizedBox(
                height: 100,
              ),
              Expanded(
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 25),
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                    
                          Row(
                            children: [
                              const Text(
                                "Branch Name",
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  // color: ,
                                  fontSize: 13,
                                ),
                              ),
                              Text("*", style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),)
                            ],
                          ),
                          TextFormField(
                            style: const TextStyle(color: Colors.black),
                            textCapitalization: TextCapitalization.sentences,
                            controller: widget.bloc.cname,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xffffffff),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.red.withOpacity(1)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.red.withOpacity(1)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              contentPadding: const EdgeInsets.all(17.0),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: const Color(0xff777777)
                                        .withOpacity(0.8)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                    const Color(0xff777777).withOpacity(1)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              hintText: "Name",
                              focusColor: Colors.white,
                              counterStyle:
                              const TextStyle(color: Colors.white),
                              hintStyle: const TextStyle(
                                  color: Color(0xff777777),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Poppins"),
                            ),
                            validator: (value) {
                              if (value.toString().isEmpty) {
                                return "Name is required";
                              }
                              return null;
                            },
                            onTap: () {},
                          ),
                          10.height,
                          Row(
                            children: [
                              const Text(
                                "Phone Number",
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  // color: ,
                                  fontSize: 13,

                                ),
                              ),
                              Text("*", style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),)
                            ],
                          ),
                          TextFormField(
                            textCapitalization: TextCapitalization.sentences,
                            style: const TextStyle(color: Colors.black),
                            controller: widget.bloc.c_phone,
                            maxLength: 10,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xffffffff),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.red.withOpacity(1)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.red.withOpacity(1)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              contentPadding: const EdgeInsets.all(17.0),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: const Color(0xff777777)
                                        .withOpacity(0.8)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                    const Color(0xff777777).withOpacity(1)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              hintText: "Phone number",
                              focusColor: Colors.white,
                              counterStyle:
                              const TextStyle(color: Colors.white),
                              hintStyle: const TextStyle(
                                  color: Color(0xff777777),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Poppins"),
                            ),
                            validator: (value) {
                              if (value.toString().isEmpty) {
                                return "Phone Number is required";
                              }else if(value.toString().length < 10){
                                return 'Mobile number must be 10 digit';
                              }
                              return null;
                            },
                            onTap: () {},
                          ),
                          Row(
                            children: [
                              const Text(
                                "Email",
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  // color: ,
                                  fontSize: 13,
                                ),
                              ),
                              Text("*", style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),)
                            ],
                          ),
                          TextFormField(
                            style: const TextStyle(color: Colors.black),
                            keyboardType: TextInputType.emailAddress,
                            controller: widget.bloc.c_email,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xffffffff),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.red.withOpacity(1)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.red.withOpacity(1)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              contentPadding: const EdgeInsets.all(17.0),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: const Color(0xff777777)
                                        .withOpacity(0.8)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                    const Color(0xff777777).withOpacity(1)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              hintText: "Email",
                              focusColor: Colors.white,
                              counterStyle:
                              const TextStyle(color: Colors.white),
                              hintStyle: const TextStyle(
                                  color: Color(0xff777777),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Poppins"),
                            ),
                            validator: (value) {
                              if (value.toString().isEmpty) {
                                return "Email is required";
                              }else if(email==false){
                                return 'Please enter valid email';
                              }
                              return null;
                            },
                            onChanged: (vale) {
                              email = _validateEmail(vale);
                            },
                          ),
                         10.height,
                    
                          const Text(
                            "Company Address",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              // color: ,
                              fontSize: 13,
                            ),
                          ),
                          Container(
                            height: 200,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                border: Border.all(
                                    width: 1, color: const Color(0xff777777))),
                            child: TextFormField(
                              style: const TextStyle(color: Colors.black),
                              keyboardType: TextInputType.multiline,
                              controller:widget.bloc.c_address,
                              maxLines: null,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Write here...",
                                focusColor: Colors.white,
                                counterStyle: TextStyle(color: Colors.white),
                                hintStyle: TextStyle(
                                    color: Color(0xff777777),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300,
                                    fontFamily: "Poppins"),
                              ),
                              onFieldSubmitted: (value) {
                                widget.bloc.other.text = value;
                              },
                              // validator: (value) {
                              //   if (value.toString().isEmpty) {
                              //     return "Please enter your other information.";
                              //   }
                              //   return null;
                              // },
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              const Text(
                                "Coordinate Person Name",
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  // color: ,
                                  fontSize: 13,

                                ),
                              ),
                              Text("*", style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),)

                            ],
                          ),

                          TextFormField(
                            style: const TextStyle(color: Colors.black),
                            controller: widget.bloc.cp_name,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xffffffff),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.red.withOpacity(1)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.red.withOpacity(1)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              contentPadding: const EdgeInsets.all(17.0),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: const Color(0xff777777)
                                        .withOpacity(0.8)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                    const Color(0xff777777).withOpacity(1)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              hintText: "Name",
                              focusColor: Colors.white,
                              counterStyle:
                              const TextStyle(color: Colors.white),
                              hintStyle: const TextStyle(
                                  color: Color(0xff777777),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Poppins"),
                            ),
                            validator: (value) {
                              if (value.toString().isEmpty) {
                                return "Coordinate Person Name is required";
                              }
                              return null;
                            },
                            onTap: () {},
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              const Text(
                                "Coordinate Person Number",
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  // color: ,
                                  fontSize: 13,

                                ),
                              ),
                              Text("*", style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),)

                            ],
                          ),

                          TextFormField(
                            style: const TextStyle(color: Colors.black),
                            keyboardType: TextInputType.number,
                            maxLength: 10,
                            controller: widget.bloc.cp_mobile,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xffffffff),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.red.withOpacity(1)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.red.withOpacity(1)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              contentPadding: const EdgeInsets.all(17.0),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: const Color(0xff777777)
                                        .withOpacity(0.8)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                    const Color(0xff777777).withOpacity(1)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              hintText: "Phone number",
                              focusColor: Colors.white,
                              counterStyle:
                              const TextStyle(color: Colors.white),
                              hintStyle: const TextStyle(
                                  color: Color(0xff777777),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Poppins"),
                            ),
                            validator: (value) {
                              if (value.toString().isEmpty) {
                                return "Coordinate phone number is required";
                              }else if(value.toString().length<10){
                                return 'Mobile number must be 10 digit';
                              }
                              return null;
                            },
                            onTap: () {},
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              const Text(
                                "Coordinate Person Email",
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  // color: ,
                                  fontSize: 13,

                                ),
                              ),
                              Text("*", style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),)

                            ],
                          ),
                          TextFormField(
                            style: const TextStyle(color: Colors.black),
                            controller: widget.bloc.cp_email,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xffffffff),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.red.withOpacity(1)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.red.withOpacity(1)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              contentPadding: const EdgeInsets.all(17.0),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: const Color(0xff777777)
                                        .withOpacity(0.8)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                    const Color(0xff777777).withOpacity(1)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              hintText: "Email",
                              focusColor: Colors.white,
                              counterStyle:
                              const TextStyle(color: Colors.white),
                              hintStyle: const TextStyle(
                                  color: Color(0xff777777),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Poppins"),
                            ),
                            validator: (value) {
                              if (value.toString().isEmpty) {
                                return "Coordinate person email is required";
                              }else if(emailcp == false){
                                return 'Please enter valid email';
                              }
                              return null;
                            },
                            onChanged: (value) {
                             emailcp =  _validateEmail(value);

                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "Coordinate Person Location",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              // color: ,
                              fontSize: 13,
                    
                            ),
                          ),
                          10.height,
                          Container(
                            height: 200,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                border: Border.all(
                                    width: 1, color: const Color(0xff777777))),
                            child: TextFormField(
                              style: const TextStyle(color: Colors.black),
                              keyboardType: TextInputType.multiline,
                              controller:widget.bloc.cp_location,
                              maxLines: null,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Write here...",
                                focusColor: Colors.white,
                                counterStyle: TextStyle(color: Colors.white),
                                hintStyle: TextStyle(
                                    color: Color(0xff777777),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300,
                                    fontFamily: "Poppins"),
                              ),
                              onFieldSubmitted: (value) {
                                widget.bloc.other.text = value;
                              },

                            ),
                          ),

                          const SizedBox(
                            height: 10,
                          ),
                          ValueListenableBuilder(
                            valueListenable: widget.bloc.isLoadingAddBranch,
                            builder: (BuildContext context, bool loading,
                                Widget? child) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  loading
                                      ? CircularProgressIndicator()
                                      : CustomButton2(
                                      onPressed: () {
                                        if (formKey.currentState!.validate()) {
                                          widget.bloc.AddBranch(widget.leadId).then((value){
                                            Navigator.pop(context);
                                            widget.bloc.specificLeadData.value = null;
                                            widget.bloc.getSpecificLeadData(widget.leadId.toString(),"lead_branches");
                                          });
                                        }
                                      },
                                      tittle: 'Add Notes'),
                                ],
                              );
                            },
                          ),
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
  bool _validateEmail(String email) {
    final RegExp regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }
}
