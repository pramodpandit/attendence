import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:office/data/model/ClientDetail.dart';
import 'package:office/data/model/LeadDetail.dart';
import 'package:office/data/model/lead_for.dart';
import 'package:office/data/model/lead_technology.dart';
import 'package:office/data/repository/lead_repository.dart';
import 'package:office/bloc/property_notifier.dart';
import 'package:office/data/model/api_response.dart';
import 'package:office/utils/enums.dart';
import 'package:office/utils/message_handler.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/model/lead.dart';
import '../data/model/lead_department.dart';
import '../data/model/user.dart';
import 'bloc.dart';
import 'bloc.dart';

class LeadsBloc extends Bloc {
  final LeadsRepository _repo;
  LeadsBloc(this._repo);

  ValueNotifier<String> leadType = ValueNotifier("total");
  ValueNotifier<List?> leadData = ValueNotifier(null);
  ValueNotifier<List?> specificLeadData = ValueNotifier(null);
  ValueNotifier<int> downloadLoading = ValueNotifier(-1);

  //ValueNotifier<List> balanceData = ValueNotifier([]);
  Future getLeadData(String type) async {

    try {
      var res = await _repo.leadsData(type);
      leadData.value = res.data;
      print('value is availble:${res.data}');
    } catch(e,s) {
      debugPrint('$e');
      debugPrintStack(stackTrace: s);
    }
  }
  Future getSpecificLeadData(String leadId, String type) async {
    try {
      var res = await _repo.specificLeadData(leadId,type);
      specificLeadData.value = res.data;
    } catch(e,s) {
      debugPrint('the main error : $e');
      debugPrintStack(stackTrace: s);
    }
  }

  ValueNotifier<LoadingState> state = ValueNotifier(LoadingState.loading);

  initLeads() async {
    leadPage = 1;
    leadLastPage = false;
    leads.value.clear();
    leads.notifyListeners();
    getLeads();
    // await Future.wait([
    //   getEmployees(),
    //   getClients()
    // ]);
  }

  ScrollController scrollController = ScrollController();
  scrollListener() {
    if (scrollController.position.extentAfter < 500) {
      if (leadsState.value==LoadingState.done) {
        if (!leadLastPage) {
          getLeads();
        }
      }
    }
  }

  //#region -Leads
  ValueNotifier<LoadingState> leadsState = ValueNotifier(LoadingState.done);
  PropertyNotifier<List<LeadDetail>> leads = PropertyNotifier([]);
  int leadPage = 1;
  bool leadLastPage = false;
  Future getLeads() async {
    try{
      if(leadsState.value==LoadingState.loading || leadsState.value==LoadingState.paginating) {
        return;
      }
      if(leadLastPage) {
        return;
      }
      if(leadPage==1) {
        leadsState.value = LoadingState.loading;
      } else {
        leadsState.value = LoadingState.paginating;
      }
      ApiResponse<List<LeadDetail>> res = await _repo.getLeads(leadPage, sort: sort.value['id'], sortAsc: isAscending.value, filter: filter.value['id']);
      if(res.status) {
        List<LeadDetail> data = res.data ?? [];
        if(data.isEmpty) {
          leadLastPage = true;
        } else {
          leads.value.addAll(data);
          print('fghjk${leads.value}');
          leadPage++;
          leads.notifyListeners();
        }
        leadsState.value = LoadingState.done;
      } else {
        showMessage(MessageType.error(res.message));
        leadsState.value = LoadingState.error;
      }
    } catch(e,s) {
      debugPrint('$e');
      debugPrintStack(stackTrace: s);
      leadsState.value = LoadingState.error;
      rethrow;
    } finally {
      leadsState.value = LoadingState.done;
    }
  }
  //#endregion

  //#region -Sort
  ValueNotifier<Map<String, dynamic>> sort = ValueNotifier({'name': 'Recently Updated', 'id': 'updated_at'});
  ValueNotifier<bool> isAscending = ValueNotifier(false);
  List<Map<String, dynamic>> sortTypes = [
    {'name': 'Name', 'id': 'name'},
    {'name': 'Date Of Creation', 'id': 'created_at'},
    {'name': 'Recently Updated', 'id': 'updated_at'},
    // {'name': 'Joining Date', 'id': 'joining_date'},
  ];

