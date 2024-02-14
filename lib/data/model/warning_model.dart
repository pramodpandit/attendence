class WarningModel {
  int? id;
  String? title;
  String? description;
  int? userId;
  int? employeeId;
  String? createdAt;
  String? updatedAt;
  String? firstName;
  String? middleName;
  String? lastName;

  WarningModel(
      {this.id,
        this.title,
        this.description,
        this.userId,
        this.employeeId,
        this.createdAt,
        this.updatedAt,
        this.firstName,
        this.middleName,
        this.lastName,
      });

  WarningModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    userId = json['user_id'];
    employeeId = json['employee_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    firstName = json["f_name"];
    middleName = json["m_name"];
    lastName = json["l_name"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['user_id'] = this.userId;
    data['employee_id'] = this.employeeId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = updatedAt;
    data['f_name'] = firstName;
    data['m_name'] = middleName;
    data['l_name'] = lastName;
    return data;
  }
}