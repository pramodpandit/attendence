import 'package:flutter/cupertino.dart';
import 'package:office/bloc/bloc.dart';
import 'package:office/data/model/policy_model.dart';
import 'package:office/data/repository/profile_repo.dart';

class PolicyBloc extends Bloc{
  final ProfileRepository _repo;
  PolicyBloc(this._repo);

  ValueNotifier<int> selectedMenuIndex = ValueNotifier(0);
  ValueNotifier<List<PolicyModel>?>policy=ValueNotifier([]);
  ValueNotifier<bool> isPolicyLoad=ValueNotifier(false);

  selectMenu(int index){
    selectedMenuIndex.value =index;
  }

  fetchUserPolicy() async{
    try{
      isPolicyLoad.value = true;
      var result = await _repo.userPolicy();
      if(result.status){
        policy.value = result.data;
      }
    }catch (e,s) {
      print(e);
      print(s);
    }finally{
      isPolicyLoad.value = false;
    }
  }
}