  updateSortType(Map<String, dynamic> sortType) {
    sort.value = sortType;
    initLeads();
  }
  updateSortAsc(bool val) {
    isAscending.value = val;
    initLeads();
  }
  //#endregion

  //#region -Filter
  ValueNotifier<Map<String, dynamic>> filter = ValueNotifier({'name': 'All', 'id': ''});
  List<Map<String, dynamic>> filterTypes = [
    {'name': 'All', 'id': ''},
    {'name': 'Active', 'id': 'Active'},
    {'name': 'Follow Up', 'id': 'FollowUp'},
    {'name': 'Confirmed', 'id': 'Confirmed'},
    {'name': 'Dead', 'id': 'Dead'},
  ];
  updateFilter(Map<String, dynamic> val) {
    filter.value = val;
    initLeads();
  }
  //#endregion


  //#region -Create New Lead
  // PropertyNotifier<List<UserDetail>> employees = PropertyNotifier([]);
  PropertyNotifier<List<ClientDetail>> clients = PropertyNotifier([]);

  Future getClients() async {
    try{
      ApiResponse<List<ClientDetail>> res = await _repo.getClients(1, showAll: true);
      if(res.status) {
        clients.value = res.data ?? [];
      }
    } catch(e,s) {
      debugPrint('$e');
      debugPrintStack(stackTrace: s);
    }
  }
  // Future getEmployees() async {
  //   try{
  //     ApiResponse<List<UserDetail>> res = await _empRepo.getEmployees(1, showAll: true, doNotShowAccountant: true);
  //     if(res.status) {
  //       employees.value = res.data ?? [];
  //     }
  //   } catch(e,s) {
  //     debugPrint('$e');
  //     debugPrintStack(stackTrace: s);
  //   }
  // }

// all apis datas
  ValueNotifier<List?> allLeadSource = ValueNotifier(null);
  ValueNotifier<List?> allDesignationData = ValueNotifier(null);
  ValueNotifier<List?> allDepartmentData = ValueNotifier(null);
  ValueNotifier<List?> allClientData = ValueNotifier(null);
  ValueNotifier<List?> allTechnologyData = ValueNotifier(null);
  ValueNotifier<List?> allPortfolioCategory = ValueNotifier(null);
  ValueNotifier<List?> allCountryData = ValueNotifier(null);
  ValueNotifier<List?> allStateData = ValueNotifier(null);
  ValueNotifier<List?> allCityData = ValueNotifier(null);
// all apis data end

  GlobalKey<FormState> formState = GlobalKey<FormState>();
  ValueNotifier<bool> creating = ValueNotifier(false);

  TextEditingController title = TextEditingController();
  ValueNotifier<String?> source = ValueNotifier(null);
  TextEditingController remark = TextEditingController();
  ValueNotifier<String?> leadStatus = ValueNotifier(null);
  TextEditingController nextFollowUp = TextEditingController();
  ValueNotifier<String?> forLead = ValueNotifier(null);
  ValueNotifier<String?> portfolioCat = ValueNotifier(null);
  // branch
  ValueNotifier<String?> designation = ValueNotifier(null);
  ValueNotifier<String?> yourDepartment = ValueNotifier(null);
  // manage by
  TextEditingController requirements = TextEditingController();
  ValueNotifier<String?> alreadyClient = ValueNotifier(null);
  // if already client = yes
  ValueNotifier<String?> selectClient = ValueNotifier(null);
  // else if no
  TextEditingController firstName = TextEditingController();
  TextEditingController middleName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController alternateEmail = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController alternatePhone = TextEditingController();
  ValueNotifier<String?> clientGender = ValueNotifier(null);
  TextEditingController address = TextEditingController();
  ValueNotifier<String?> country = ValueNotifier(null);
  ValueNotifier<String?> countryState = ValueNotifier(null);
  ValueNotifier<String?> city = ValueNotifier(null);
  TextEditingController pincode = TextEditingController();
  ValueNotifier<String?> companyName = ValueNotifier(null);
  // else end
  ValueNotifier<List> preferenceTechnology = ValueNotifier([]);
  TextEditingController probabilityConversion = TextEditingController();
  TextEditingController lastFollowUp = TextEditingController();

  String? selectedEmpId, clientId, imageURL;

