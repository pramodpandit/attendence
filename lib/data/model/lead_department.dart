class LeadDepartment {
  int? id;
  String? name;
  String? status;
  String? noticeProvideDuration;
  String? createdDate;
  String? updateDate;
  String? type;
  String? access;

  LeadDepartment(
      {this.id,
        this.name,
        this.status,
        this.noticeProvideDuration,
        this.createdDate,
        this.updateDate,
        this.type,
        this.access});

  LeadDepartment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    status = json['status'];
    noticeProvideDuration = json['notice_provide_duration'];
    createdDate = json['created_date'];
    updateDate = json['update_date'];
    type = json['type'];
    access = json['access'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['status'] = this.status;
    data['notice_provide_duration'] = this.noticeProvideDuration;
    data['created_date'] = this.createdDate;
    data['update_date'] = this.updateDate;
    data['type'] = this.type;
    data['access'] = this.access;
    return data;
  }
}