import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:office/data/model/ClientDetail.dart';
import 'package:office/data/model/LeadDetail.dart';
import 'package:office/data/model/LeadHistory.dart';
import 'package:office/data/model/api_response.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:office/data/model/lead_for.dart';
import 'package:office/data/model/lead_technology.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/lead.dart';
import '../model/lead_department.dart';
import '../model/user.dart';
import '../network/api_exception.dart';
import '../network/api_service.dart';

class LeadsRepository {
  final SharedPreferences prefs;
  final ApiService _api;

  LeadsRepository(this.prefs, this._api);
  
  Future<ApiResponse2> fetchLeadSource()async {
    try {
      var response = await _api.getRequest("leadSource");
      return ApiResponse2.fromJson(response, response['data']);
    } catch (e) {
      throw Exception('data is not avaible ${e.toString()}');
    }
  }
  Future<ApiResponse2> fetchAllDesignationData()async{
    try{
      var response = await _api.getRequest("fetch_designation_data");
      return ApiResponse2.fromJson(response,response['data']);
    }catch(e){
      throw Exception('data is not avaible ${e.toString()}');
    }
  }
  Future<ApiResponse2> fetchAllDepartmentData()async{
    try{
      var response = await _api.getRequest("fetch_data");
      return ApiResponse2.fromJson(response,response['data']);
    }catch(e){
      throw Exception('data is not avaible ${e.toString()}');
    }
  }
  Future<ApiResponse2> fetchAllClientsData()async{
    try{
      var response = await _api.getRequest("fetch_all_client");
      return ApiResponse2.fromJson(response,response['data']);
    }catch(e){
      throw Exception('data is not avaible ${e.toString()}');
    }
  }
  Future<ApiResponse2> fetchTechnologyData()async{
    try{
      var response = await _api.getRequest("technology");
      return ApiResponse2.fromJson(response,response['data']);
    }catch(e){
      throw Exception('data is not avaible ${e.toString()}');
    }
  }
  Future<ApiResponse2> fetchPortfolioCategoryData()async{
    try{
      var response = await _api.getRequest("portfolio/category");
      return ApiResponse2.fromJson(response,response['data']);
    }catch(e){
      throw Exception('data is not avaible ${e.toString()}');
    }
  }
  Future<ApiResponse2> fetchAllCountryData()async{
    try{
      var response = await _api.getRequest("get-country");
      return ApiResponse2.fromJson(response,response['data']);
    }catch(e){
      throw Exception('data is not avaible ${e.toString()}');
    }
  }
  Future<ApiResponse2> fetchAllStateData(String countryId)async{
    try{
      var response = await _api.getRequest("get-state",data: {
        "country_id" : countryId,
      });
      return ApiResponse2.fromJson(response,response['data']);
    }catch(e){
      throw Exception('data is not avaible ${e.toString()}');
    }
  }
  Future<ApiResponse2> fetchAllCityData(String countryId, String stateId)async{
    try{
      var response = await _api.getRequest("get-city",data: {
        "country_id" : countryId,
        "state_id" : stateId,
      });
      return ApiResponse2.fromJson(response,response['data']);
    }catch(e){
      throw Exception('data is not avaible ${e.toString()}');
    }
  }

  Future<ApiResponse2> leadsData(String type) async {
    try{
      SharedPreferences _pref = await SharedPreferences.getInstance();
      Map<String, dynamic> data = {
       "emp_id": _pref.getString('uid')
      };
      var response= await _api.postRequest("leads",data);
      if (response == null) {
        ApiException.fromString("response null");
      }
      return ApiResponse2.fromJson(response,response["data"]["lead"][type]);
    }catch(e){
      print("data is not avaible ${e.toString()}");
      throw Exception('data is not avaible ${e.toString()}');
    }

  }
  Future<ApiResponse2> Add(String url,Map<String,dynamic> data,) async {
    try{
      SharedPreferences _pref = await SharedPreferences.getInstance();
      // Map<String, dynamic> data = {
      //   "user_id": _pref.getString('uid'),
      //   "lead_id":id,
      //   "title":title,
      //   "description":descripton
      // };
      var response= await _api.postRequest(url,data);
      if (response == null) {
        ApiException.fromString("response null");
      }
      return ApiResponse2.fromJson(response,response["data"]);
    }catch(e){
      print("data is not avaible ${e.toString()}");
      throw Exception('data is not avaible ${e.toString()}');
    }
  }


