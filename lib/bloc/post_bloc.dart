import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:office/bloc/bloc.dart';
import 'package:office/data/repository/post_repo.dart';
import 'package:office/ui/widget/top_snackbar/top_snack_bar.dart';
import 'package:office/utils/message_handler.dart';

import '../data/model/api_response.dart';
import '../data/model/community_list.dart';
import '../data/repository/community.dart';
import '../ui/community/communityHomepage.dart';

class PostBloc extends Bloc {
  final PostRepository _repo;
  final CommunityRepositary repo;

  PostBloc(this._repo, this.repo);

  //add post by community
   ValueNotifier<bool> isAddPostLoading = ValueNotifier(false);
  ValueNotifier<bool> isDeletePostLoading = ValueNotifier(false);
  StreamController<String> postStream = StreamController.broadcast();
  StreamController<String> deleteStream = StreamController.broadcast();
  ValueNotifier<bool> isUserDetailLoad = ValueNotifier(false);
  //ValueNotifier<Getcommunity?> userDetail = ValueNotifier(null);
  TextEditingController postTextController = TextEditingController();
  File? image;
  addPost(context) async {
    try {
      isAddPostLoading.value = true;
      var result = await _repo.addFeedback(postTextController.text, image!);
      if (result.message.toString() == 'Post successfully') {
        postStream.sink.add('Post successfully');
      } else {
        showMessage(MessageType.error("Something went wrong"));
      }
    } catch (e, s) {
      debugPrint("$e");
      debugPrint("$s");
    } finally {
      isAddPostLoading.value = false;
    }
  }
  DeletePost(int id) async {
    try {
      isUserDetailLoad.value = true;
      var result = await _repo.DeletePost(id);
      if (result.message.toString() == 'Post Deleted successfully') {
        deleteStream.sink.add('Post');
        return result.message;
      } else {
        showMessage(MessageType.error("Something went wrong"));
      }
    } catch (e, s) {
      debugPrint("$e");
      debugPrint("$s");
    } finally {
      isUserDetailLoad.value = false;
    }
  }
  List<Community> feedbackData = [];
  ValueNotifier<List?> userPost = ValueNotifier([]);

  fetchPost(int id) async{
    try{
      isUserDetailLoad.value = true;
      var result = await repo.getPost(id);
      if(result.status && result.data != null){
        userPost.value = result.data!.reversed.toList();
      }
    }catch (e, s) {
      print(e);
      print(s);
    }finally{
      isUserDetailLoad.value = false;
    }
  }
  fetchPostData() async{
    try{
      isUserDetailLoad.value = true;
      var result = await repo.getPostRecords();
      if(result.status && result.data != null){
        feedbackData = result.data!.reversed.toList();
      }
    }catch (e, s) {
      print(e);
      print(s);
    }finally{
      isUserDetailLoad.value = false;
    }
  }
  
  Future likePost(String postId,String like)async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    Map<String,dynamic> data = {
      "post_id" : postId,
      "user_id" : pref.getString("uid"),
      "user_post_like" : like,
    };
    try{
      var result = await _repo.likePostApi('post-like',data);
      print(result);
    }catch(e){
      print(e);
    }
  }

  Future<List> getLikedPostUserDetails(String postId)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String,dynamic> data = {
      "post_id" : postId,
    };
    try{
      var result = await _repo.fetchLikedPostUserDetails(data);
      List finalResult = result.data;
      return finalResult;
      // postLikedAllUserList.value = finalResult;
      // liked.value = finalResult.where((element) => element['user_id'].toString()==prefs.getString("uid").toString()).toList();
    }catch(e){
      throw(e);
    }
  }

  ValueNotifier<List?> postCommentAllUserList = ValueNotifier(null);
  ValueNotifier<bool> isLoadingcomment = ValueNotifier(false);
  getCommentPostUserDetails(String postId)async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String,dynamic> data = {
      "post_id" : postId,
    };
    try{
      isLoadingcomment.value = true;
      var result = await _repo.fetchCommentPostUserDetails(data);
      List finalResult = result.data;
      postCommentAllUserList.value = finalResult;
    }catch(e){
      print(e);
    }
    finally{
      isLoadingcomment.value = false;
    }
  }

  Future commentPost(String postId,String comment)async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    Map<String,dynamic> data = {
      "post_id" : postId,
      "user_id" : pref.getString("uid"),
      "comment" : comment,
    };
    try{
      var result = await _repo.commentPostApi('post-add-comment',data);
      if(result.status ==true){
        return true;
      }

      print(result);
    }catch(e){
      print(e);
    }
  }
}
