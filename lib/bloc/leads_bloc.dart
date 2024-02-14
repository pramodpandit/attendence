import 'dart:async';
import 'dart:convert';
import 'dart:io';

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

  GlobalKey<FormState> formState = GlobalKey<FormState>();
  ValueNotifier<bool> creating = ValueNotifier(false);

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController phone2 = TextEditingController();
  TextEditingController requirement = TextEditingController();

  ValueNotifier<File?> image = ValueNotifier(null);
  // ValueNotifier<UserDetail?> employee = ValueNotifier(null);
  ValueNotifier<ClientDetail?> client = ValueNotifier(null);

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
        client.value = e;
        name.text = e.name ?? '';
        phone.text = e.phone ?? '';
        imageURL = e.image ?? '';
      }
    }
  }

  StreamController<String> createLeadController = StreamController.broadcast();

  createNewEmployee() async {
    try {
      if(await validateEmployee()) {
        return;
      }
      if(creating.value) {
        return;
      }
      creating.value = true;
      String leadsJSON = "";
      Map<String, dynamic> lead = {
        // "e_id": employee.value?.id,
        "c_id": client.value?.id,
        "name": name.text,
        "phone": phone.text,
        "phone2": phone2.text,
        "email": email.text,
        "requirement": requirement.text,
      };
      leadsJSON = jsonEncode(lead);
      ApiResponse res = await _repo.createNewLead(leadsJSON, image: image.value);
      if(res.status) {
        showMessage(const MessageType.success("Employee Created Successfully"));
        createLeadController.add("SUCCESS");
        name.clear();
        phone.clear();
        phone2.clear();
        email.clear();
        requirement.clear();
        image.value = null;

      } else {
        showMessage(MessageType.error(res.message));
      }
    } catch(e,s) {
      debugPrint('$e');
      debugPrintStack(stackTrace: s);
      showMessage(const MessageType.error("Some error occurred! Please try again!"));
    } finally {
      creating.value = false;
    }
  }
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

  TextEditingController leadTitleController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  TextEditingController requirementsController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController alternativeEmailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController alternativePhoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController probabilityConversionController = TextEditingController();
  ValueNotifier<DateTime?> lastFollowup = ValueNotifier(DateTime.now());
  updateLastFollowup(DateTime value) => lastFollowup.value = value;

}