class NoticeBoard {
  int? id;
  int? userId;
  String? title;
  String? description;
  String? forEmployee;
  String? forEmployeesValue;
  String? createAt;
  String? updateAt;
  int? createdBy;
  int? noticeShowNumberOfDays;

  NoticeBoard(
      {this.id,
      this.userId,
      this.title,
      this.description,
      this.forEmployee,
      this.forEmployeesValue,
      this.createAt,
      this.updateAt,
      this.createdBy,
      this.noticeShowNumberOfDays});

  NoticeBoard.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    title = json['title'];
    description = json['description'];
    forEmployee = json['for_employee'];
    forEmployeesValue = json['for_employees_value'];
    createAt = json['create_at'];
    updateAt = json['update_at'];
    createdBy = json['created_by'];
    noticeShowNumberOfDays = json['notice_show_number_of_days'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> noticeBoard = <String, dynamic>{};
    noticeBoard['id'] = id;
    noticeBoard['user_id'] = userId;
    noticeBoard['title'] = title;
    noticeBoard['description'] = description;
    noticeBoard['for_employee'] = forEmployee;
    noticeBoard['for_employees_value'] = forEmployeesValue;
    noticeBoard['create_at'] = createAt;
    noticeBoard['update_at'] = updateAt;
    noticeBoard['created_by'] = createdBy;
    noticeBoard['notice_show_number_of_days'] = noticeShowNumberOfDays;
    return noticeBoard;
  }
}