  Future<ApiResponse2> specificLeadData(String leadId,String type) async {
    try{
      SharedPreferences _pref = await SharedPreferences.getInstance();
      var response= await _api.getRequest("leads_details",data: {
        "emp_id" : _pref.getString("uid"),
        "lead_id" : leadId,
      });
      if (response == null) {
        ApiException.fromString("response null");
      }
      print("the dat is ${response['totaldata']['lead_details'][type]}");
      if(type == "user"){
        return ApiResponse2.fromJson(response,[response['totaldata']['lead_details'][type]]);
      }
      return ApiResponse2.fromJson(response,response['totaldata']['lead_details'][type]);
    }catch(e){
      print("data is not avaible ${e.toString()}");
      throw Exception('data is not avaible ${e.toString()}');
    }

  }

  Future<ApiResponse<List<LeadDetail>>> getLeads(int page,
      {String? eid, String? sort, bool sortAsc = false, String? filter}) async {
    Map<String, dynamic> data = {
      "uid":prefs.getString("uid"),
      "page": page,
      "sortType": sortAsc ? "ASC" : "DESC"
    };
    if (eid != null) {
      data['eid'] = eid;
    }
    if (sort != null) {
      data['sort'] = sort;
    }
    if (filter != null) {
      data['filter'] = filter;
    }
    var res = await _api.getRequest('leads',
        data: data, requireToken: true, cacheRequest: false);
    return ApiResponse.fromJson(
        res, List.from((res['data'] ?? []).map((e) => LeadDetail.fromJson(e))));
  }

  Future<ApiResponse<List<ClientDetail>>> getClients(int page,
      {String? eid,
      String? sort,
      bool sortAsc = false,
      String? filter,
      bool showAll = false,
      String? searchQuery}) async {
    Map<String, dynamic> data = {
      "page": page,
      "sortType": sortAsc ? "ASC" : "DESC",
    };
    if (eid != null) {
      data['eid'] = eid;
    }
    if (sort != null) {
      data['sort'] = sort;
    }
    if (filter != null) {
      data['filter'] = filter;
    }
    if (showAll) {
      data['all'] = '1';
    }
    if(searchQuery!=null) {
      data['q'] = searchQuery;
    }
    var res = await _api.getRequest('clients',
        data: data, requireToken: true, cacheRequest: false);
    return ApiResponse.fromJson(res,
        List.from((res['data'] ?? []).map((e) => ClientDetail.fromJson(e))));
  }

  Future<ApiResponse> createNewLead(Map<String,dynamic> lead) async {
    Map<String, dynamic> data = {

    };
    data.addAll(lead);
    // if (image != null) {
    //   data['image'] = await MultipartFile.fromFile(image.path,
    //       filename: image.path.split('/').last);
    // }
    var res = await _api.postRequest('lead/add_lead', data);
    print("the main data is : ${res}");
    return ApiResponse.fromJson(res);
  }

  Future<ApiResponse> createNewClient(String client, {File? image}) async {
    Map<String, dynamic> data = {
      'client': client,
    };
    if (image != null) {
      data['image'] = await MultipartFile.fromFile(image.path,
          filename: image.path.split('/').last);
    }
    var res = await _api.postRequest('create_client', data,
        withFile: true, cacheRequest: false, requireToken: true);
    return ApiResponse.fromJson(res);
  }

  Future<ApiResponse<ClientDetail>> getClientDetail(String clientId) async {
    var res = await _api.getRequest('clients-details/$clientId',
        cacheRequest: false, requireToken: true);
    return ApiResponse.fromJson(res, res['data']!=null ? ClientDetail.fromJson(res['data']) : null);
  }

  Future<ApiResponse<LeadDetail>> getLeadDetails(String leadId) async {
    Map<String, dynamic> data = {
      "uid":prefs.getString("uid"),
      "lead_id": leadId
    };
    var res = await _api.getRequest('leads_details', data: data, cacheRequest: false, requireToken: true);
    return ApiResponse.fromJson(res, res['data']!=null ? LeadDetail.fromJson(res['data']) : null);
  }

  // Future<ApiResponse<List<ServiceDetail>>> getClientServices(
  //     String clientId) async {
  //   // Map<String, dynamic> data = {
  //   //   'id': clientId,
  //   // };
  //   var res = await _api.getRequest('client-services/$clientId', cacheRequest: false, requireToken: true);
  //   return ApiResponse.fromJson(res,
  //       List.from((res['data'] ?? []).map((e) => ServiceDetail.fromJson(e))));
  // }

