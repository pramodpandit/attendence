import 'package:office/data/model/api_response.dart';
import 'package:office/data/model/complaint_list_model.dart';
import 'package:office/data/network/api_exception.dart';
import 'package:office/data/network/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ComplaintRepository {
  final SharedPreferences prefs;
  final ApiService _api;

  ComplaintRepository(this.prefs, this._api);

  Future<ApiResponse2<List<ComplaintList>>> fetchComplaintList(
      String status,{String? getComplaint}) async {
    var response = await _api.getRequest("complaint", data: {
      "user_id": prefs.getString('uid'),
      "type": "my",
      "status": status,
      "getcomplaint":getComplaint,
    });
    if (response == null) {
      throw ApiException.fromString("response null");
    }
    return ApiResponse2.fromJson(response,List.from((response['data'] ?? []).map((e) => ComplaintList.fromJson(e))));
  }

  Future<ApiResponse2> addComplaint(String title,String description, String complainTo) async {
    print("value $complainTo");
    var response = await _api.postRequest("complaint/post-add", {
      "user_id": prefs.getString('uid'),
      "title": title,
      "desp": description,
      "comp_to": complainTo,
    });
    if (response == null) {
      throw ApiException.fromString("response null");
    }
    print("value ${response['data']}");
    return ApiResponse2.fromJson(response);
  }

  reviewComplain(String complainId,String status) async{
    var response= await _api.getRequest("complaint/resolve", data: {
      "complain_id":complainId,
      "status": status
    });
    if(response==null){
      throw ApiException.fromString("response null");
    }
    return response;
  }
}
