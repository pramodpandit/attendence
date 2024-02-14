class Guardian{
  int? id;
  String? userId;
  String? name;
  String? relation;
  String? mobile;
  String? email;
  String? other;
  String? createDate;
  String? updateDate;
  String? relationName;

  Guardian(
      {this.id,
        this.userId,
        this.name,
        this.relation,
        this.mobile,
        this.email,
        this.other,
        this.relationName,
        this.createDate,
        this.updateDate});

  Guardian.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    relation = json['relation'];
    mobile = json['mobile'];
    email = json['email'];
    other = json['other'];
    createDate = json['create_date'];
    updateDate = json['update_date'];
    relationName=json['relationname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['relation'] = this.relation;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    data['other'] = this.other;
    data['create_date'] = this.createDate;
    data['update_date'] = this.updateDate;
    data['relationname']=this.relationName;
    return data;
  }
}