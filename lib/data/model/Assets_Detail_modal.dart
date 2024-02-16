class UserAssetDetail {
  int? id;
  String? itemId;
  String? allotedBy;
  String? allotedDate;
  String? collectDate;
  String? collectBy;
  Null? description;
  String? userId;
  String? branch;
  String? rcvremarks;
  String? status;
  Null? amount;
  String? createdAt;
  Null? updatedAt;
  String? itemName;
  String? returnable;
  String? itemGroupName;

  UserAssetDetail(
      {this.id,
        this.itemId,
        this.allotedBy,
        this.allotedDate,
        this.collectDate,
        this.collectBy,
        this.description,
        this.userId,
        this.branch,
        this.rcvremarks,
        this.status,
        this.amount,
        this.createdAt,
        this.updatedAt,
        this.itemName,
        this.returnable,
        this.itemGroupName});

  UserAssetDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itemId = json['item_id'];
    allotedBy = json['alloted_by'];
    allotedDate = json['alloted_date'];
    collectDate = json['collect_date'];
    collectBy = json['collect_by'];
    description = json['description'];
    userId = json['user_id'];
    branch = json['branch'];
    rcvremarks = json['rcvremarks'];
    status = json['status'];
    amount = json['amount'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    itemName = json['item_name'];
    returnable = json['returnable'];
    itemGroupName = json['item_group_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['item_id'] = this.itemId;
    data['alloted_by'] = this.allotedBy;
    data['alloted_date'] = this.allotedDate;
    data['collect_date'] = this.collectDate;
    data['collect_by'] = this.collectBy;
    data['description'] = this.description;
    data['user_id'] = this.userId;
    data['branch'] = this.branch;
    data['rcvremarks'] = this.rcvremarks;
    data['status'] = this.status;
    data['amount'] = this.amount;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['item_name'] = this.itemName;
    data['returnable'] = this.returnable;
    data['item_group_name'] = this.itemGroupName;
    return data;
  }
}