  updateEmployee(String empId) {
    selectedEmpId = empId;
    // for(UserDetail e in employees.value) {
    //   if('${e.id}'==empId) {
    //     employee.value = e;
    //   }
    // }
  }
  updateClient(String cid) {
    clientId = cid;
    for(ClientDetail e in clients.value) {
      if('${e.id}'==cid) {
        // client.value = e;
        // name.text = e.name ?? '';
        phone.text = e.phone ?? '';
        imageURL = e.image ?? '';
      }
    }
  }

  StreamController<String> createLeadController = StreamController.broadcast();

  getLeadSourceData () async{
    try{
      ApiResponse2 res = await _repo.fetchLeadSource();
      allLeadSource.value = res.data;
    }catch(e){
      allLeadSource.value = [];
      showMessage(const MessageType.error("Some error occurred! Please try again!"));
    }
  }
  getAllDesignationData () async{
    try{
      ApiResponse2 res = await _repo.fetchAllDesignationData();
      allDesignationData.value = res.data;
    }catch(e){
      allDesignationData.value = [];
      showMessage(const MessageType.error("Some error occurred! Please try again!"));
    }
  }
  getAllDepartmentData () async{
    try{
      ApiResponse2 res = await _repo.fetchAllDepartmentData();
      allDepartmentData.value = res.data;
    }catch(e){
      allDepartmentData.value = [];
      showMessage(const MessageType.error("Some error occurred! Please try again!"));
    }
  }
  getAllClientsData () async{
    try{
      ApiResponse2 res = await _repo.fetchAllClientsData();
      allClientData.value = res.data;
    }catch(e){
      allClientData.value = [];
      showMessage(const MessageType.error("Some error occurred! Please try again!"));
    }
  }
  getTechnologyData () async{
    try{
      ApiResponse2 res = await _repo.fetchTechnologyData();
      allTechnologyData.value = res.data;
    }catch(e){
      allTechnologyData.value = [];
      showMessage(const MessageType.error("Some error occurred! Please try again!"));
    }
  }
  getPortfolioCategoryData () async{
    try{
      ApiResponse2 res = await _repo.fetchPortfolioCategoryData();
      allPortfolioCategory.value = res.data;
    }catch(e){
      allPortfolioCategory.value = [];
      showMessage(const MessageType.error("Some error occurred! Please try again!"));
    }
  }
  getAllCountryData () async{
    try{
      ApiResponse2 res = await _repo.fetchAllCountryData();
      allCountryData.value = res.data;
    }catch(e){
      allCountryData.value = [];
      showMessage(const MessageType.error("Some error occurred! Please try again!"));
    }
  }
  getAllStateData (String countryId) async{
    try{
      ApiResponse2 res = await _repo.fetchAllStateData(countryId);
      allStateData.value = res.data;
    }catch(e){
      allStateData.value = [];
      showMessage(const MessageType.error("Some error occurred! Please try again!"));
    }
  }
  getAllCityData (String countryId, String stateId) async{
    try{
      ApiResponse2 res = await _repo.fetchAllCityData(countryId,stateId);
      allCityData.value = res.data;
    }catch(e){
      allCityData.value = [];
      showMessage(const MessageType.error("Some error occurred! Please try again!"));
    }
  }

