class GetCommunity {
  bool? status;
  Listdata? listdata;

  GetCommunity({this.status, this.listdata});

  GetCommunity.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    listdata = json['listdata'] != null
        ? new Listdata.fromJson(json['listdata'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.listdata != null) {
      data['listdata'] = this.listdata!.toJson();
    }
    return data;
  }
}

class Listdata {
  int? currentPage;
  List<Community>? community;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Links>? links;
  Null? nextPageUrl;
  String? path;
  int? perPage;
  Null? prevPageUrl;
  int? to;
  int? total;

  Listdata(
      {this.currentPage,
        this.community,
        this.firstPageUrl,
        this.from,
        this.lastPage,
        this.lastPageUrl,
        this.links,
        this.nextPageUrl,
        this.path,
        this.perPage,
        this.prevPageUrl,
        this.to,
        this.total});

  Listdata.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['community'] != null) {
      community = <Community>[];
      json['community'].forEach((v) {
        community!.add(new Community.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(new Links.fromJson(v));
      });
    }
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    if (this.community != null) {
      data['community'] = this.community!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = this.firstPageUrl;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    data['last_page_url'] = this.lastPageUrl;
    if (this.links != null) {
      data['links'] = this.links!.map((v) => v.toJson()).toList();
    }
    data['next_page_url'] = this.nextPageUrl;
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['prev_page_url'] = this.prevPageUrl;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }
}

class Community {
  int? postId;
  int? id;
  String? userId;
  String? text;
  String? image;
  String? dateTime;
  String? status;
  int? totalView;
  int? totalComments;
  int? totalLike;
  int? adminId;
  String? type;
  String? branch;
  String? email;
  String? phone;
  String? fcmToken;
  String? password;
  String? showPass;
  String? rememberToken;
  String? createdAt;
  String? updatedAt;
  String? lastLogin;
  UserDetails? userDetails;

  Community(
      {this.postId,
        this.id,
        this.userId,
        this.text,
        this.image,
        this.dateTime,
        this.status,
        this.totalView,
        this.totalComments,
        this.totalLike,
        this.adminId,
        this.type,
        this.branch,
        this.email,
        this.phone,
        this.fcmToken,
        this.password,
        this.showPass,
        this.rememberToken,
        this.createdAt,
        this.updatedAt,
        this.lastLogin,
        this.userDetails});

  Community.fromJson(Map<String, dynamic> json) {
    postId = json['post_id'];
    id = json['id'];
    userId = json['user_id'];
    text = json['text'];
    image = json['image'];
    dateTime = json['date_time'];
    status = json['status'];
    totalView = json['total_view'];
    totalComments = json['total_comments'];
    totalLike = json['total_like'];
    adminId = json['admin_id'];
    type = json['type'];
    branch = json['branch'];
    email = json['email'];
    phone = json['phone'];
    fcmToken = json['fcm_token'];
    password = json['password'];
    showPass = json['show_pass'];
    rememberToken = json['remember_token'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    lastLogin = json['last_login'];
    userDetails = json['user_details'] != null
        ? new UserDetails.fromJson(json['user_details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['post_id'] = this.postId;
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['text'] = this.text;
    data['image'] = this.image;
    data['date_time'] = this.dateTime;
    data['status'] = this.status;
    data['total_view'] = this.totalView;
    data['total_comments'] = this.totalComments;
    data['total_like'] = this.totalLike;
    data['admin_id'] = this.adminId;
    data['type'] = this.type;
    data['branch'] = this.branch;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['fcm_token'] = this.fcmToken;
    data['password'] = this.password;
    data['show_pass'] = this.showPass;
    data['remember_token'] = this.rememberToken;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['last_login'] = this.lastLogin;
    if (this.userDetails != null) {
      data['user_details'] = this.userDetails!.toJson();
    }
    return data;
  }
}

class UserDetails {
  String? name;
  String? image;

  UserDetails({this.name, this.image});

  UserDetails.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['image'] = this.image;
    return data;
  }
}

class Links {
  String? url;
  String? label;
  bool? active;

  Links({this.url, this.label, this.active});

  Links.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    label = json['label'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['label'] = this.label;
    data['active'] = this.active;
    return data;
  }
}