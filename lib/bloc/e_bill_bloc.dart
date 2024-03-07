import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:office/bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/model/api_response.dart';
import '../data/model/e_bill_model.dart';
import '../data/repository/e_bill_repo.dart';
import '../utils/message_handler.dart';

class EBillBloc extends Bloc {
  final EBillRepository _repo;

  EBillBloc(this._repo);

  StreamController<String> eBillController = StreamController.broadcast();
  ValueNotifier<DateTime?> startDate = ValueNotifier(DateTime.now());
  ValueNotifier<bool> isEBillLoad = ValueNotifier(false);
  ValueNotifier<List<EBill>> eBill = ValueNotifier([]);
  fetchEBill() async{
    try{
      isEBillLoad.value = true;
      String date = DateFormat('yyyy-MM-dd').format(startDate.value!);
      var res = await _repo.fetchEBill(date);
      if(res!=null){
        eBill.value = [];
        for (var eBillItem in res) {
          eBill.value.add(eBillItem);
          eBillItem.eController.text = eBillItem.e ?? '';
          eBillItem.mController.text = eBillItem.m ?? '';
        }
      // eBill.value.addAll(res);
      }
    }catch (e, s) {
      print(e);
      print(s);
    }finally{
      isEBillLoad.value = false;
    }
  }

  updateStartDate(DateTime value) => startDate.value = value;

  ValueNotifier<bool> isAddEBillLoad = ValueNotifier(false);
  addEBillDaily() async {
    try {
      isAddEBillLoad.value = true;
      SharedPreferences _pref = await SharedPreferences.getInstance();
      String? id = _pref.getString('uid');
      String date = DateFormat('yyyy-MM-dd').format(startDate.value!);
      List<Map<String, dynamic>> mapList = [];
      for (var item in eBill.value) {
        Map<String, dynamic> eBillDaily = {};
        eBillDaily['user_id']=id;
        eBillDaily['type_id']=item.typeId;
        eBillDaily['date']=date;
        eBillDaily['m']=item.mController.text;
        eBillDaily['e']=item.eController.text;
        mapList.add(eBillDaily);
      }

      var response = await _repo.addEBillDaily(mapList);
      if (response != null && response['message'] == 'EBill Added successfully') {
        showMessage(const MessageType.success("EBill Updated successfully"));
        fetchEBill();
      }
    } catch (e, s) {
      print(e);
      print(s);
    } finally {
      isAddEBillLoad.value = false;
    }
  }

  ValueNotifier<String?> Updatemetertype = ValueNotifier(null);
  ValueNotifier<String?> UpdateBranchName = ValueNotifier(null);
  ValueNotifier<List?>  getbranchName = ValueNotifier(null);
  ValueNotifier<bool> isLoadingvalue = ValueNotifier(false);
  ValueNotifier<bool> isLoadingupdatebill = ValueNotifier(false);
  TextEditingController reading=TextEditingController();


  fetchDailyActiviy()async{
    isLoadingvalue.value = true;
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      Map<String, dynamic> data = {
        "user_id": pref.getString('uid')
      };
      ApiResponse2 res = await _repo.Add('get-branch',data) ;
      if(res.status) {
        getbranchName.value = res.data;
      } else {
        showMessage(MessageType.error(res.message.toString()));
      }
    } catch(e,s) {
      print("the error is : $e");
      debugPrint('$e');
      debugPrintStack(stackTrace: s);
      showMessage(const MessageType.error("Some error occurred! Please try again!"));
    }finally{
      isLoadingvalue.value = false;
    }
  }

  fetchteamList()async{
    isLoadingvalue.value = true;
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      Map<String, dynamic> data = {
        "user_id": pref.getString('uid')
      };
      ApiResponse2 res = await _repo.Add('get-branch',data) ;
      if(res.status) {
        getbranchName.value = res.data;
      } else {
        showMessage(MessageType.error(res.message.toString()));
      }
    } catch(e,s) {
      print("the error is : $e");
      debugPrint('$e');
      debugPrintStack(stackTrace: s);
      showMessage(const MessageType.error("Some error occurred! Please try again!"));
    }finally{
      isLoadingvalue.value = false;
    }
  }

  UpdateBill()async{
    String date = DateFormat('yyyy-MM-dd').format(startDate.value!);

    if(UpdateBranchName.value==null){
      showMessage(MessageType.info('Please select branch'));
    }else if(Updatemetertype.value ==null){
      showMessage(MessageType.info('Please select type'));

    }else if(reading.text.isEmpty){
      showMessage(MessageType.info('Please enter reading'));
    }
    else {
      isLoadingupdatebill.value = true;
      SharedPreferences pref = await SharedPreferences.getInstance();
      try {
        Map<String, dynamic> data = {
          "user_id": pref.getString('uid'),
          "date":date,
          "branch_id":UpdateBranchName.value,
          "meter_type_id":Updatemetertype.value,
          "meter_reading":reading.text
        };
        ApiResponse2 res = await _repo.Add2('post-add-electbill',data) ;
        if(res.status) {
          showMessage(MessageType.success(res.message.toString()));
        } else {
          showMessage(MessageType.error(res.message.toString()));
        }
      } catch(e,s) {
        print("the error is : $e");
        debugPrint('$e');
        debugPrintStack(stackTrace: s);
        showMessage(const MessageType.error("Some error occurred! Please try again!"));
      }finally{
        isLoadingupdatebill.value = false;
      }
    }

  }


  ValueNotifier<DateTime?> month = ValueNotifier(DateTime.now());
  ValueNotifier<DateTime?> year = ValueNotifier(DateTime.now());
  updateMonth(DateTime value) => month.value = value;
  updateYear(DateTime value) => year.value = value;
  ValueNotifier<List?> ebillList = ValueNotifier([]);
  ScrollController scrollController = ScrollController();


  fetchBillList()async{
    String months = DateFormat('MM').format(month.value!);
    String years = DateFormat('yyyy').format(year.value!);
    isLoadingvalue.value = true;
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      Map<String, dynamic> data = {
        "user_id": pref.getString('uid'),
        "month": months,
        "year": years,
      };
      ApiResponse2 res = await _repo.Add2('electricity-List-list',data);
      if(res.status ==true) {
        ebillList.value = res.data;

      } else {
        showMessage(MessageType.error(res.message.toString()));
      }
    } catch(e,s) {
      print("the error is : $e");
      debugPrint('$e');
      debugPrintStack(stackTrace: s);
      showMessage(const MessageType.error("Some error occurred! Please try again!"));
    }finally{
      isLoadingvalue.value = false;
    }
  }

}