class LeaveCategory {
  LeaveCategory({
      this.id, 
      this.name, 
      this.leavePaid, 
      this.noOfLeave, 
      this.monthlyLimit, 
      this.colorCode, 
      this.allow, 
      this.status,});

  LeaveCategory.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    leavePaid = json['leave_paid'];
    noOfLeave = json['no_of_leave'];
    monthlyLimit = json['monthly_limit'];
    colorCode = json['color_code'];
    allow = json['allow'];
    status = json['status'];
  }
  num? id;
  String? name;
  String? leavePaid;
  String? noOfLeave;
  String? monthlyLimit;
  String? colorCode;
  String? allow;
  String? status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['leave_paid'] = leavePaid;
    map['no_of_leave'] = noOfLeave;
    map['monthly_limit'] = monthlyLimit;
    map['color_code'] = colorCode;
    map['allow'] = allow;
    map['status'] = status;
    return map;
  }

}