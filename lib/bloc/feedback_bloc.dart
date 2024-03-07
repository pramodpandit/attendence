import 'dart:async';
import 'package:flutter/material.dart';
import 'package:office/bloc/bloc.dart';
import 'package:office/data/model/feedback_model.dart';
import 'package:office/data/repository/feedback_repo.dart';
import 'package:office/utils/message_handler.dart';

class FeedbackBloc extends Bloc {
  final FeedbackRepository _repo;
  FeedbackBloc(this._repo);
  ValueNotifier<bool> isFeedbackLoading = ValueNotifier(false);
    List<FeedbackModel> feedbackData = [];
    feedbackList({String? allFeedBack}) async {
     try{
      isFeedbackLoading.value = true;
      feedbackData = [];
      var result = await _repo.feedbackList(allFeedback: allFeedBack);
      if(result.status && result.data != null){
        feedbackData = result.data!.toList();
      }
    }catch (e,s) {
      debugPrint("$e");
      debugPrint("$s");
    }finally{
      isFeedbackLoading.value = false;
    }
  }
  ValueNotifier<bool> isAddFeedbackLoading = ValueNotifier(false);
  StreamController<String> feedbackStream = StreamController.broadcast();
  TextEditingController feedbackController = TextEditingController();
  addFeedback() async{
      try{
      isAddFeedbackLoading.value = true;
      var result = await _repo.addFeedback(feedbackController.text);
      if(result.status){
        feedbackStream.sink.add('success');
      }
      else{
        showMessage(MessageType.error("Something went wrong"));
      }
    }catch (e,s) {
      debugPrint("$e");
      debugPrint("$s");
    }finally{
      isAddFeedbackLoading.value = false;
    }
  }
}