  Future<ApiResponse> editClientDetails(String client, {File? image}) async {
    Map<String, dynamic> data = {
      'client': client,
    };
    if (image != null) {
      data['image'] = await MultipartFile.fromFile(image.path,
          filename: image.path.split('/').last);
    }
    var res = await _api.postRequest('edit_client', data,
        withFile: true, cacheRequest: false, requireToken: true);
    return ApiResponse.fromJson(res);
  }

  Future<ApiResponse> editLeadDetails(String lead, {File? image}) async {
    Map<String, dynamic> data = {
      'lead': lead,
    };
    if (image != null) {
      data['image'] = await MultipartFile.fromFile(image.path,
          filename: image.path.split('/').last);
    }
    var res = await _api.postRequest('edit_lead', data,
        withFile: true, cacheRequest: false, requireToken: true);
    return ApiResponse.fromJson(res);
  }

  Future<ApiResponse> createLeadWithClient(String clientId, String requirement, {String? empId}) async {
    Map<String, dynamic> data = {
      'client_id': clientId,
      'requirement': requirement,
    };
    if(empId!=null) {
      data['eid'] = empId;
    }
    var res = await _api.postRequest('create-lead-with-client', data, cacheRequest: false, requireToken: true);
    return ApiResponse.fromJson(res);
  }

  Future<ApiResponse> createServiceWithClient(String clientId, String service, String amount, DateTime date) async {
    Map<String, dynamic> data = {
      'client_id': clientId,
      'service_name': service,
      'service_date': DateFormat('yyyy-MM-dd HH:mm:ss').format(date),
      'amount': amount,
    };
    var res = await _api.postRequest('create_service_with_client', data, cacheRequest: false, requireToken: true);
    return ApiResponse.fromJson(res);
  }

  Future<ApiResponse> updateLeadStatus(String leadId, String title, String description, String status, {DateTime? schedule}) async {
    Map<String, dynamic> data = {
      'lead_id': leadId,
      'title': title,
      'description': description,
      'status': status,
    };
    if(schedule!=null) {
      data['schedule'] = DateFormat('yyyy-MM-dd HH:mm:ss').format(schedule);
    }
    var res = await _api.postRequest('add-lead-history', data, cacheRequest: false, requireToken: true);
    return ApiResponse.fromJson(res);
  }

  Future<ApiResponse> createServiceWithLead(String leadId, String service, String amount, DateTime date) async {
    Map<String, dynamic> data = {
      'lead_id': leadId,
      'service_name': service,
      'service_date': DateFormat('yyyy-MM-dd HH:mm:ss').format(date),
      'amount': amount,
    };
    var res = await _api.postRequest('create_service_with_lead', data, cacheRequest: false, requireToken: true);
    return ApiResponse.fromJson(res);
  }

  Future<ApiResponse<List<LeadDetail>>> getClientLeads(int page, String clientId) async {
    Map<String, dynamic> data = {
      "page": page,
      "client": clientId
    };

    var res = await _api.getRequest('leads', data: data, requireToken: true, cacheRequest: false);
    return ApiResponse.fromJson(
        res, List.from((res['data'] ?? []).map((e) => LeadDetail.fromJson(e))));
  }

  // Future<ApiResponse<List<ServiceDetail>>> getPasLeadServices(String leadId) async {
  //   Map<String, dynamic> data = {
  //     "lead_id": leadId
  //   };
  //
  //   var res = await _api.getRequest('past_lead_service', data: data, requireToken: true, cacheRequest: false);
  //   return ApiResponse.fromJson(
  //       res, List.from((res['data'] ?? []).map((e) => ServiceDetail.fromJson(e))));
  // }

  Future<ApiResponse<List<LeadHistory>>> getPastServiceLeadHistory(int page, String leadId) async {
    Map<String, dynamic> data = {
      "page": page,
      "lead_id": leadId
    };

    var res = await _api.getRequest('past_service_lead_history', data: data, requireToken: true, cacheRequest: false);
    return ApiResponse.fromJson(
        res, List.from((res['data'] ?? []).map((e) => LeadHistory.fromJson(e))));
  }


  //lead repository

