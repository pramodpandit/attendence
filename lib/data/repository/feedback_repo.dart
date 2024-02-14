import 'package:office/data/model/api_response.dart';
import 'package:office/data/model/feedback_model.dart';
import 'package:office/data/network/api_exception.dart';
import 'package:office/data/network/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeedbackRepository {
  final SharedPreferences prefs;
  final ApiService _api;

  FeedbackRepository(this.prefs, this._api);

   Future<ApiResponse2<List<FeedbackModel>>> feedbackList({String? allFeedback})async{
    var response=await _api.getRequest("feedback/records",data: {
      "user_id":prefs.getString('uid'),
      "allfeedback":allFeedback,
    });
    return ApiResponse2.fromJson(response,List.from((response['data'] ?? []).map((e) => FeedbackModel.fromJson(e))));
  }

  Future<ApiResponse2> addFeedback(String message) async{
    var response= await _api.postRequest("feedback/add_feedback",
        {
          "user_id":prefs.getString('uid'),
          "message":message
        });
    if(response==null){
      ApiException.fromString("response null");
    }
    return ApiResponse2.fromJson(response);
  }
}