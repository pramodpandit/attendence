import 'package:office/data/model/api_response.dart';
import 'package:office/data/model/notice_board.dart';
import 'package:office/data/network/api_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/api_service.dart';

class NoticeRepository {
  final SharedPreferences prefs;
  final ApiService _api;

  NoticeRepository(this.prefs, this._api);


  Future<ApiResponse2<List<NoticeBoard>>> fetchNoticeBoards() async{
    var response= await _api.getRequest("noticeboard/getnoticeboards", data: {
      "user_id": prefs.getString('uid')
    });
    if(response==null){
      throw ApiException.fromString("response null");
    }
    return ApiResponse2.fromJson(response, List.from((response['data'] ?? []).map((e) => NoticeBoard.fromJson(e))));
  }
}
