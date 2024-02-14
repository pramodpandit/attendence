import 'package:flutter/cupertino.dart';

class EBill {
  String? name;
  int? id;
  String? userId;
  String? branchId;
  String? e;
  String? m;
  String? date;
  String? typeId;

  TextEditingController eController = TextEditingController();
  TextEditingController mController = TextEditingController();


  EBill(
      {this.name,
        this.id,
        this.userId,
        this.branchId,
        this.e,
        this.m,
        this.date,
        this.typeId});

  EBill.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    userId = json['user_id'];
    branchId = json['branch_id'];
    e = json['e'];
    m = json['m'];
    date = json['date'];
    typeId = json['type_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['branch_id'] = this.branchId;
    data['e'] = this.e;
    data['m'] = this.m;
    data['date'] = this.date;
    data['type_id'] = this.typeId;
    return data;
  }
}