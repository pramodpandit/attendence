class LeadFor {
  int? id;
  String? name;
  String? createdDate;
  String? updatedDate;
  String? status;
  String? deleteN;

  LeadFor(
      {this.id,
        this.name,
        this.createdDate,
        this.updatedDate,
        this.status,
        this.deleteN});

  LeadFor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdDate = json['created_date'];
    updatedDate = json['updated_date'];
    status = json['status'];
    deleteN = json['delete_n'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['created_date'] = this.createdDate;
    data['updated_date'] = this.updatedDate;
    data['status'] = this.status;
    data['delete_n'] = this.deleteN;
    return data;
  }
}