import 'dart:io';
import 'package:dio/dio.dart';
import 'package:office/data/network/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/api_response.dart';
import '../network/api_exception.dart';

class PostRepository {
  final SharedPreferences prefs;
  final ApiService _api;

  PostRepository(this.prefs, this._api);

  //add post::
  Future<ApiResponse3> addFeedback(String text, File? image) async {
    var response = await _api.postRequest("addpost", {
      "user_id": prefs.getString('uid'),
      "text": text,
      "image": await MultipartFile.fromFile(image!.path,
          filename: image.path.split('/').last)
    },withFile: true);
    if (response == null) {
      ApiException.fromString("response null");
    }
    return ApiResponse3.fromJson(response);
  }
  Future<ApiResponse3> DeletePost(int id) async {

    var response = await _api.postRequest("deletepost", {
      "id": id,
    },);
    if (response == null) {
      ApiException.fromString("response null");
    }
    return ApiResponse3.fromJson(response);
  }

  Future<ApiResponse3> likePostApi(Map<String,dynamic> data) async {

    var response = await _api.postRequest("post-like", data);
    if (response == null) {
      ApiException.fromString("response null");
    }
    return ApiResponse3.fromJson(response);
  }
}
