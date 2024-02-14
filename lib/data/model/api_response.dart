class ApiResponse<T> {
  ApiResponse({
      required this.status,
      required this.message,
      this.data,});

  ApiResponse.fromJson(dynamic json, [this.data]) {
    status = json['status'];
    message = json['message'];
  }
  late bool status;
  late String message;
  T? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['data'] = data;
    return map;
  }
}

class ApiResponse2<T> {
  ApiResponse2({
      required this.status,
      this.message,
      this.data,});

  ApiResponse2.fromJson(dynamic json, [this.data]) {
    status = json['status'];
    message = json['message'];
  }
  late bool status;
  String? message;
  T? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['data'] = data;
    return map;
  }
}

class ApiResponse3<T> {
  ApiResponse3({
    this.message,
    this.data,});

  ApiResponse3.fromJson(dynamic json, [this.data]) {
    message = json['message'];
  }
  String? message;
  T? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['data'] = data;
    return map;
  }
}
class ApiResponse4<T> {
  ApiResponse4({
    required this.status,
    this.data,});

  ApiResponse4.fromJson(dynamic json, [this.data]) {
    status = json['status'];

  }
  late bool status;
  T? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['data'] = data;
    return map;
  }
}
