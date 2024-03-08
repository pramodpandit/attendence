class Water {
  String? date;
  List<Data>? data;

  Water({this.date, this.data});

  Water.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? empId;
  String? fDate;
  String? waterType;
  String? numberOfBotal;
  String? bussinessAddress;
  String? waterTypeRate;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
        this.empId,
        this.fDate,
        this.waterType,
        this.numberOfBotal,
        this.bussinessAddress,
        this.waterTypeRate,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    empId = json['emp_id'];
    fDate = json['f_date'];
    waterType = json['water_type'];
    numberOfBotal = json['number_of_botal'];
    bussinessAddress = json['bussiness_address'];
    waterTypeRate = json['water_type_rate'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['emp_id'] = this.empId;
    data['f_date'] = this.fDate;
    data['water_type'] = this.waterType;
    data['number_of_botal'] = this.numberOfBotal;
    data['bussiness_address'] = this.bussinessAddress;
    data['water_type_rate'] = this.waterTypeRate;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}