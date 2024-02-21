import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:office/bloc/property_notifier.dart';
import 'package:office/data/model/LeaveCategory.dart';
import 'package:office/data/model/LeaveRecord.dart';
import 'package:office/data/model/api_response.dart';
import 'package:office/data/network/api_exception.dart';
import 'package:office/data/repository/leave_repository.dart';
import 'package:office/utils/enums.dart';
import 'package:office/utils/message_handler.dart';

import 'bloc.dart';

class LeaveBloc extends Bloc {
  final LeaveRepository _repo;
  LeaveBloc(this._repo);

  //#region -Leaves

  ValueNotifier<int> recordIndex = ValueNotifier(0);
  TextEditingController remark = TextEditingController();

  updateRecordIndex(int index) {
    if(leaveRecordsState.value==LoadingState.loading) {
      return;
    }
    recordIndex.value = index;
    getLeaveRecords();
  }

  ValueNotifier<LoadingState> leaveRecordsState = ValueNotifier(LoadingState.done);
  PropertyNotifier<List<LeaveRecord>> leaveRecords = PropertyNotifier([]);
  getLeaveRecords() async {
    try {
      if(leaveRecordsState.value==LoadingState.loading) {
        return;
      }
      leaveRecordsState.value=LoadingState.loading;
      List<LeaveRecord> res = await _repo.getLeaveRecords(recordIndex.value==0 ? "all" : recordIndex.value==1 ? "reject" : recordIndex.value==2 ? "approve" : "pending");
      leaveRecords.value = res;
      leaveRecords.notifyListeners();
      leaveRecordsState.value=LoadingState.done;
    } catch(e,s) {
      if(e.toString()==ApiException.networkMessage) {
        leaveRecordsState.value=LoadingState.networkError;
      } else{
        leaveRecordsState.value=LoadingState.error;
      }
      debugPrint('$e');
      debugPrintStack(stackTrace: s);
    }
  }
  //#endregion

  //#region
  List<LeaveCategory> leaveCategories = [];
  getLeaveCategory() async {
    try {
      List<LeaveCategory> res = await _repo.getLeaveCategories();
      leaveCategories = res;
    } catch(e,s) {
      debugPrint('$e');
      debugPrintStack(stackTrace: s);
    }
  }
  //#endregion

  //#region -Apply Leave
  StreamController<String> leaveController = StreamController.broadcast();
  TextEditingController reasonTitle = TextEditingController();
  TextEditingController reason = TextEditingController();
  ValueNotifier<DateTime?> startDate = ValueNotifier(null);
  ValueNotifier<DateTime?> endDate = ValueNotifier(null);
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<Map<String, dynamic>> durationType = [
    {"title": "Single", "value": "single"},
    {"title": "Multiple", "value": "multiple"},
    {"title": "First Half", "value": "first_half"},
    {"title": "Second Half", "value": "second_half"},
  ];

  String? selectedLeaveCategory;
  ValueNotifier<String?> selectedDurationType = ValueNotifier(null);

  updateLC(String value) {
    selectedLeaveCategory = value;
  }
  updateDT(String value) {
    selectedDurationType.value = value;
  }
  updateStartDate(DateTime value) => startDate.value = value;
  updateEndDate(DateTime value) => endDate.value = value;

  ValueNotifier<bool> requesting = ValueNotifier(false);
  applyForLeave() async {
    try {
      if(requesting.value) {
        return;
      }
      if(!formKey.currentState!.validate()) {
        return;
      }
      if(startDate.value==null) {
        showMessage(const MessageType.success("Please enter date!"));
        return;
      }
      if(selectedDurationType.value==null) {
        showMessage(const MessageType.success("Please select duration type!"));
        return;
      }
      if(selectedLeaveCategory==null) {
        showMessage(const MessageType.success("Please select leave category!"));
        return;
      }
      if(selectedDurationType.value=="multiple" && endDate.value==null) {
        showMessage(const MessageType.success("Please enter date!"));
        return;
      }
      requesting.value = true;
      ApiResponse res = await _repo.applyForLeave(reasonTitle.text, reason.text, startDate.value!, selectedLeaveCategory!, selectedDurationType.value!, endDate: endDate.value);
      if(res.status) {
        leaveController.sink.add("LEAVE_REQUESTED");
        startDate.value=null;
        endDate.value=null;
        selectedDurationType.value = null;
        selectedLeaveCategory = null;
        reasonTitle.clear();
        reason.clear();
        showMessage(const MessageType.success("Leave requested successfully!"));
      } else {
        showMessage(MessageType.success(res.message));
      }
    } catch(e,s) {
      debugPrint("$e");
      debugPrintStack(stackTrace: s);
      showMessage(MessageType.success('$e'));
    } finally {
      requesting.value = false;
    }
  }
  //#endregion

//#region -Response Leave
  ValueNotifier<bool> isResponseApproveLoad = ValueNotifier(false);
  ValueNotifier<bool> isResponseRejectLoad = ValueNotifier(false);
  respondLeaveRequest(String leaveId,String status) async {
    try{
      if(status=="approve"){
        isResponseApproveLoad.value=true;
      }
      else{
        isResponseRejectLoad.value=true;
      }
      // isResponseLoad.value = true;

      var result = await _repo.respondLeaveRequest(leaveId,status);
      if(result.status==true){
        leaveController.sink.add("LEAVE_RESPONSE");
        showMessage(const MessageType.success("Leave Response Updated successfully"));
      }
    }catch (e,s) {
      showMessage(MessageType.error(e.toString()));
      print(e);
      print(s);
    } finally{
      if(status=="approve"){
        isResponseApproveLoad.value=false;
      }
      else{
        isResponseRejectLoad.value=false;
      }
      // isResponseLoad.value = false;
    }
  }
  ValueNotifier balanceData = ValueNotifier(null);
  getLeaveBalanceDetail() async {
    try {
     var   res = await _repo.leaveBalance();
     balanceData.value = res.data['data'];
     print('value is availble:${res.data['data']}');
    } catch(e,s) {
      debugPrint('$e');
      debugPrintStack(stackTrace: s);
    }
  }
}