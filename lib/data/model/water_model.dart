import 'package:flutter/cupertino.dart';

class Water {
  String? name;
  int? id;
  String? userId;
  String? branchId;
  String? quantity;
  String? date;
  String? typeId;


  Water(
      {this.name,
        this.id,
        this.userId,
        this.branchId,
        this.quantity,
        this.date,
        this.typeId});

  Water.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    userId = json['user_id'];
    branchId = json['branch_id'];
    quantity = json['quantity'];
    date = json['date'];
    typeId = json['type_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['branch_id'] = this.branchId;
    data['quantity'] = this.quantity;
    data['date'] = this.date;
    data['type_id'] = this.typeId;
    return data;
  }
}