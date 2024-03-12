import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:office/bloc/bloc.dart';
import 'package:office/data/repository/project_repo.dart';

import '../utils/message_handler.dart';

class ProjectBloc extends Bloc {

  final ProjectRepository repo;

  ProjectBloc(this.repo);
  ValueNotifier<String> selectedProjects = ValueNotifier("doing");
  ValueNotifier<int> isLoadingDownload = ValueNotifier(-1);
  ValueNotifier<List?> allProjects = ValueNotifier(null);
  ValueNotifier<List?> imageList = ValueNotifier(null);
  ValueNotifier allprojectDetail = ValueNotifier(null);
  ValueNotifier<List?> projectNotes = ValueNotifier(null);
  ValueNotifier<List?> projectfile = ValueNotifier(null);
  ValueNotifier<List?> projectlink = ValueNotifier(null);
  ValueNotifier<List?> projectmember = ValueNotifier(null);
  ValueNotifier<List?> projectcredentails = ValueNotifier(null);
  ValueNotifier<List?> projectcomment = ValueNotifier(null);
  ValueNotifier<List?> projectTask  = ValueNotifier(null);
  ValueNotifier<List?> projectexpenses = ValueNotifier(null);
  ValueNotifier<List?> allProjectsMemberList = ValueNotifier(null);


  fetchProjects(String type) async{

    try{
      // isUserDetailLoad.value = true;
      var result = await repo.fetchAllProjects();
      print('data${type}');
      if(result.status && result.data != null){
        allProjects.value = result.data["data"]["project"]['$type'];
        print("the all projects are : ${allProjects.value}");
      }
    }catch (e, s) {
      print(e);
      print(s);
    }
  }
  fetchProjectsDetails(int id) async{
    try{
      // isUserDetailLoad.value = true;
      var result = await repo.fetchAllProjectsDetail(id);
      if(result.status && result.data != null){
        allprojectDetail.value = result.data["data"]["project_details"];
        projectNotes.value = (result.data["data"]["project_notes"] as List).reversed.toList();
        projectfile.value = (result.data["data"]["project_file"]as List).reversed.toList();
        projectlink.value = (result.data["data"]["project_links"]as List).reversed.toList();
        projectmember.value = (result.data["data"]["project_members"]as List).reversed.toList();
        projectcredentails.value = (result.data["data"]["project_credentials"]as List).reversed.toList();
        projectTask.value = (result.data["data"]["project_task"]as List).reversed.toList();
        projectcomment.value = (result.data["data"]["project_comment"]as List).reversed.toList();
        projectexpenses.value = (result.data["data"]["project_expenses"]as List).reversed.toList();
      }
    }catch (e, s) {
      print(e);
      print(s);
    }
  }

  fetchAddMemberLit(int id) async{

    try{
      // isUserDetailLoad.value = true;
      var result = await repo.fetchAddMemberList(id);

      if(result.status && result.data != null){
        allProjectsMemberList.value = result.data["data"];
        print("the all projects are : ${allProjectsMemberList.value}");
      }
    }catch (e, s) {
      print(e);
      print(s);
    }
  }
  ValueNotifier<List<int>> selectedIndex = ValueNotifier([]);
  ValueNotifier<List<dynamic>> selectMulitpleMember = ValueNotifier([]);
  ValueNotifier<bool> isAddmemberLoading = ValueNotifier(false);
  StreamController<String> AddMemberStream = StreamController.broadcast();

 // ValueNotifier<String?> selectedEmpId = ValueNotifier('');
String? selectedEmpId;
  updateEmployee(String empId) {
    selectedEmpId= empId;
  }
  addMember(int id) async {
    try {
      isAddmemberLoading.value = true;
      var result = await repo.AddMember(id, selectedEmpId);
      print("${result.status} ${result.message}");
      if (result.message.toString() == 'Post successfully') {
        AddMemberStream.sink.add('successfully');
      } else {
        showMessage(MessageType.error("Something went wrong"));
      }
    } catch (e, s) {
      debugPrint("$e");
      debugPrint("$s");
    } finally {
      isAddmemberLoading.value = false;
    }
  }
  TextEditingController Comment = TextEditingController();
  StreamController<String> CommentStream = StreamController.broadcast();
  ValueNotifier<bool> addCommentLoading  = ValueNotifier(false);
  ValueNotifier<int> radioSelect = ValueNotifier(0);

