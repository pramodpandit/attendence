class ComplaintList {
  int? id;
  String? title;
  String? status;
  String? response;
  String? createdDate;
  String? updateDate;
  String? desp;
  String? compTo;
  String? compToValue;
  String? markAs;
  String? compBy;
  String? firstName;
  String? lastName;
  String? middleName;

  ComplaintList(
      {this.id,
        this.title,
        this.status,
        this.response,
        this.createdDate,
        this.updateDate,
        this.desp,
        this.compTo,
        this.compToValue,
        this.markAs,
        this.compBy,
        this.firstName,
        this.lastName,
        this.middleName});

  ComplaintList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    status = json['status'];
    response = json['response'];
    createdDate = json['created_date'];
    updateDate = json['update_date'];
    desp = json['desp'];
    compTo = json['comp_to'];
    compToValue = json['comp_to_value'];
    markAs = json['mark_as'];
    compBy = json['comp_by'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    middleName = json['middle_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['status'] = this.status;
    data['response'] = this.response;
    data['created_date'] = this.createdDate;
    data['update_date'] = this.updateDate;
    data['desp'] = this.desp;
    data['comp_to'] = this.compTo;
    data['comp_to_value'] = this.compToValue;
    data['mark_as'] = this.markAs;
    data['comp_by'] = this.compBy;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['middle_name'] = this.middleName;
    return data;
  }
}