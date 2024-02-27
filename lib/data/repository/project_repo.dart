import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:office/data/network/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/api_response.dart';
import '../network/api_exception.dart';

class ProjectRepository {
  final SharedPreferences prefs;
  final ApiService _api;

  ProjectRepository(this.prefs, this._api);

  Future<ApiResponse2> fetchAllProjects() async {
    var response = await _api.postRequest("employee/detailst", {
      "user_id": prefs.getString('uid'),
      // "user_id": 95,
    });
    if (response == null) {
      ApiException.fromString("response null");
    }
    return ApiResponse2.fromJson(response,response);
  }
  Future<ApiResponse2> fetchAllProjectsDetail(int id) async {

    var response = await _api.postRequest("project/details", {
      "project_id": id,

    });
    if (response == null) {
      ApiException.fromString("response null");
    }
    return ApiResponse2.fromJson(response,response);
  }

  Future<ApiResponse2> fetchAddMemberList(int id) async {

    var response = await _api.postRequest("project/get-mamber", {
      "branch_id": id,
    });
    if (response == null) {
      ApiException.fromString("response null");
    }
    return ApiResponse2.fromJson(response,response);
  }
  Future<ApiResponse2> AddMember(int Projectid, data) async {

    var response = await _api.postRequest("project/post-add-mamber", {
      "mamber_user_id": data,
      "project_id":Projectid
    });
    if (response == null) {
      ApiException.fromString("response null");
    }
    return ApiResponse2.fromJson(response,response);
  }
  Future<ApiResponse2> AddComment(String Comment,String private,int Projectid) async {
    var response = await _api.postRequest("project/post-add-comment", {
      "user_id": prefs.getString('uid'),
      "comment":Comment,
      "privates": private,
      "project_id":Projectid
    });
    if (response == null) {
      ApiException.fromString("response null");
    }
    return ApiResponse2.fromJson(response,response);
  }
  Future<ApiResponse2> AddNotes(String Comment,String private,int Projectid,String SpecificMember,String memberid) async {
    Map<String, dynamic> data = {
      "user_id": prefs.getString('uid'),
      "notes":Comment,
      "privates": private,
      "proj_id":Projectid,
      "specific_member_notes":SpecificMember,
    };
    if(SpecificMember =='yes') {
      data['membernotes_id'] = memberid;
    }
    var response = await _api.postRequest("project/post-add-notis", data);

    if (response == null) {
      ApiException.fromString("response null");
    }
    return ApiResponse2.fromJson(response,response);
  }
  Future<ApiResponse2> AddFiles(String filename,String private,int Projectid,File? image) async {
    var response = await _api.postRequest("project/post-files",withFile: true, {
      "user_id": prefs.getString('uid'),
      "file_name":filename,
      "privates": private,
      "project_id":Projectid,
      "files":await MultipartFile.fromFile(image!.path,
       filename: image.path.split('/').last)
    });

    if (response == null) {
      ApiException.fromString("response null");
    }
    return ApiResponse2.fromJson(response,response);
  }
  Future<ApiResponse2> AddCrediental(String Comment,String private,int Projectid,String SpecificMember,String title,String memberid) async {

    Map<String, dynamic> data = {
      "user_id": prefs.getString('uid'),
      "p_description":Comment,
      "privates": private,
      "proj_id":Projectid,
      "specific_member_status":SpecificMember,
      "title":title
    };
    if(SpecificMember =='yes') {
      data['member_id'] = memberid;
    }
    var response = await _api.postRequest("project/post-add-credential", data);

    if (response == null) {
      ApiException.fromString("response null");
    }
    return ApiResponse2.fromJson(response,response);
  }

  Future<ApiResponse2> AddLink(String Comment,String private,int Projectid,String title) async {
    var response = await _api.postRequest("project/post-link-add", {
      "user_id": prefs.getString('uid'),
      "other_link_info":Comment,
      "privates": private,
      "project_id":Projectid,
      "links":title,
      "link_type":4
    });

    if (response == null) {
      ApiException.fromString("response null");
    }
    return ApiResponse2.fromJson(response,response);
  }
  Future<ApiResponse2> getUserDetail(int userid)async{
    var response=await _api.getRequest("user/details",data: {
      "user_id":userid,
    });
    if (response == null) {
      ApiException.fromString("response null");
    }
    return ApiResponse2.fromJson(response,response);
  }
  Future<ApiResponse2> getlinkList()async{
    var response=await _api.getRequest("project/projectetype-list");
    if (response == null) {
      ApiException.fromString("response null");
    }
    return ApiResponse2.fromJson(response,response);
  }
  Future<ApiResponse2> getexpenseCurrency()async{
    var response=await _api.getRequest("project/projectcurrency-list");
    if (response == null) {
      ApiException.fromString("response null");
    }
    return ApiResponse2.fromJson(response,response);
  }
  Future<ApiResponse2> getexpenseCategory()async{
    var response=await _api.getRequest("project/projectcategory-list");
    if (response == null) {
      ApiException.fromString("response null");
    }
    return ApiResponse2.fromJson(response,response);
  }
  Future<ApiResponse2> getexpensepaymentType()async{
    var response=await _api.getRequest("project/projectetype-list");
    if (response == null) {
      ApiException.fromString("response null");
    }
    return ApiResponse2.fromJson(response,response);
  }



}
