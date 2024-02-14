class LeaveRecord {
  LeaveRecord({
      this.id, 
      this.userId, 
      this.leaveType, 
      this.status, 
      this.durationType, 
      this.startDate, 
      this.endDate, 
      this.reason, 
      this.createBy, 
      this.approvedBy, 
      this.createdDate, 
      this.updatedDate, 
      this.leaveCategory,});

  LeaveRecord.fromJson(dynamic json) {
    id = json['id'];
    userId = json['user_id'];
    leaveType = json['leave_type'];
    status = json['status'];
    durationType = json['duration_type'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    reason = json['reason'];
    reasonTitle = json['reason_title'];
    createBy = json['create_by'];
    approvedBy = json['approved_by'];
    createdDate = json['created_date'];
    updatedDate = json['updated_date'];
    leaveCategory = json['leave_category'];
  }
  num? id;
  String? userId;
  String? leaveType;
  String? status;
  String? durationType;
  String? startDate;
  String? endDate;
  String? reason;
  String? reasonTitle;
  String? createBy;
  String? approvedBy;
  String? createdDate;
  String? updatedDate;
  String? leaveCategory;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['user_id'] = userId;
    map['leave_type'] = leaveType;
    map['status'] = status;
    map['duration_type'] = durationType;
    map['start_date'] = startDate;
    map['end_date'] = endDate;
    map['reason'] = reason;
    map['reason_title'] = reasonTitle;
    map['create_by'] = createBy;
    map['approved_by'] = approvedBy;
    map['created_date'] = createdDate;
    map['updated_date'] = updatedDate;
    map['leave_category'] = leaveCategory;
    return map;
  }

}