class UserAssetDetail {
  int? id;
  String? itemId;
  String? userId;
  String? branch;
  int? userBy;
  String? status;
  String? amount;
  String? createdAt;
  Null? updatedAt;
  String? remarks;
  String? firstName;
  String? itemName;
  String? returnable;
  String? itemGroupName;
  String? branchName;

  UserAssetDetail(
      {this.id,
        this.itemId,
        this.userId,
        this.branch,
        this.userBy,
        this.status,
        this.amount,
        this.createdAt,
        this.updatedAt,
        this.remarks,
        this.firstName,
        this.itemName,
        this.returnable,
        this.itemGroupName,
        this.branchName});

  UserAssetDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itemId = json['item_id'];
    userId = json['user_id'];
    branch = json['branch'];
    userBy = json['user_by'];
    status = json['status'];
    amount = json['amount'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    remarks = json['remarks'];
    firstName = json['first_name'];
    itemName = json['item_name'];
    returnable = json['returnable'];
    itemGroupName = json['item_group_name'];
    branchName = json['branch_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['item_id'] = this.itemId;
    data['user_id'] = this.userId;
    data['branch'] = this.branch;
    data['user_by'] = this.userBy;
    data['status'] = this.status;
    data['amount'] = this.amount;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['remarks'] = this.remarks;
    data['first_name'] = this.firstName;
    data['item_name'] = this.itemName;
    data['returnable'] = this.returnable;
    data['item_group_name'] = this.itemGroupName;
    data['branch_name'] = this.branchName;
    return data;
  }
}