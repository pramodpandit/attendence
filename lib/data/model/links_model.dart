class LinksModel {
  int? id;
  int? userId;
  String? name;
  String? links;
  String? otherLinkInfo;
  String? createBy;
  String? deleted;
  String? createdDate;
  String? updateDate;
  String? updateBy;
  String? linkNameType;

  LinksModel(
      {this.id,
        this.userId,
        this.name,
        this.links,
        this.otherLinkInfo,
        this.createBy,
        this.deleted,
        this.createdDate,
        this.updateDate,
        this.updateBy,
        this.linkNameType});

  LinksModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    links = json['links'];
    otherLinkInfo = json['other_link_info'];
    createBy = json['create_by'];
    deleted = json['deleted'];
    createdDate = json['created_date'];
    updateDate = json['update_date'];
    updateBy = json['update_by'];
    linkNameType = json['link_name_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['links'] = this.links;
    data['other_link_info'] = this.otherLinkInfo;
    data['create_by'] = this.createBy;
    data['deleted'] = this.deleted;
    data['created_date'] = this.createdDate;
    data['update_date'] = this.updateDate;
    data['update_by'] = this.updateBy;
    data['link_name_type'] = this.linkNameType;
    return data;
  }
}