import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:office/bloc/property_notifier.dart';
import 'package:office/data/model/LeaveCategory.dart';
import 'package:office/data/model/LeaveRecord.dart';
import 'package:office/data/model/api_response.dart';
import 'package:office/data/network/api_exception.dart';
import 'package:office/data/repository/leave_repository.dart';
import 'package:office/data/repository/work_from_home_repository.dart';
import 'package:office/utils/enums.dart';
import 'package:office/utils/message_handler.dart';

import 'bloc.dart';

class WorkFromHomeBloc extends Bloc {
  final WorkFromHomeRepository _repo;
  WorkFromHomeBloc(this._repo);

  //#region -Leaves

  ValueNotifier<int> recordIndex = ValueNotifier(0);
  updateRecordIndex(int index) {
    if(workFromHomeState.value==LoadingState.loading) {
      return;
    }
    recordIndex.value = index;
    getWorkFromHomeRecords();
  }

  ValueNotifier<LoadingState> workFromHomeState = ValueNotifier(LoadingState.done);
  PropertyNotifier<List> workFromHomeRecords = PropertyNotifier([]);
  getWorkFromHomeRecords() async {
    try {
      if(workFromHomeState.value==LoadingState.loading) {
        return;
      }
      workFromHomeState.value=LoadingState.loading;
      List res = await _repo.getWorkFromHomeRecords(recordIndex.value==0 ? "all" : recordIndex.value==1 ? "reject" : recordIndex.value==2 ? "approve" : "pending");
      workFromHomeRecords.value = res;
      workFromHomeRecords.notifyListeners();
      workFromHomeState.value=LoadingState.done;
    } catch(e,s) {
      if(e.toString()==ApiException.networkMessage) {
        workFromHomeState.value=LoadingState.networkError;
      } else{
        workFromHomeState.value=LoadingState.error;
      }
      debugPrint('$e');
      debugPrintStack(stackTrace: s);
    }
  }
  //#endregion

  //#region -Apply Leave
  // StreamController<String> leaveController = StreamController.broadcast();
  StreamController<String> workFromHomeController = StreamController.broadcast();
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

  // String? selectedLeaveCategory;
  ValueNotifier<String?> selectedDurationType = ValueNotifier(null);

  // updateLC(String value) {
  //   selectedLeaveCategory = value;
  // }
  updateDT(String value) {
    selectedDurationType.value = value;
  }
  updateStartDate(DateTime value) => startDate.value = value;
  updateEndDate(DateTime value) => endDate.value = value;

