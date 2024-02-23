class LeaveRecord {
  int? id;
  String? branchId;
  String? userId;
  String? leaveType;
  String? status;
  String? durationType;
  String? startDate;
  String? endDate;
  String? reasonTitle;
  String? reason;
  String? reportTo;
  String? document;
  String? createBy;
  String? approvedBy;
  String? remark;
  String? createdDate;
  String? updatedDate;
  String? leaveCategory;

  LeaveRecord(
      {this.id,
        this.branchId,
        this.userId,
        this.leaveType,
        this.status,
        this.durationType,
        this.startDate,
        this.endDate,
        this.reasonTitle,
        this.reason,
        this.reportTo,
        this.document,
        this.createBy,
        this.approvedBy,
        this.remark,
        this.createdDate,
        this.updatedDate,
        this.leaveCategory});

  LeaveRecord.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    branchId = json['branch_id'];
    userId = json['user_id'];
    leaveType = json['leave_type'];
    status = json['status'];
    durationType = json['duration_type'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    reasonTitle = json['reason_title'];
    reason = json['reason'];
    reportTo = json['report_to'];
    document = json['document'];
    createBy = json['create_by'];
    approvedBy = json['approved_by'];
    remark = json['remark'];
    createdDate = json['created_date'];
    updatedDate = json['updated_date'];
    leaveCategory = json['leave_category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['branch_id'] = this.branchId;
    data['user_id'] = this.userId;
    data['leave_type'] = this.leaveType;
    data['status'] = this.status;
    data['duration_type'] = this.durationType;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['reason_title'] = this.reasonTitle;
    data['reason'] = this.reason;
    data['report_to'] = this.reportTo;
    data['document'] = this.document;
    data['create_by'] = this.createBy;
    data['approved_by'] = this.approvedBy;
    data['remark'] = this.remark;
    data['created_date'] = this.createdDate;
    data['updated_date'] = this.updatedDate;
    data['leave_category'] = this.leaveCategory;
    return data;
  }
}