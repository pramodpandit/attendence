class Document {
  int? id;
  String? userId;
  String? name;
  String? file;
  String? other;
  String? createdDate;
  String? updateDate;
  String? relation;
  String? mobile;
  String? email;

  Document(
      {this.id,
        this.userId,
        this.name,
        this.file,
        this.other,
        this.createdDate,
        this.updateDate,
        this.relation,
        this.mobile,
        this.email,
        });

  Document.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    file = json['file'];
    other = json['other'];
    createdDate = json['created_date'];
    relation = json['relation'];
    mobile = json['mobile'];
    email = json['email'];
    updateDate = json['update_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['name'] = name;
    data['file'] = file;
    data['other'] = other;
    data['created_date'] = createdDate;
    data['update_date'] = updateDate;
    data['relation'] = relation;
    data['mobile'] = mobile;
    data['email'] = email;
    return data;
  }
}
