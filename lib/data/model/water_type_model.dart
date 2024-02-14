class WaterType {
  int? id;
  String? name;
  String? perprice;
  String? status;

  WaterType({this.id, this.name, this.perprice, this.status});

  WaterType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    perprice = json['perprice'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['perprice'] = this.perprice;
    data['status'] = this.status;
    return data;
  }
}