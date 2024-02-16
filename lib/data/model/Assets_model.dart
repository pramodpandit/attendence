class UserAssets {
  int? id;
  String? userId;
  String? itemId;
  String? stock;
  String? totalStock;
  String? updateAt;
  String? returnable;
  String? itemName;
  String? itemGroupName;

  UserAssets(
      {this.id,
        this.userId,
        this.itemId,
        this.stock,
        this.totalStock,
        this.updateAt,
        this.returnable,
        this.itemName,
        this.itemGroupName});

  UserAssets.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    itemId = json['item_id'];
    stock = json['stock'];
    totalStock = json['total_stock'];
    updateAt = json['update_at'];
    returnable = json['returnable'];
    itemName = json['item_name'];
    itemGroupName = json['item_group_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['item_id'] = this.itemId;
    data['stock'] = this.stock;
    data['total_stock'] = this.totalStock;
    data['update_at'] = this.updateAt;
    data['returnable'] = this.returnable;
    data['item_name'] = this.itemName;
    data['item_group_name'] = this.itemGroupName;
    return data;
  }
}