  Future<List<LeadSource>> allLeadSource() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    var response= await _api.getRequest("leads");
    if(response==null){
      throw ApiException.fromString("response null");
    }
    List<dynamic> list2 = (response['data'] as List<dynamic>);
    List<LeadSource> resp = list2.map<LeadSource>((item)=>LeadSource.fromJson(item)).toList();
    return resp;
  }

  Future<List<User>> allManageBy() async{
    var response= await _api.getRequest("employee",);
    if(response==null){
      throw ApiException.fromString("response null");
    }
    List<dynamic> list2 = (response['data'] as List<dynamic>);
    List<User> resp = list2.map<User>((item)=>User.fromJson(item)).toList();
    return resp;
  }

  Future<List<LeadDepartment>> department() async{
    var response= await _api.getRequest("department",);
    if(response==null){
      throw ApiException.fromString("response null");
    }
    List<dynamic> list2 = (response['data'] as List<dynamic>);
    List<LeadDepartment> resp = list2.map<LeadDepartment>((item)=>LeadDepartment.fromJson(item)).toList();
    return resp;
  }

  Future<List<LeadTechnology>> technology() async{
    var response= await _api.getRequest("technology",);
    if(response==null){
      throw ApiException.fromString("response null");
    }
    List<dynamic> list2 = (response['data'] as List<dynamic>);
    List<LeadTechnology> resp = list2.map<LeadTechnology>((item)=>LeadTechnology.fromJson(item)).toList();
    return resp;
  }

  Future<List<LeadFor>> leadFor() async{
    var response= await _api.getRequest("ownproductlist",);
    if(response==null){
      throw ApiException.fromString("response null");
    }
    List<dynamic> list2 = (response['data'] as List<dynamic>);
    List<LeadFor> resp = list2.map<LeadFor>((item)=>LeadFor.fromJson(item)).toList();
    return resp;
  }

  Future<ApiResponse> createNewLeadFile(Map<String,dynamic> data) async{
    var response= await _api.postRequest("lead/add_files",data,withFile: true);
    if(response==null){
      throw ApiException.fromString("response null");
    }
    return ApiResponse.fromJson(response,response['data']);
  }

  Future<ApiResponse2> getLinkList() async{
    var response= await _api.getRequest("linktypes");
    if(response==null){
      throw ApiException.fromString("response null");
    }
    return ApiResponse2.fromJson(response,response['data']);
  }

  Future<ApiResponse2> AddLink(String leadId, String linkType, String links, String other) async {
    var response = await _api.postRequest("lead/add_links", {
      "user_id": prefs.getString('uid'),
      "lead_id":leadId,
      "link_type":linkType,
      "links":links,
      "other_link_info":other,
    });

    if (response == null) {
      ApiException.fromString("response null");
    }
    return ApiResponse2.fromJson(response,response);
  }

  // lead logs

  Future<ApiResponse2> fetchAllBranchList() async{
    var response= await _api.getRequest("get-branch",data: {
      "user_id" : prefs.getString("uid"),
    });
    if(response==null){
      throw ApiException.fromString("response null");
    }
    return ApiResponse2.fromJson(response,response['data']);
  }
  Future<ApiResponse2> fetchAllEmployeeList() async{
    var response= await _api.getRequest("user/get_all_employee_details",data: {
      "user_id" : prefs.getString("uid"),
    });
    if(response==null){
      throw ApiException.fromString("response null");
    }
    return ApiResponse2.fromJson(response,response['data1']);
  }
  Future<ApiResponse2> fetchSpecificEmployeeList(String branchId) async{
    var response= await _api.postRequest("project/get-mamber", {
      "branch_id" : branchId,
    });
    if(response==null){
      throw ApiException.fromString("response null");
    }
    return ApiResponse2.fromJson(response,response['data']);
  }
  Future<ApiResponse2> fetchProjectCodeByType(String projectTypeId) async{
    var response= await _api.postRequest("project/type-project",{
      "projectType_id" : projectTypeId,
    });
    if(response==null){
      throw ApiException.fromString("response null");
    }
    return ApiResponse2.fromJson(response,[response['project_code']]);
  }
  Future<ApiResponse2> fetchAllProjectTypeList() async{
    var response= await _api.getRequest("project/projectetype-list");
    if(response==null){
      throw ApiException.fromString("response null");
    }
    return ApiResponse2.fromJson(response,response['data']);
  }
  Future<ApiResponse2> fetchAllCurrencyList() async{
    var response= await _api.getRequest("project/projectcurrency-list");
    if(response==null){
      throw ApiException.fromString("response null");
    }
    return ApiResponse2.fromJson(response,response['data']);
  }

  Future<ApiResponse2> AddLogs(Map<String,dynamic> data) async {
    var response = await _api.postRequest("lead/add_logs", data);

    if (response == null) {
      ApiException.fromString("response null");
    }
    return ApiResponse2.fromJson(response,response);
  }

  // lead logs end

}
