class ComplaintList {
  int? id;
  String? title;
  String? status;
  String? createdDate;
  String? updateDate;
  String? desp;
  String? compTo;
  String? compToValue;
  String? markAs;
  int? compBy;
  String? firstName;
  String? lastName;
  String? middleName;
  String? response;

  ComplaintList(
      {this.id,
      this.title,
      this.status,
      this.createdDate,
      this.updateDate,
      this.desp,
      this.compTo,
      this.compToValue,
      this.markAs,
      this.compBy,
      this.firstName,
      this.lastName,
      this.middleName,
      this.response});

  ComplaintList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    status = json['status'];
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
    response = json['response'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['status'] = status;
    data['created_date'] = createdDate;
    data['update_date'] = updateDate;
    data['desp'] = desp;
    data['comp_to'] = compTo;
    data['comp_to_value'] = compToValue;
    data['mark_as'] = markAs;
    data['comp_by'] = compBy;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['middle_name'] = middleName;
    data['response'] = response;
    return data;
  }
}