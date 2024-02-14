class BankDetailsModel{
  int? id;
  String? userId;
  String? bankName;
  String? bankHolderName;
  String? accountNo;
  String? ifscCode;
  String? upiId;
  String? other;
  String? createDate;
  String? updatedDate;
  String? method;
  int? deafult;

  BankDetailsModel(
      {this.id,
        this.userId,
        this.bankName,
        this.bankHolderName,
        this.accountNo,
        this.ifscCode,
        this.upiId,
        this.other,
        this.createDate,
        this.updatedDate,
        this.method,
        this.deafult});

  BankDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    bankName = json['bank_name'];
    bankHolderName = json['bank_holder_name'];
    accountNo = json['account_no'];
    ifscCode = json['ifsc_code'];
    upiId = json['upi_id'];
    other = json['other'];
    createDate = json['create_date'];
    updatedDate = json['updated_date'];
    method = json['method'];
    deafult = json['deafult'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['bank_name'] = this.bankName;
    data['bank_holder_name'] = this.bankHolderName;
    data['account_no'] = this.accountNo;
    data['ifsc_code'] = this.ifscCode;
    data['upi_id'] = this.upiId;
    data['other'] = this.other;
    data['create_date'] = this.createDate;
    data['updated_date'] = this.updatedDate;
    data['method'] = this.method;
    data['deafult'] = this.deafult;
    return data;
  }
}