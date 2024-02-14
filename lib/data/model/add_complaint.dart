class AddComplaint {
  String? title;
  String? desp;
  String? compTo;
  String? status;
  String? compBy;

  AddComplaint({this.title, this.desp, this.compTo, this.status, this.compBy});

  AddComplaint.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    desp = json['desp'];
    compTo = json['comp_to'];
    status = json['status'];
    compBy = json['comp_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['desp'] = desp;
    data['comp_to'] = compTo;
    data['status'] = status;
    data['comp_by'] = compBy;
    return data;
  }
}