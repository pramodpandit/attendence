class GetCommunity {
bool? status;
Getcommunity? getcommunity;

GetCommunity({this.status, this.getcommunity});

GetCommunity.fromJson(Map<String, dynamic> json) {
status = json['status'];
getcommunity = json['getcommunity'] != null
? new Getcommunity.fromJson(json['getcommunity'])
    : null;
}

Map<String, dynamic> toJson() {
final Map<String, dynamic> data = new Map<String, dynamic>();
data['status'] = this.status;
if (this.getcommunity != null) {
data['getcommunity'] = this.getcommunity!.toJson();
}
return data;
}
}

class Getcommunity {
int? currentPage;
List<Data>? data;
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

Getcommunity(
{this.currentPage,
this.data,
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

Getcommunity.fromJson(Map<String, dynamic> json) {
currentPage = json['current_page'];
if (json['data'] != null) {
data = <Data>[];
json['data'].forEach((v) {
data!.add(new Data.fromJson(v));
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
if (this.data != null) {
data['data'] = this.data!.map((v) => v.toJson()).toList();
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

class Data {
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
String? email;
String? phone;
Null? fcmToken;
String? password;
Null? showPass;
Null? rememberToken;
String? createdAt;
Null? updatedAt;
String? lastLogin;

Data(
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
this.email,
this.phone,
this.fcmToken,
this.password,
this.showPass,
this.rememberToken,
this.createdAt,
this.updatedAt,
this.lastLogin});

Data.fromJson(Map<String, dynamic> json) {
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
email = json['email'];
phone = json['phone'];
fcmToken = json['fcm_token'];
password = json['password'];
showPass = json['show_pass'];
rememberToken = json['remember_token'];
createdAt = json['created_at'];
updatedAt = json['updated_at'];
lastLogin = json['last_login'];
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
data['email'] = this.email;
data['phone'] = this.phone;
data['fcm_token'] = this.fcmToken;
data['password'] = this.password;
data['show_pass'] = this.showPass;
data['remember_token'] = this.rememberToken;
data['created_at'] = this.createdAt;
data['updated_at'] = this.updatedAt;
data['last_login'] = this.lastLogin;
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