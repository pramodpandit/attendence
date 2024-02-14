class UserDetail {
  int? id;
  String? type;
  String? email;
  String? phone;
  String? fcmToken;
  String? password;
  String? rememberToken;
  String? createdAt;
  String? updatedAt;
  String? lastLogin;
  String? firstName;
  String? lastName;

  UserDetail(
      {this.id,
      this.type,
      this.email,
      this.phone,
      this.fcmToken,
      this.password,
      this.rememberToken,
      this.createdAt,
      this.updatedAt,
      this.lastLogin,
      this.firstName,
      this.lastName});

  UserDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    email = json['email'];
    phone = json['phone'];
    fcmToken = json['fcm_token'];
    password = json['password'];
    rememberToken = json['remember_token'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    lastLogin = json['last_login'];
    firstName = json['first_name'];
    lastName = json['last_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> userDetail = <String, dynamic>{};
    userDetail['id'] = id;
    userDetail['type'] = type;
    userDetail['email'] = email;
    userDetail['phone'] = phone;
    userDetail['fcm_token'] = fcmToken;
    userDetail['password'] = password;
    userDetail['remember_token'] = rememberToken;
    userDetail['created_at'] = createdAt;
    userDetail['updated_at'] = updatedAt;
    userDetail['last_login'] = lastLogin;
    userDetail['first_name'] = firstName;
    userDetail['last_name'] = lastName;
    return userDetail;
  }
}