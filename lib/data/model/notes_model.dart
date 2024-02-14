class NotesModel {
  int? id;
  String? title;
  String? description;
  int? userId;
  int? employeeId;
  String? createdAt;
  String? updatedAt;
  String? fName;
  String? mName;
  String? lName;

  NotesModel(
      {this.id,
        this.title,
        this.description,
        this.userId,
        this.employeeId,
        this.createdAt,
        this.updatedAt,
        this.fName,
        this.mName,
        this.lName});

  NotesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    userId = json['user_id'];
    employeeId = json['employee_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    fName = json['f_name'];
    mName = json['m_name'];
    lName = json['l_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['user_id'] = this.userId;
    data['employee_id'] = this.employeeId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['f_name'] = this.fName;
    data['m_name'] = this.mName;
    data['l_name'] = this.lName;
    return data;
  }
}