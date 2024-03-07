import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:office/bloc/bloc.dart';
import 'package:office/data/model/events_model.dart';
import 'package:office/data/model/holiday_model.dart';
import 'package:office/data/repository/attendance_repo.dart';
import 'package:office/data/repository/expense_repo.dart';
import 'package:office/data/repository/holiday_repo.dart';
import 'package:office/utils/message_handler.dart';
import 'package:table_calendar/table_calendar.dart';

class ExpenseBloc extends Bloc {
  final ExpenseRepository _repo;

  ExpenseBloc(this._repo);

  ValueNotifier<String?> expenseType = ValueNotifier(null);
  ValueNotifier<List?> allExpenseTypeData = ValueNotifier(null);
  ValueNotifier<List?> allExpenseData = ValueNotifier(null);

  Future<String> getActiveExpenseTypeData(Map<String,dynamic> allowData,String userType)async{
    try{
      var response = await _repo.fetchActiveExpenseTypeData();
      List data = response['data'];
      if(userType == "Superadmin" || userType == "Admin"){
        allExpenseTypeData.value = data;
        expenseType.value = allExpenseTypeData.value![0]['id'].toString();
        return allExpenseTypeData.value![0]['id'].toString();
      }else{
        allExpenseTypeData.value = data.where((element) => allowData.values.toList().where((ele) => ele['id'].toString() == element['id'].toString() && ele['expance_allow'] == "yes").toList().isNotEmpty).toList();
        expenseType.value = allExpenseTypeData.value![0]['id'].toString();
        return allExpenseTypeData.value![0]['id'].toString();
      }
    }catch(e){
      throw e;
    }
  }

  getExpenseData(String id)async{
    Map<String,dynamic> data = {
      "id" : id
    };
    try{
      var response = await _repo.fetchExpenseData(data);
      allExpenseData.value = response['data'];
    }catch(e){
      print(e);
    }
  }

  ValueNotifier<Map<String,dynamic>?> userDetail = ValueNotifier(null);

  fetchUserDetail() async{
    try{
      var result = await _repo.userDetails();
      if(result['status']){
        userDetail.value = result['data'];
      }
    }catch (e, s) {
      print(e);
      print(s);
    }
  }

  ValueNotifier<bool> isAddLoading = ValueNotifier(false);

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  ValueNotifier<String?> expense = ValueNotifier(null);
  ValueNotifier<String?> date = ValueNotifier(null);
  TextEditingController description = TextEditingController();
  TextEditingController amount = TextEditingController();

  addExpense(BuildContext context)async{
    isAddLoading.value = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String,dynamic> data = {
      "branch" : userDetail.value!['branch_id'],
      "date" : date.value,
      "desc" : description.text,
      "amount" : amount.text,
      "employee" : prefs.getString("uid"),
      "expance_type" : expense.value,
      "paid" : "no",
    };
    try{
      var response = await _repo.addExpenseData(data);
      if(response['status']){
        expense.value = null;
        date.value = null;
        description.clear();
        amount.clear();
        showMessage(MessageType.success(response['message']));
        Navigator.pop(context);
        allExpenseData.value = null;
        getExpenseData(expenseType.value!);
      }else{
        showMessage(MessageType.error(response['message']));
      }
    }catch(e){
      showMessage(MessageType.error(e.toString()));
      print(e);
    }finally{
      isAddLoading.value = false;
    }
  }

}