  ValueNotifier<bool> requesting = ValueNotifier(false);
  applyForWFH() async {
    try {
      if(requesting.value) {
        return;
      }
      if(!formKey.currentState!.validate()) {
        return;
      }
      if(startDate.value==null) {
        showMessage(MessageType.info("Please enter date!"));
        return;
      }
      if(selectedDurationType.value==null){
        showMessage(const MessageType.info("Please select duration type!"));
        return;
      }
      if(selectedDurationType.value=="multiple" && endDate.value==null) {
        showMessage(const MessageType.info("Please enter date!"));
        return;
      }
      requesting.value = true;
      ApiResponse res = await _repo.applyForWorkFromHome(reasonTitle.text, reason.text, startDate.value!, selectedDurationType.value!, endDate: endDate.value);
      if(res.status) {
        workFromHomeController.sink.add("LEAVE_REQUESTED");
        startDate.value=null;
        endDate.value=null;
        selectedDurationType.value = null;
        reasonTitle.clear();
        reason.clear();
        showMessage(const MessageType.success("WFH requested successfully!"));
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
//   //#endregion
//
// //#region -Response Leave
  ValueNotifier<bool> isResponseApproveLoad = ValueNotifier(false);
  ValueNotifier<bool> isResponseRejectLoad = ValueNotifier(false);
  ValueNotifier<bool> isCancelLoading = ValueNotifier(false);
  StreamController<String> CancelStream = StreamController.broadcast();
  updateEndEditDate(DateTime value) => endDateEdit.value = value;
  updateStartEditDate(DateTime value) => startDateEdit.value = value;

  CanelLeave(int id) async {
    try {
      isCancelLoading.value = true;
      var result = await _repo.CancelWorkFormhome(id.toString());
      if (result.status ==true) {
        CancelStream.sink.add('Post');
        showMessage(MessageType.success("Cancel leave successful"));
      } else {
        showMessage(MessageType.error("Something went wrong"));
      }
    } catch (e, s) {
      debugPrint("$e");
      debugPrint("$s");
    } finally {
      isCancelLoading.value = false;
    }
  }
  ValueNotifier<DateTime?> endDateEdit = ValueNotifier(null);
  ValueNotifier<String?>selectedLeaveCategory = ValueNotifier(null);
  StreamController<String?> leaveEditController = StreamController.broadcast();
  ValueNotifier<int?> leaveId = ValueNotifier(null);
  TextEditingController reasonTitleEdit = TextEditingController();
  ValueNotifier<DateTime?> startDateEdit = ValueNotifier(null);
  TextEditingController reasonEdit= TextEditingController();




  EditForLeave() async {
    try {
      if(requesting.value) {
        return;
      }
      if(!formKey.currentState!.validate()) {
        return;
      }
      if(startDateEdit.value==null) {
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
      if(selectedDurationType.value=="multiple" && endDateEdit.value==null) {
        showMessage(const MessageType.success("Please enter date!"));
        return;
      }
      requesting.value = true;
      ApiResponse res = await _repo.EditForwfh(leaveId.value!,reasonTitleEdit.text, reasonEdit.text, startDateEdit.value!, selectedDurationType.value!, endDate: endDateEdit.value,);
      if(res.status) {
        leaveEditController.sink.add("LEAVE_Edit");
        startDate.value=null;
        endDate.value=null;
        selectedDurationType.value = null;
        selectedLeaveCategory.value = null;
        reasonTitle.clear();
        reason.clear();

        showMessage(const MessageType.success("Leave edit successfully!"));
      } else {
        showMessage(MessageType.error(res.message.toString()));
      }
    } catch(e,s) {
      debugPrint("$e");
      debugPrintStack(stackTrace: s);
      showMessage(MessageType.success('$e'));
    } finally {
      requesting.value = false;
    }
  }
  TextEditingController remark = TextEditingController();
  ValueNotifier<bool> isApprovedLoading = ValueNotifier(false);

  Approvedwfh(int id) async {
    try {
      isApprovedLoading.value = true;
      var result = await _repo.ApprovedLeave(id);
      if (result.status ==true) {
        CancelStream.sink.add('Post');
        showMessage(MessageType.success("success"));
      } else {
        showMessage(MessageType.error("Something went wrong"));
      }
    } catch (e, s) {
      debugPrint("$e");
      debugPrint("$s");
    } finally {
      isApprovedLoading.value = false;
    }
  }
  Future AddRemarkLeave(int id) async {
    try {
      isResponseApproveLoad.value = true;
      var result = await _repo.AddRemark(id,remark.text);
      if (result.status ==true) {

        showMessage(MessageType.success("success"));
        remark.clear();
        return result.status;
      } else {
        return result.status;

        showMessage(MessageType.error("Something went wrong"));
      }
    } catch (e, s) {
      debugPrint("$e");
      debugPrint("$s");
    } finally {
      isResponseApproveLoad.value = false;
    }
  }
//   respondLeaveRequest(String leaveId,String status) async {
//     try{
//       if(status=="approve"){
//         isResponseApproveLoad.value=true;
//       }
//       else{
//         isResponseRejectLoad.value=true;
//       }
//       // isResponseLoad.value = true;
//
//       var result = await _repo.respondLeaveRequest(leaveId,status);
//       if(result.status==true){
//         leaveController.sink.add("LEAVE_RESPONSE");
//         showMessage(const MessageType.success("Leave Response Updated successfully"));
//       }
//     }catch (e,s) {
//       showMessage(MessageType.error(e.toString()));
//       print(e);
//       print(s);
//     } finally{
//       if(status=="approve"){
//         isResponseApproveLoad.value=false;
//       }
//       else{
//         isResponseRejectLoad.value=false;
//       }
//       // isResponseLoad.value = false;
//     }
//   }
//#endregion

}