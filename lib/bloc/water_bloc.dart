import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/model/api_response.dart';
import '../data/model/water_model.dart';
import '../data/model/water_type_model.dart';
import '../data/repository/water_repo.dart';
import '../utils/message_handler.dart';
import 'bloc.dart';

class WaterBloc extends Bloc {
  final WaterRepository _repo;
  WaterBloc(this._repo);
  StreamController<String> waterController = StreamController.broadcast();
  ValueNotifier<DateTime?> startDate = ValueNotifier(DateTime.now());
  updateStartDate(DateTime value) => startDate.value = value;
  ValueNotifier<bool> isWaterLoad = ValueNotifier(false);
  ValueNotifier<bool> isWaterTypeLoad = ValueNotifier(false);
  ValueNotifier<Water?> water = ValueNotifier(null);
  ValueNotifier<String> waterString = ValueNotifier("");
  TextEditingController quantityController = TextEditingController();
  fetchWaterDaily() async{
    try{
      isWaterLoad.value = true;
      String date = DateFormat('yyyy-MM-dd').format(startDate.value!);
      var res = await _repo.fetchWaterDaily(date,waterString.value);
      if(res!=null){
        water.value = res.data;
      }
    }catch (e, s) {
      print(e);
      print(s);
    }finally{
      isWaterLoad.value = false;
    }
  }

  ValueNotifier<List<WaterType>> waterType = ValueNotifier([]);
  fetchWaterType() async{
    try{
      isWaterTypeLoad.value = true;
      var res = await _repo.fetchWaterType();
      if(res!=null){
        waterType.value = [];
        for (var eBillItem in res) {
          waterType.value.add(eBillItem);
          // eBillItem.eController.text = eBillItem.e ?? '';
          // eBillItem.mController.text = eBillItem.m ?? '';
        }
        // eBill.value.addAll(res);
      }
    }catch (e, s) {
      print(e);
      print(s);
    }finally{
      isWaterTypeLoad.value = false;
    }
  }

  ValueNotifier<bool> isWaterDailyLoad = ValueNotifier(false);
  addWaterDaily() async {
    try{
      isWaterDailyLoad.value = true;
      String date = DateFormat('yyyy-MM-dd').format(startDate.value!);
      if(waterString.value=="" || waterString.value=="null"|| waterString.value==null){
        showMessage(const MessageType.info("Please Select water Type"));
        return;
      }
      if(quantityController.text.isEmpty){
        showMessage(const MessageType.info("Please Enter water Quantity"));
        return;
      }
      var result = await _repo.addWaterTypeDaily(date,waterString.value,quantityController.text,UpdateBranchName.value);
      if(result.message!=''&& result.message=="WaterBill Added successfully"){
        showMessage(const MessageType.success("WaterBill Updated successfully"));
        fetchWaterDaily();
      }
    }catch (e,s) {
      showMessage(MessageType.error(e.toString()));
      print(e);
      print(s);
    } finally{
      isWaterDailyLoad.value = false;
    }
  }

  ValueNotifier<DateTime?> month = ValueNotifier(DateTime.now());
  ValueNotifier<DateTime?> year = ValueNotifier(DateTime.now());
  updateMonth(DateTime value) => month.value = value;
  updateYear(DateTime value) => year.value = value;
  ScrollController scrollController = ScrollController();
  ValueNotifier<bool> isWaterListLoad = ValueNotifier(false);
  ValueNotifier<List<Water>> waterList = ValueNotifier([]);
  fetchWaterList() async{
    try{
      isWaterListLoad.value = true;
      String months = DateFormat('MM').format(month.value!);
      String years = DateFormat('yyyy').format(year.value!);
      var res = await _repo.fetchWaterList(months, years);
      if(res!=null){
        waterList.value = res;
        // waterList.value.addAll(res);
      }
    }catch (e, s) {
      print(e);
      print(s);
    }finally{
      isWaterListLoad.value = false;
    }
  }
  ValueNotifier<bool> isLoadingvalue = ValueNotifier(false);
  ValueNotifier<List?>  getbranchName = ValueNotifier(null);
  ValueNotifier<String?> UpdateBranchName = ValueNotifier(null);

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
}