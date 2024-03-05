import 'package:flutter/cupertino.dart';
import 'package:office/data/model/api_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/repository/team_repo.dart';
import '../utils/message_handler.dart';
import 'bloc.dart';

class TeamBloc extends Bloc{
  late TeamRepo _repo;
  TeamBloc(this._repo, );

  ValueNotifier<bool> isLoadingvalue = ValueNotifier(false);
  ValueNotifier<List?> reportto = ValueNotifier(null);
  ValueNotifier<List?> getTeamList = ValueNotifier(null);
  ValueNotifier<String?> Updatereportto = ValueNotifier(null);
  ValueNotifier<String?> UpdatereportTeam = ValueNotifier(null);
  ValueNotifier<String?> Updatemanger = ValueNotifier(null);

  fetchuserMeber(int branchid,)async{
    isLoadingvalue.value = true;
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      Map<String, dynamic> data = {
        "branch_id":branchid
      };
      ApiResponse2 res = await _repo.Add('project/get-mamber',data) ;
      if(res.status) {
        reportto.value = res.data;
        //showMessage(const MessageType.success("File Created Successfully"));
      } else {
        showMessage(MessageType.error(res.message.toString()));
      }
    } catch(e,s) {
      print("the error is : $e");
      debugPrint('$e');
      debugPrintStack(stackTrace: s);
      showMessage(const MessageType.error("Some error occurred! Please try again!"));
    }finally{
      isLoadingvalue.value = false;
    }
  }
  fetchteamList()async{
    isLoadingvalue.value = true;
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      Map<String, dynamic> data = {
        "user_id": pref.getString('uid')
      };
      ApiResponse2 res = await _repo.Add('team-list',data) ;
      if(res.status) {
        getTeamList.value = res.data;
      } else {
        showMessage(MessageType.error(res.message.toString()));
      }
    } catch(e,s) {
      print("the error is : $e");
      debugPrint('$e');
      debugPrintStack(stackTrace: s);
      showMessage(const MessageType.error("Some error occurred! Please try again!"));
    }finally{
      isLoadingvalue.value = false;
    }
  }

  ValueNotifier<bool> isLoadingupdateTeam = ValueNotifier(false);

  UpdateTeam()async{
    if(Updatereportto.value ==null){
      showMessage(MessageType.info('Please select report to'));
    }else if(UpdatereportTeam.value ==null){
      showMessage(MessageType.info('Please select report team'));
    }else if(Updatemanger.value==null){
      showMessage(MessageType.info('Please select manager'));
    }else{
      isLoadingupdateTeam.value = true;
      SharedPreferences pref = await SharedPreferences.getInstance();
      try {
        Map<String, dynamic> data = {
          "user_id": pref.getString('uid'),
          "report_to":Updatereportto.value,
          "report_team":UpdatereportTeam.value,
          "manager_to":Updatemanger.value
        };
        ApiResponse2 res = await _repo.Add('team-user-post',data) ;
        if(res.status) {
          showMessage( MessageType.success("${res.message}"));
          Updatemanger.value =null;
          UpdatereportTeam.value =null;
          Updatereportto.value =null;
        } else {
          showMessage(MessageType.error(res.message.toString()));
        }
      } catch(e,s) {
        print("the error is : $e");
        debugPrint('$e');
        debugPrintStack(stackTrace: s);
        showMessage(const MessageType.error("Some error occurred! Please try again!"));
      }finally{
        isLoadingupdateTeam.value = false;
      }
    }

  }

}