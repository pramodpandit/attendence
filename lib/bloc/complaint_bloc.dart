import 'dart:async';

import 'package:flutter/material.dart';
import 'package:office/bloc/bloc.dart';
import 'package:office/data/model/complaint_list_model.dart';
import 'package:office/data/repository/complaint_repo.dart';
import 'package:office/utils/message_handler.dart';

class ComplaintBloc extends Bloc {
  final ComplaintRepository _repo;

  ComplaintBloc(this._repo);

  TextEditingController tittleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  ValueNotifier<bool> isSubmit = ValueNotifier(false);
  ValueNotifier<bool> isListLoading = ValueNotifier(false);
  List<ComplaintList> progressList = [];
  List<ComplaintList> reviewedList = [];
  String? complainTo;

   init() async {
    await complaintList('inprocess');
    print(progressList.length);
    await complaintList('resolve');
    print(reviewedList.length);
  }
  initEmployee() async {
    await complaintList('inprocess',getComplaint: "1");
    print(progressList.length);
    await complaintList('resolve',getComplaint: "1");
    print(reviewedList.length);
  }

  complaintList(String status,{String? getComplaint}) async {
    try{
      isListLoading.value = true;
      var result = await _repo.fetchComplaintList(status,getComplaint: getComplaint);
      if(result.status == true && result.data != null){
        if(status == 'resolve'){
          reviewedList = [];
          reviewedList = result.data!.reversed.toList();
        }
        if(status == 'inprocess'){
          progressList = [];
          progressList = result.data!.reversed.toList();
        }
      }
    }catch (e) {
      showMessage(MessageType.error(e.toString()));
    } finally {
      isListLoading.value = false;
    }
  }

  StreamController<String> complainStream = StreamController.broadcast();
  addComplaint() async {
    try{
      isSubmit.value = true;
      if(complainTo == null){
        showMessage(MessageType.error('All Fields are required!'));
        return;
      }
      print("value $complainTo");
      var result = await _repo.addComplaint(tittleController.text, descriptionController.text, complainTo!);
      if(result.status){
        complainStream.sink.add('success');
        tittleController.text='';
        descriptionController.text='';
        complainTo="";
      }
    }catch (e) {
      showMessage(MessageType.error(e.toString()));
    } finally{
      isSubmit.value = false;
    }
  }


  //#region -Review Complain
  ValueNotifier<bool> isReviewComplainLoad = ValueNotifier(false);
  reviewComplain(String complainId,String status) async {
    try{

      isReviewComplainLoad.value = true;

      var result = await _repo.reviewComplain(complainId,status);
      if (result is Map && result['success'] == true){
        complainStream.sink.add("REVIEW_COMPLAIN");
        showMessage(const MessageType.success("Review Complain Updated successfully"));
      }
    }catch (e,s) {
      showMessage(MessageType.error(e.toString()));
      print(e);
      print(s);
    } finally{
      isReviewComplainLoad.value = false;
    }
  }
//#endregion


}