  createNewEmployee() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      // if(await validateEmployee()) {
      //   return;
      // }
      // if(creating.value) {
      //   return;
      // }
      creating.value = true;
      String leadsJSON = "";
      Map<String, dynamic> lead = {
        "getEmp": pref.getString("uid"),
        "lead_title": title.text,
        "source_id": source.value,
        "remark": remark.text,
        "status": leadStatus.value,
        "client_info" : alreadyClient.value,
        "leadfor": forLead.value,
        "designation" : designation.value,
        "department" : yourDepartment.value,
        "employee_id" : pref.getString("uid"),
        "requirement" : requirements.text,
        "technology_skills" : preferenceTechnology.value.map((e) => e['id']).toList().join(","),
        "probability_conversion" : probabilityConversion.text,
        "last_follow_up" : lastFollowUp.text,
      };
      if(leadStatus.value == "open"){
        lead.addAll({
          "next_followup": nextFollowUp.text,
        });
      }
      if(forLead.value == "1"){
        lead.addAll({
          "portfolio_cat" : portfolioCat.value,
        });
      }
      if(alreadyClient.value=="1"){
        lead.addAll({
          "client_id" : selectClient.value
        });
      }else if(alreadyClient.value == "0"){
        lead.addAll({
          "first_name": firstName.text,
          "middle_name" : middleName.text,
          "last_name" : lastName.text,
          "email" : email.text,
          "alternate_email" : alternateEmail.text,
          "phone" : phone.text,
          "alternate_phone" : alternatePhone.text,
          "address" : address.text,
          "gender" : clientGender.value,
          "c_name" : companyName.value,
          "country_id" : country.value,
          "state_id" : countryState.value,
          "city_id" : city.value,
          "pincode" : pincode.text,
        });
      }
      // print("the data is : $lead");
      ApiResponse res = await _repo.createNewLead(lead);
      if(res.status) {
        showMessage(const MessageType.success("Employee Created Successfully"));
        createLeadController.add("SUCCESS");
        // name.clear();
        phone.clear();
        // phone2.clear();
        email.clear();
        // requirement.clear();
        // image.value = null;

      } else {
        showMessage(MessageType.error(res.message));
      }
    } catch(e,s) {
      print("the error is : $e");
      debugPrint('$e');
      debugPrintStack(stackTrace: s);
      showMessage(const MessageType.error("Some error occurred! Please try again!"));
    } finally {
      creating.value = false;
    }
  }

  File? image;
  TextEditingController filepath = TextEditingController();
  TextEditingController fileName = TextEditingController();
  StreamController<String> fileStream = StreamController.broadcast();
  ValueNotifier<bool> addfileLoading  = ValueNotifier(false);

  addNewLeadFiles(int leadId,String private)async{
    addfileLoading.value = true;
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      Map<String, dynamic> data = {
        "user_id": pref.getString("uid"),
        "lead_id" : leadId,
        "file_name" : fileName.text,
        "files" : await MultipartFile.fromFile(image!.path,
            filename: image!.path.split('/').last),
        "privates" : private,
      };
      ApiResponse res = await _repo.createNewLeadFile(data);
      if(res.status) {
        showMessage(const MessageType.success("File Created Successfully"));
      } else {
        showMessage(MessageType.error(res.message));
      }
    } catch(e,s) {
      print("the error is : $e");
      debugPrint('$e');
      debugPrintStack(stackTrace: s);
      showMessage(const MessageType.error("Some error occurred! Please try again!"));
    }finally{
      addfileLoading.value = false;
    }
  }

  // lead add Notes
  TextEditingController titleNotes = TextEditingController();
  TextEditingController descriptionNotes = TextEditingController();
  StreamController<String> NotesStream = StreamController.broadcast();

  Future<void> AddNotes(int id,) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    try {
      Map<String, dynamic> data = {
        "user_id": _pref.getString('uid'),
        "lead_id":id,
        "title":titleNotes.text,
        "description":descriptionNotes.text
      };
      addfileLoading.value = true;
      var result = await _repo.Add('lead/add_notes',data);
      if(result.status == true){
        NotesStream.sink.add('streamNotes');
      }
      showMessage(MessageType.error("Something went wrong"));
    } catch (e, s) {
      debugPrint("$e");
      debugPrint("$s");
    } finally {
      addfileLoading.value = false;
    }
  }

  // add branch in lead
