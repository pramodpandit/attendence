import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:office/bloc/bloc.dart';
import 'package:office/data/model/notes_model.dart';
import 'package:office/data/repository/notes_repo.dart';
import 'package:office/utils/message_handler.dart';

class NotesBloc extends Bloc {
  final NotesRepository _repo;

  NotesBloc(this._repo);

  TextEditingController tittleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  ValueNotifier<bool> isSubmit = ValueNotifier(false);
  ValueNotifier<bool> isEdit = ValueNotifier(false);
  ValueNotifier<bool> loading= ValueNotifier(false);
  ValueNotifier<List<NotesModel>> notes=ValueNotifier([]);


  fetchNotesList() async{
    try{
      loading.value = true;
      var result = await _repo.fetchNotesList();
      if(result.status){
        notes.value = result.data ?? [];
      }
    }catch (e) {
      showMessage(MessageType.error(e.toString()));
    } finally {
      loading.value = false;
    }
  }

  StreamController<String> notesStream = StreamController.broadcast();
  addNotes() async {
    try{
      isSubmit.value = true;
      var result = await _repo.addNotes(tittleController.text, descriptionController.text);
      if(result.status){
        notesStream.sink.add('success');
      }
    }catch (e) {
      showMessage(MessageType.error(e.toString()));
    } finally{
      isSubmit.value = false;
    }
  }

  editNotes(int id) async {
    try{
      isEdit.value = true;
      var result = await _repo.editNotes(id,tittleController.text, descriptionController.text);
      if(result.status){
        notesStream.sink.add('success');
        print(result.data);
      }
    }catch (e) {
      showMessage(MessageType.error(e.toString()));
    } finally{
      isEdit.value = false;
    }
  }

}