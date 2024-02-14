class LeadTechnology {
  int? id;
  String? name;
  String? status;
  String? createdDate;
  String? updateDate;

  LeadTechnology(
      {this.id, this.name, this.status, this.createdDate, this.updateDate});

  LeadTechnology.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    status = json['status'];
    createdDate = json['created_date'];
    updateDate = json['update_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['status'] = this.status;
    data['created_date'] = this.createdDate;
    data['update_date'] = this.updateDate;
    return data;
  }
}