TextEditingController cname = TextEditingController();
TextEditingController c_address = TextEditingController();
TextEditingController c_phone = TextEditingController();
TextEditingController c_email = TextEditingController();
TextEditingController cp_name = TextEditingController();
TextEditingController cp_mobile = TextEditingController();
TextEditingController cp_email = TextEditingController();
TextEditingController cp_location = TextEditingController();
  Future<void> AddBranch(int id,) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    try {
      Map<String, dynamic> data = {
        "user_id": _pref.getString('uid'),
        "lead_id":id,
        "c_name":cname.text,
        "c_address":c_address.text,
        "c_phone":c_phone.text,
        "c_email":c_email.text,
        "cp_name":cp_name.text,
        "cp_mobile":cp_mobile.text,
        "cp_email":cp_email.text,
        "cp_location":cp_location.text,
      };
      addfileLoading.value = true;
      var result = await _repo.Add('lead/add_branches',data);
      if(result.status == true){
        NotesStream.sink.add('streamNotes');
      }
      showMessage(MessageType.error("Something went wrong"));
    } catch (e, s) {
      debugPrint("$e");
      debugPrint("$s");
    } finally {
      addfileLoading.value = false;
    }
  }
  // link all data
  ValueNotifier<List?> allLinkTypes = ValueNotifier(null);

  // link all data end

  ValueNotifier<String?> linkType = ValueNotifier(null);
  TextEditingController link = TextEditingController();
  TextEditingController other = TextEditingController();
  ValueNotifier<bool> addLinkLoading  = ValueNotifier(false);
  StreamController<String> linkSteam = StreamController.broadcast();

  getAllLinkTypes() async{
    try{
      // isUserDetailLoad.value = true;
      var result = await _repo.getLinkList();
      if(result.status && result.data != null){
        allLinkTypes.value = result.data;
      }
    }catch (e, s) {
      print(e);
      print(s);
    }
  }

  Future<void> addLeadLink(String leadId) async {
    try {
      addLinkLoading.value = true;
      var result = await _repo.AddLink(leadId,linkType.value!,link.text,other.text);
      if(result.status == true){
        showMessage(MessageType.success(result.message.toString()));
        linkSteam.sink.add('notes');
      }else{
        showMessage(MessageType.error("Something went wrong"));
      }
    } catch (e, s) {
      debugPrint("$e");
      debugPrint("$s");
    } finally {
      addLinkLoading.value = false;
    }
  }





  // lead logs all data notifiers
  ValueNotifier<List?> allBranchData = ValueNotifier(null);
  ValueNotifier<List?> allEmployeeData = ValueNotifier(null);
  ValueNotifier<List?> allProjectTypes = ValueNotifier(null);
  ValueNotifier<List?> allCurrencyData = ValueNotifier(null);
  // lead logs all data notifiers end

  // lead logs
  ValueNotifier<String?> logStatus = ValueNotifier(null);
  // if logStatus open
  TextEditingController nextFollowUpDate = TextEditingController();
  TextEditingController nextFollowUpTime = TextEditingController();
  // if logStatus open end
  TextEditingController message = TextEditingController();
  // if(log status converted)
  ValueNotifier<String?> projectConvert = ValueNotifier(null);
  // if(log projectConvert yes )
  ValueNotifier<String?> branchType = ValueNotifier(null);
  // if branchType everyone / specific
  ValueNotifier<String?> employeeId = ValueNotifier(null);
      // if branchType everyone end
  ValueNotifier<String?> branchId = ValueNotifier(null);
  // if branchType specific end
  ValueNotifier<String?> projectType = ValueNotifier(null);
  TextEditingController shortCode = TextEditingController();
  TextEditingController projectCode = TextEditingController();
  TextEditingController startDate = TextEditingController();
  ValueNotifier<String?> deadline = ValueNotifier(null);
  // if deadline yes
  TextEditingController deadlineDate = TextEditingController();
  // if deadline yes end
  TextEditingController projectSummary = TextEditingController();
  TextEditingController notes = TextEditingController();
  ValueNotifier<String?> currency = ValueNotifier(null);
  ValueNotifier<String?> projectCostType = ValueNotifier(null);
  TextEditingController amount = TextEditingController();
  ValueNotifier<String?> withTax = ValueNotifier(null);
  // if withTax yes
  TextEditingController taxPercentage = TextEditingController();
  // if withTax yes end

  ValueNotifier<bool> addLogsLoading = ValueNotifier(false);

  getAllBranchDetails() async{
    try{
      var result = await _repo.fetchAllBranchList();
      if(result.status && result.data != null){
        allBranchData.value = result.data;
      }
    }catch (e, s) {
      print(e);
      print(s);
    }
  }
  getAllEmployeeDetails() async{
    try{
      var result = await _repo.fetchAllEmployeeList();
      if(result.status && result.data != null){
        allEmployeeData.value = result.data;
      }
    }catch (e, s) {
      print(e);
      print(s);
    }
  }
  getAllCurrencyData() async{
    try{
      // isUserDetailLoad.value = true;
      var result = await _repo.fetchAllCurrencyList();
      if(result.status && result.data != null){
        allCurrencyData.value = result.data;
      }
    }catch (e, s) {
      print(e);
      print(s);
    }
  }

  getAllProjectTypes() async{
    try{
      // isUserDetailLoad.value = true;
      var result = await _repo.fetchAllProjectTypeList();
      if(result.status && result.data != null){
        allProjectTypes.value = result.data;
      }
    }catch (e, s) {
      print(e);
      print(s);
    }
  }

  addLeadLogs(String leadId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Map<String,dynamic> data = {
      "user_id" : pref.getString("uid"),
      "lead_id" : leadId,
      "status" : logStatus.value,
      "message" : message.text,
    };
    if(leadStatus.value == "open"){
      data.addAll({
        "next_followup" : nextFollowUpDate.text,
        "next_followup_time" : nextFollowUpTime.text,
      });
    }
    if(leadStatus.value == "converted"){
      data.addAll({
        "project_convert" : projectConvert.value,
      });
    }
    if(leadStatus.value == "converted" && projectConvert.value == "yes"){
      data.addAll({

      });
    }

    try {
      addLogsLoading.value = true;
      var result = await _repo.AddLogs(data);
      if(result.status == true){
        showMessage(MessageType.success(result.message.toString()));
        linkSteam.sink.add('notes');
      }else{
        showMessage(MessageType.error("Something went wrong"));
      }
    } catch (e, s) {
      debugPrint("$e");
      debugPrint("$s");
    } finally {
      addLogsLoading.value = false;
    }
  }

  // leadLogs end

  Future<bool> validateEmployee() async {
    if(formState.currentState!.validate()) {
      // if(image.value==null) {
      //   showMessage(const MessageType.error('Profile image required!'));
      //   return true;
      // }
      SharedPreferences pref = await SharedPreferences.getInstance();
      if(pref.getBool('isAdmin')==true) {
        // if(employee.value==null) {
        //   showMessage(const MessageType.error('Employee is required!'));
        //   return true;
        // }
      }

      return false;
    }
    return true;
  }


