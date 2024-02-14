import 'package:office/data/model/notes_model.dart';
import 'package:office/data/network/api_exception.dart';
import 'package:office/data/network/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/api_response.dart';

class NotesRepository {
  final SharedPreferences prefs;
  final ApiService _api;

  NotesRepository(this.prefs, this._api);


  Future<ApiResponse2<List<NotesModel>>> fetchNotesList() async{
    var response= await _api.getRequest("user/get_notes", data: {
      "user_id": prefs.getString('uid')
    });
    if(response==null){
      throw ApiException.fromString("response null");
    }
    return ApiResponse2.fromJson(response, List.from((response['data'] ?? []).map((e) => NotesModel.fromJson(e))));
  }

  Future<ApiResponse2> addNotes(String title,String description) async {
    var response = await _api.postRequest("user/add_notes", {
      "user_id": prefs.getString('uid'),
      "title": title,
      "description": description,
    });
    if (response == null) {
      throw ApiException.fromString("response null");
    }
    print("value ${response['data']}");
    return ApiResponse2.fromJson(response);
  }

  Future<ApiResponse2> editNotes(int id,String title,String description) async {
    var response = await _api.postRequest("user/edit_notes", {
      "user_id": prefs.getString('uid'),
      "notes_id":id,
      "title": title,
      "description": description,
    });
    if (response == null) {
      throw ApiException.fromString("response null");
    }
    print("value ${response['data']}");
    return ApiResponse2.fromJson(response);
  }

}