class PolicyModel {
  int? id;
  String? title;
  String? status;
  String? description;
  String? createdAt;

  PolicyModel(
      {this.id, this.title, this.status, this.description, this.createdAt});

  PolicyModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    status = json['status'];
    description = json['description'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['status'] = this.status;
    data['description'] = this.description;
    data['created_at'] = this.createdAt;
    return data;
  }
}