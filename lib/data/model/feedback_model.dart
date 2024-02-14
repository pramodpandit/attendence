class FeedbackModel {
  int? id;
  int? userId;
  String? message;
  String? status;
  String? firstName;
  String? lastName;
  String? createdAt;

  FeedbackModel(
      {this.id,
      this.userId,
      this.message,
      this.status,
      this.firstName,
      this.lastName,
      this.createdAt});

  FeedbackModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    message = json['message'];
    status = json['status'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['message'] = message;
    data['status'] = status;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['created_at'] = createdAt;
    return data;
  }
}