//#endregion



  //Lead bloc

  List<LeadSource> leadSource = [];
  String? selectedLeadSource;
  updateLC(String value) {
    selectedLeadSource = value;
  }
  Future fetchAllLeadSource() async {
    try {
      List<LeadSource> res = await _repo.allLeadSource();
      leadSource = res;
    } catch(e,s) {
      debugPrint('$e');
      debugPrintStack(stackTrace: s);
    }
  }

  List<User> manageBy = [];
  String? selectedManageBy;
  updateMB(String value) {
    selectedManageBy = value;
  }
  fetchAllManageBy() async {
    try {
      List<User> res = await _repo.allManageBy();
      manageBy = res;
    } catch(e,s) {
      debugPrint('$e');
      debugPrintStack(stackTrace: s);
    }
  }

  List<LeadDepartment> departmentList = [];
  String? selectedDepartment;
  updateDepartment(String value) {
    selectedDepartment = value;
  }
  department() async {
    try {
      List<LeadDepartment> res = await _repo.department();
      departmentList = res;
    } catch(e,s) {
      debugPrint('$e');
      debugPrintStack(stackTrace: s);
    }
  }

  List<LeadTechnology> technologyList = [];
  String? selectedTechnology;
  updateTechnology(String value) {
    selectedTechnology = value;
  }
  technology() async {
    try {
      List<LeadTechnology> res = await _repo.technology();
      technologyList = res;
    } catch(e,s) {
      debugPrint('$e');
      debugPrintStack(stackTrace: s);
    }
  }

  List<LeadFor> leadForList = [];
  String? selectedLeadFor;
  updateLeadFor(String value) {
    selectedLeadFor = value;
  }
  leadFor() async {
    try {
      List<LeadFor> res = await _repo.leadFor();
      leadForList = res;
    } catch(e,s) {
      debugPrint('$e');
      debugPrintStack(stackTrace: s);
    }
  }

  List<String> status = [
    'Open',
    'Dead',
    'Converted',
  ];
  selectStatus(data) {
    status = data;
  }

  List<String> gender = [
    'Male',
    'Female',
    'Other',
  ];
  selectGender(data) {
    gender = data;
  }

  // TextEditingController leadTitleController = TextEditingController();
  // TextEditingController remarkController = TextEditingController();
  // TextEditingController requirementsController = TextEditingController();
  // TextEditingController nameController = TextEditingController();
  // TextEditingController emailController = TextEditingController();
  // TextEditingController alternativeEmailController = TextEditingController();
  // TextEditingController phoneController = TextEditingController();
  // TextEditingController alternativePhoneController = TextEditingController();
  // TextEditingController addressController = TextEditingController();
  // TextEditingController companyNameController = TextEditingController();
  // TextEditingController probabilityConversionController = TextEditingController();
  // ValueNotifier<DateTime?> lastFollowup = ValueNotifier(DateTime.now());
  // updateLastFollowup(DateTime value) => lastFollowup.value = value;

}