  addComment(int id,String private) async {
    try {
      addCommentLoading.value = true;
      var result = await repo.AddComment(Comment.text,private, id  );
      if(result.status == true){
       // print("${result.status} ${result.message}");
        CommentStream.sink.add('Comment');
      }
      showMessage(MessageType.error("Something went wrong"));
    } catch (e, s) {
      debugPrint("$e");
      debugPrint("$s");
    } finally {
      addCommentLoading.value = false;
    }
  }

  List<String> SpecificMemer = [
    'Yes',
    'No',
  ];
  List<String> LinksType= [
    'Google',
    'Yahoo',
    "Twitter"
  ];
  selectSpecificMemer(data) {
    SpecificMemer = data;
  }
  ValueNotifier<String?> addSpecificMember = ValueNotifier(null);
  TextEditingController notes = TextEditingController();
  ValueNotifier<bool> addnotesLoading  = ValueNotifier(false);
  StreamController<String> notesStream = StreamController.broadcast();


  addNotes(int id,String private,String data) async {
    try {
      addnotesLoading.value = true;
      var result = await repo.AddNotes(notes.text,private, id,addSpecificMember.value == 'Yes'?'yes':'no',data);
      if(result.status == true){
        // print("${result.status} ${result.message}");
        notesStream.sink.add('notes');
      }else{
        showMessage(MessageType.error("Something went wrong"));
      }
    } catch (e, s) {
      debugPrint("$e");
      debugPrint("$s");
    } finally {
      addnotesLoading.value = false;
    }
  }
  File? image;
  TextEditingController filepath = TextEditingController();
  TextEditingController fileName = TextEditingController();
  StreamController<String> fileStream = StreamController.broadcast();
  ValueNotifier<bool> addfileLoading  = ValueNotifier(false);

  addFiles(int id,String private,) async {
    try {
      addfileLoading.value = true;
      var result = await repo.AddFiles(fileName.text,private, id,image);
      if(result.status == true){
        // print("${result.status} ${result.message}");
        fileStream.sink.add('streamFiles');
      }
      showMessage(MessageType.error("Something went wrong"));
    } catch (e, s) {
      debugPrint("$e");
      debugPrint("$s");
    } finally {
      addfileLoading.value = false;
    }
  }
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  ValueNotifier<String?> addCredialSpecificMember = ValueNotifier(null);
  ValueNotifier<bool> addCredientalLoading  = ValueNotifier(false);
  StreamController<String> credientalSteam = StreamController.broadcast();


  addCrediental(int id,String private,String data) async {
    try {
      addCredientalLoading.value = true;
      var result = await repo.AddCrediental(description.text,private, id,addCredialSpecificMember.value == 'Yes'?'yes':'no',title.text,data);
      if(result.status == true){
        // print("${result.status} ${result.message}");
        credientalSteam.sink.add('notes');
      }else{
        showMessage(MessageType.error("Something went wrong"));
      }
    } catch (e, s) {
      debugPrint("$e");
      debugPrint("$s");
    } finally {
      addCredientalLoading.value = false;
    }
  }

  ValueNotifier<String?> addLinkType = ValueNotifier(null);
  TextEditingController links = TextEditingController();
  TextEditingController other = TextEditingController();
  ValueNotifier<bool> addLinLoading  = ValueNotifier(false);
  StreamController<String> linkSteam = StreamController.broadcast();
  ValueNotifier<List?> linketype = ValueNotifier(null);
  String? selectedLinktype;

  updatelink(String empId) {
    selectedLinktype= empId;
  }

