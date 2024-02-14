class Events {
  int? id;
  String? name;
  String? description;
  String? startDate;
  String? startTime;
  String? endDate;
  String? endTime;
  String? forEmployee;
  String? forEmployeesValue;
  String? link;
  String? file;
  String? location;
  String? createAt;
  String? updateAt;
  int? createdBy;

  Events(
      {this.id,
      this.name,
      this.description,
      this.startDate,
      this.startTime,
      this.endDate,
      this.endTime,
      this.forEmployee,
      this.forEmployeesValue,
      this.link,
      this.file,
      this.location,
      this.createAt,
      this.updateAt,
      this.createdBy});

  Events.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    startDate = json['start_date'];
    startTime = json['start_time'];
    endDate = json['end_date'];
    endTime = json['end_time'];
    forEmployee = json['for_employee'];
    forEmployeesValue = json['for_employees_value'];
    link = json['link'];
    file = json['file'];
    location = json['location'];
    createAt = json['create_at'];
    updateAt = json['update_at'];
    createdBy = json['created_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['start_date'] = startDate;
    data['start_time'] = startTime;
    data['end_date'] = endDate;
    data['end_time'] = endTime;
    data['for_employee'] = forEmployee;
    data['for_employees_value'] = forEmployeesValue;
    data['link'] = link;
    data['file'] = file;
    data['location'] = location;
    data['create_at'] = createAt;
    data['update_at'] = updateAt;
    data['created_by'] = createdBy;
    return data;
  }
}