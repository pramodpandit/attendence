import 'package:flutter/material.dart';
import 'package:office/data/repository/notice_repo.dart';
import 'package:office/data/model/notice_board.dart';
import 'package:office/utils/message_handler.dart';

import 'bloc.dart';

class NoticeBloc extends Bloc {
  final NoticeRepository _repo;

  NoticeBloc(this._repo);

  ValueNotifier<bool> loading= ValueNotifier(false);
  ValueNotifier<List<NoticeBoard>> noticeBoards=ValueNotifier([]);


  fetchNoticeBoards() async{
    try{
      loading.value = true;
      var result = await _repo.fetchNoticeBoards();
      if(result.status){
        noticeBoards.value = result.data ?? [];
      }
    }catch (e) {
      showMessage(MessageType.error(e.toString()));
    } finally {
      loading.value = false;
    }
  }

}