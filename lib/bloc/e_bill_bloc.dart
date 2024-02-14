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

}