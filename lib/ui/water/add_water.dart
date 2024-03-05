import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:office/bloc/water_bloc.dart';
import 'package:office/data/model/water_model.dart';
import 'package:office/ui/water/water_list.dart';
import 'package:provider/provider.dart';
import '../../data/model/water_type_model.dart';
import '../../data/repository/water_repo.dart';
import '../../utils/message_handler.dart';
import '../widget/app_button.dart';
import '../widget/app_dropdown.dart';
import '../widget/app_text_field.dart';

class AddWater extends StatefulWidget {
  const AddWater({Key? key}) : super(key: key);

  @override
  State<AddWater> createState() => _AddWaterState();
}

class _AddWaterState extends State<AddWater> {
  late WaterBloc waterBloc;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController wController = TextEditingController();
  @override
  void initState() {
    waterBloc = WaterBloc(context.read<WaterRepository>());
    waterBloc.quantityController.text='';
    super.initState();
    waterBloc.msgController?.stream.listen((event) {
      AppMessageHandler().showSnackBar(context, event);
    });
    waterBloc.fetchWaterType();
    waterBloc.fetchWaterDaily();
    waterBloc.fetchDailyActiviy();
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
                  "Water",
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
          Positioned(
            top: 56,
            right: 10,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>const WaterList()));
                },
              child: const CircleAvatar(
                backgroundColor: Colors.white,
                radius: 15,
                child: Icon(PhosphorIcons.list, size: 18,),
              ),
            ),
          ),
          Column(
            children: [
              const SizedBox(height: 100,),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 30,),
                          const Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text("Date", style: TextStyle(fontSize: 13)),
                          ),
                          ValueListenableBuilder(
                              valueListenable: waterBloc.startDate,
                              builder: (context, DateTime? date, _) {
                              return InkWell(
                                onTap: () async {
                                  DateTime? dt = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now().subtract(Duration(days: 15)), lastDate:  DateTime.now().add(Duration(days: 30)),);
                                  if(dt!=null) {
                                    await waterBloc.updateStartDate(dt);
                                    waterBloc.fetchWaterDaily();
                                  }
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
                          const Padding(
                            padding: EdgeInsets.only(left: 1),
                            child: Row(
                              children: [
                                Text("Branch", style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500)),
                                Text("*", style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),)
                              ],
                            ),
                          ),
                          const SizedBox(height: 10,),
                          ValueListenableBuilder(
                            valueListenable: waterBloc.getbranchName,
                            builder: (context, member, child) {
                              if(member ==null){
                                return AppDropdown(
                                  items:[],
                                  onChanged: (v) {waterBloc.UpdateBranchName=v;
                                  print(v);
                                  },
                                  value: null,
                                  hintText: "Choose Member",
                                );
                              }
                              if(member.isEmpty){
                                return SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.7,
                                    child: Center(child: Text("No data available")));
                              }
                              return AppDropdown(
                                items: member!.map((e) => DropdownMenuItem(value: '${e['id']}', child: Text(e['title']??""))
                                ).toList(),
                                onChanged: (v) {waterBloc.UpdateBranchName.value = v;
                                },
                                value: waterBloc.UpdateBranchName.value,
                                hintText: "Choose Member",
                              );
                            },

                          ),
                          SizedBox(height: 10,),
                          ValueListenableBuilder(
                             valueListenable: waterBloc.isWaterTypeLoad,
                             builder: (context, bool loading,__) {
                               if (loading) {
                                 return const Column(
                                   mainAxisAlignment: MainAxisAlignment.center,
                                   crossAxisAlignment: CrossAxisAlignment.center,
                                   children: [
                                     SizedBox(
                                       height: 50,
                                     ),
                                     Center(
                                       child: CircularProgressIndicator(color: Colors.blue,),
                                     ),
                                   ],
                                 );
                               }
                              return ValueListenableBuilder(
                                  valueListenable: waterBloc.waterType,
                                  builder: (context, List<WaterType>waterType,__) {
                                    if (waterType.isEmpty) {
                                      return  const Center(
                                        child: Column(
                                          children: [
                                            SizedBox(height:50),
                                            Text(
                                              "No data Found",
                                              style: TextStyle(color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 15,),
                                      const Padding(
                                        padding: const EdgeInsets.only(left: 10),
                                        child: Text("Water Type", style: const TextStyle(fontSize: 13)),
                                      ),
                                      DropdownButtonFormField<String>(
                                        icon: const Icon(
                                          Icons.arrow_drop_down,
                                          color: Colors.black,
                                        ),
                                        iconSize: 24,
                                        elevation: 16,
                                        style: const TextStyle(color: Colors.black, fontSize: 15),
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor:  Colors.grey[100],
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
                                          const TextStyle(color: Colors.black54, fontSize: 15),
                                        ),
                                        onChanged: (v) {
                                          waterBloc.waterString.value = v??"";
                                          // final selectedWater = waterBloc.waterType.value.firstWhere(
                                          //       (waterType) => waterType.id == waterBloc.waterString.value,
                                          //   orElse: () => WaterType(name: ''),
                                          // );
                                          //
                                          // // waterType.first.quantityController.text=selectedWater.quantity=='0'?'':selectedWater.quantity!;
                                          // print("${selectedWater.id}");
                                          waterBloc.fetchWaterDaily();
                                          print("v $v ${waterBloc.waterString.value}");
                                        },
                                        items: waterBloc.waterType.value.map((WaterType items) {
                                          return DropdownMenuItem<String>(
                                            value: "${items.id}",
                                            child: Text( items.name ?? "",),
                                          );
                                        }).toList(),
                                      ),
                                      const SizedBox(height: 15,),
                                      ValueListenableBuilder(
                                          valueListenable: waterBloc.isWaterLoad,
                                          builder: (context, bool loading,__) {
                                            if (loading) {
                                              return const Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    height: 50,
                                                  ),
                                                  Center(
                                                    child: CircularProgressIndicator(color: Colors.blue,),
                                                  ),
                                                ],
                                              );
                                            }
                                          return ValueListenableBuilder(
                                              valueListenable: waterBloc.water,
                                              builder: (context, Water? water,__) {
                                                if (water != null) {
                                                  waterBloc.quantityController.text=water.numberOfBotal=="0"?'':water.numberOfBotal??"";
                                                }

                                              return AppTextField(
                                                controller: waterBloc.quantityController,
                                                title: "Quantity",
                                                keyboardType: TextInputType.number,
                                                // validate: true,
                                              );
                                            }
                                          );
                                        }
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      ValueListenableBuilder(
                                        valueListenable: waterBloc.isWaterDailyLoad,
                                        builder: (context, bool loading,__) {
                                          return AppButton(
                                            title: "Submit",
                                            loading: loading?true:false,
                                            onTap: () {

                                              if (formKey.currentState!.validate()) {
                                                waterBloc.addWaterDaily();
                                              }
                                            },
                                            margin: EdgeInsets.zero,
                                            // loading: loading,
                                          );
                                        }
                                      ),
                                    ],
                                  );
                                }
                              );
                            }
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
     /* floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: 40,
            width: 70,
            child: FloatingActionButton.extended(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0))
                ),
                onPressed: () async{
                  // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const AddLead()));
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
                          PhosphorIcons.list,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      Text(
                        "List",
                        style: TextStyle(color: Colors.white,fontSize: 15),
                      )
                    ],
                  ),
                )),
          ),
          const SizedBox(height: 30,)
        ],
      ),*/
    );
  }
}