  fetchLinktype() async{
    try{
      // isUserDetailLoad.value =

      var result = await repo.getlinkList();
      if(result.status && result.data != null){
        linketype.value = result.data["data"];
        print("the all projects are : ${linketype.value}");
      }
    }catch (e, s) {
      print(e);
      print(s);
    }
  }
  addlink(int id,String private) async {
    if(selectedLinktype ==null){
      showMessage(MessageType.info('Please select link type'));
    }else{
      try {
        addLinLoading.value = true;
        var result = await repo.AddLink(other.text,private, id,links.text,int.parse(selectedLinktype!));
        if(result.status == true){
          linkSteam.sink.add('notes');
        }else{
          showMessage(MessageType.error("Something went wrong"));
        }
      } catch (e, s) {
        debugPrint("$e");
        debugPrint("$s");
      } finally {
        addLinLoading.value = false;
      }
    }

  }

  ValueNotifier userDetail = ValueNotifier(null);
  fetchUserDetail(int id) async{
    try{
      // isUserDetailLoad.value = true;
      var result = await repo.getUserDetail(id);
      if(result.status && result.data != null){
        userDetail.value = result.data["data"];
        print("the all projects are : ${userDetail.value}");
      }
    }catch (e, s) {
      print(e);
      print(s);
    }
  }
  TextEditingController itemName = TextEditingController();
  File? expensesFile;
  TextEditingController price = TextEditingController();
  TextEditingController descriptionExpenses = TextEditingController();
  ValueNotifier<DateTime?> PurchaseDate = ValueNotifier(null);
  updateDateStart(DateTime value) => PurchaseDate.value = value;
  ValueNotifier<List?> Currency = ValueNotifier(null);
  String? UpdateCurrency;
  StreamController<String> ExpensesStream = StreamController.broadcast();
  ValueNotifier<bool> addExpenseLoading  = ValueNotifier(false);


  AddExpenses(int id,String private,String data) async {
    try {
      addExpenseLoading.value = true;
      var date = PurchaseDate.value.toString().split(' ');
      addLinLoading.value = true;
      var result = await repo.AddExpense(price.text, descriptionExpenses.text, private, id, itemName.text, date[0], int.parse(updateCategory.value!), int.parse(UpdateCurrency!), expensesFile!, data, int.parse(updatePaymentType.value!));
      if(result.status == true){
        ExpensesStream.sink.add('sucess');
      }else{
        showMessage(MessageType.error("${result.message}"));
      }
    } catch (e, s) {
      debugPrint("$e");
      debugPrint("$s");
    } finally {
      addExpenseLoading.value = false;
    }
  }

updateCurrency(String data){
  UpdateCurrency = data;
}
  fetchCurrencyType() async{
    try{
      // isUserDetailLoad.value = true;
      var result = await repo.getexpenseCurrency();
      if(result.status && result.data != null){
        Currency.value = result.data["data"];
        print("the all projects are : ${Currency.value}");
      }
    }catch (e, s) {
      print(e);
      print(s);
    }
  }
  ValueNotifier<List?> CategoryExpenses = ValueNotifier(null);
ValueNotifier<String?> updateCategory = ValueNotifier(null);
  fetchexpensesCategory() async{
    try{
      // isUserDetailLoad.value = true;
      var result = await repo.getexpenseCategory();
      if(result.status && result.data != null){
        CategoryExpenses.value = result.data["data"];
        print("the all projects are : ${CategoryExpenses.value}");
      }
    }catch (e, s) {
      print(e);
      print(s);
    }
  }
  ValueNotifier<List?> PaymentType = ValueNotifier(null);
  ValueNotifier<String?> updatePaymentType = ValueNotifier(null);

  fetchexpensePaymentType() async{
    try{
      // isUserDetailLoad.value = true;
      var result = await repo.getexpensepaymentType();
      if(result.status && result.data != null){
        PaymentType.value = result.data["data"];
        //print("the all projects are : ${userDetail.value}");
      }
    }catch (e, s) {
      print(e);
      print(s);
    }
  }

}
