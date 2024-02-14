class Holiday {
  int? id;
  String? holidayDate;
  String? branchType;
  String? forEmployee;
  String? branch;
  String? employee;
  String? reason;
  String? createdDate;

  Holiday(
      {this.id,
      this.holidayDate,
      this.branchType,
      this.forEmployee,
      this.branch,
      this.employee,
      this.reason,
      this.createdDate});

  Holiday.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    holidayDate = json['holiday_date'];
    branchType = json['branch_type'];
    forEmployee = json['for_employee'];
    branch = json['branch'];
    employee = json['employee'];
    reason = json['reason'];
    createdDate = json['created_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['holiday_date'] = holidayDate;
    data['branch_type'] = branchType;
    data['for_employee'] = forEmployee;
    data['branch'] = branch;
    data['employee'] = employee;
    data['reason'] = reason;
    data['created_date'] = createdDate;
    return data;
  }
}