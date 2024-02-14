import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:office/bloc/e_bill_bloc.dart';
import 'package:office/data/repository/e_bill_repo.dart';
import 'package:office/ui/bill/bill_list.dart';
import 'package:provider/provider.dart';

import '../../data/model/e_bill_model.dart';
import '../../utils/message_handler.dart';
import '../widget/app_button.dart';
import '../widget/app_text_field.dart';

class AddBill extends StatefulWidget {
  const AddBill({Key? key}) : super(key: key);

  @override
  State<AddBill> createState() => _AddBillState();
}

class _AddBillState extends State<AddBill> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late EBillBloc eBillBloc;

  @override
  void initState() {
    eBillBloc = EBillBloc(context.read<EBillRepository>());
    super.initState();
    eBillBloc.msgController?.stream.listen((event) {
      AppMessageHandler().showSnackBar(context, event);
    });
    eBillBloc.fetchEBill();
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
                  "Bill",
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
                        builder: (context) =>const BillList()));
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
                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
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
                                valueListenable: eBillBloc.startDate,
                                builder: (context, DateTime? date, _) {
                                  return InkWell(
                                    onTap: () async {
                                      DateTime? dt = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now().subtract(Duration(days: 15)), lastDate:  DateTime.now().add(Duration(days: 30)),);
                                      if(dt!=null) {
                                       await eBillBloc.updateStartDate(dt);
                                        eBillBloc.fetchEBill();
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
                            const SizedBox(height: 30,),
                            ValueListenableBuilder(
                              valueListenable: eBillBloc.isEBillLoad,
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
                                  valueListenable: eBillBloc.eBill,
                                  builder: (context, List<EBill>eBill,__) {
                                    if (eBill.isEmpty) {
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
                                    return Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black),
                                        borderRadius: BorderRadius.all(Radius.circular(15))
                                      ),
                                      child: Column(
                                        children: [
                                          Align(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(horizontal:30,vertical: 3),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Text("E",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
                                                  const SizedBox(width: 60,),
                                                  Text("M",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
                                                ],
                                              ),
                                            ),
                                          ),
                                          ListView.builder(
                                            physics: const NeverScrollableScrollPhysics(),
                                            itemCount: eBill.length,
                                              shrinkWrap: true,
                                              padding: EdgeInsets.zero,
                                              itemBuilder: (context,index){
                                                return Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text("${index + 1}.",style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
                                                              const SizedBox(width: 5,),
                                                              Text("${eBill[index].name}",style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              SizedBox(
                                                                height: 50,
                                                                width: 60,
                                                                child: AppTextField(
                                                                  controller: eBill[index].eController,
                                                                  title: "",
                                                                  keyboardType: TextInputType.number,
                                                                  showTitle: false,
                                                                ),
                                                              ),
                                                              const SizedBox(width: 7,),
                                                              SizedBox(
                                                                height: 50,
                                                                width: 60,
                                                                child: AppTextField(
                                                                  controller: eBill[index].mController,
                                                                  title: "",
                                                                  keyboardType: TextInputType.number,
                                                                  showTitle: false,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },

                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                );
                              }
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                           ValueListenableBuilder(
                              valueListenable: eBillBloc.isAddEBillLoad,
                              builder: (context,bool loading,__) {
                                return AppButton(
                                  title: "Submit",
                                  loading: loading?true:false,
                                  onTap: () async{
                                    eBillBloc.addEBillDaily();
                                    if (formKey.currentState!.validate()) {
                                      // bloc.addComplaint();
                                    }
                                  },
                                  margin: EdgeInsets.zero,
                                  // loading: loading,
                                );
                              }
                            )
                          ],
                        ),
                      ),
                    ),
                  )
              )
            ],
          )
        ],
      ),
      /*floatingActionButton: Column(
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
