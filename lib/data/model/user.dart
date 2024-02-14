class User {
  int? id;
  String? userId;
  String? firstName;
  Null? lastName;
  String? middleName;
  String? image;
  String? currentAddress;
  String? countryId;
  String? stateId;
  String? cityId;
  String? permanentAddress;
  String? pCountryId;
  String? pStateId;
  String? pCityId;
  String? mobileNo;
  String? alternateMobileNo;
  String? gender;
  String? dateOfBirth;
  String? joinDate;
  String? officeEmailId;
  String? email;
  String? employeeCode;
  String? ctc;
  Null? finance;
  String? designation;
  String? department;
  String? reportTo;
  String? reportTeam;
  String? aboutUs;
  String? skills;
  String? qualification;
  Null? probationStart;
  Null? probationEnd;
  String? noticePeriodStatus;
  String? provisionStatus;
  Null? noticePeriodStart;
  Null? noticePeriodEnd;
  String? noticePeriodDuration;
  String? probationDuration;
  Null? jobTitle;
  int? branchId;
  Null? bussinessLocation;
  int? bussinessAddr;
  String? employeeStatus;
  String? shiftId;
  String? employeeType;
  String? shortCode;
  String? quotationLeader;
  String? maritalStatus;
  Null? marriageNniversary;
  Null? baskitAlliance;
  Null? varible;
  String? allowChats;
  Null? otherDepartmentChat;
  Null? groupDepartmentChat;
  String? marketPerson;
  String? targetStatus;
  Null? minimumTarget;
  Null? targetDuration;
  String? penaltyStatus;
  String? penaltyType;
  Null? penaltyVal;
  String? extraEarnStatus;
  String? customLeaveSetting;
  String? loginAccess;
  String? idCardIssue;
  String? attendanceMode;
  Null? biomatricId;
  String? byApplication;
  String? selfRequired;
  String? workFromOfficeByLocation;
  String? specialWorkingDayAbsentCount;
  String? specialWorkingDayExtraSalary;
  String? dailyWork;
  Null? checkIn;
  Null? checkOut;
  String? aadharCard;
  String? bloodGroup;
  String? status;
  String? lastLogin;
  String? accessType;
  Null? access;
  String? createdDate;
  String? updateDate;
  String? mobile;
  Null? reportFirst;
  Null? reportMiddle;
  Null? reportLast;
  String? workType;
  String? shiftTitle;
  String? startTime;
  String? endTime;
  String? businessTitle;
  String? teamName;
  String? designationname;
  String? departmentname;
  List<Departmentaccess>? departmentaccess;
  String? skillName;
  String? name;

  User(
      {this.id,
        this.userId,
        this.firstName,
        this.lastName,
        this.middleName,
        this.image,
        this.currentAddress,
        this.countryId,
        this.stateId,
        this.cityId,
        this.permanentAddress,
        this.pCountryId,
        this.pStateId,
        this.pCityId,
        this.mobileNo,
        this.alternateMobileNo,
        this.gender,
        this.dateOfBirth,
        this.joinDate,
        this.officeEmailId,
        this.email,
        this.employeeCode,
        this.ctc,
        this.finance,
        this.designation,
        this.department,
        this.reportTo,
        this.reportTeam,
        this.aboutUs,
        this.skills,
        this.qualification,
        this.probationStart,
        this.probationEnd,
        this.noticePeriodStatus,
        this.provisionStatus,
        this.noticePeriodStart,
        this.noticePeriodEnd,
        this.noticePeriodDuration,
        this.probationDuration,
        this.jobTitle,
        this.branchId,
        this.bussinessLocation,
        this.bussinessAddr,
        this.employeeStatus,
        this.shiftId,
        this.employeeType,
        this.shortCode,
        this.quotationLeader,
        this.maritalStatus,
        this.marriageNniversary,
        this.baskitAlliance,
        this.varible,
        this.allowChats,
        this.otherDepartmentChat,
        this.groupDepartmentChat,
        this.marketPerson,
        this.targetStatus,
        this.minimumTarget,
        this.targetDuration,
        this.penaltyStatus,
        this.penaltyType,
        this.penaltyVal,
        this.extraEarnStatus,
        this.customLeaveSetting,
        this.loginAccess,
        this.idCardIssue,
        this.attendanceMode,
        this.biomatricId,
        this.byApplication,
        this.selfRequired,
        this.workFromOfficeByLocation,
        this.specialWorkingDayAbsentCount,
        this.specialWorkingDayExtraSalary,
        this.dailyWork,
        this.checkIn,
        this.checkOut,
        this.aadharCard,
        this.bloodGroup,
        this.status,
        this.lastLogin,
        this.accessType,
        this.access,
        this.createdDate,
        this.updateDate,
        this.mobile,
        this.reportFirst,
        this.reportMiddle,
        this.reportLast,
        this.workType,
        this.shiftTitle,
        this.startTime,
        this.endTime,
        this.businessTitle,
        this.teamName,
        this.designationname,
        this.departmentname,
        this.departmentaccess,
        this.skillName,
        this.name});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    middleName = json['middle_name'];
    image = json['image'];
    currentAddress = json['current_address'];
    countryId = json['country_id'];
    stateId = json['state_id'];
    cityId = json['city_id'];
    permanentAddress = json['permanent_address'];
    pCountryId = json['p_country_id'];
    pStateId = json['p_state_id'];
    pCityId = json['p_city_id'];
    mobileNo = json['mobile_no'];
    alternateMobileNo = json['alternate_mobile_no'];
    gender = json['gender'];
    dateOfBirth = json['date_of_birth'];
    joinDate = json['join_date'];
    officeEmailId = json['office_email_id'];
    email = json['email'];
    employeeCode = json['employee_code'];
    ctc = json['ctc'];
    finance = json['finance'];
    designation = json['designation'];
    department = json['department'];
    reportTo = json['report_to'];
    reportTeam = json['report_team'];
    aboutUs = json['about_us'];
    skills = json['skills'];
    qualification = json['Qualification'];
    probationStart = json['probation_start'];
    probationEnd = json['probation_end'];
    noticePeriodStatus = json['notice_period_status'];
    provisionStatus = json['provision_status'];
    noticePeriodStart = json['notice_period_start'];
    noticePeriodEnd = json['notice_period_end'];
    noticePeriodDuration = json['notice_period_duration'];
    probationDuration = json['probation_duration'];
    jobTitle = json['job_title'];
    branchId = json['branch_id'];
    bussinessLocation = json['bussiness_location'];
    bussinessAddr = json['bussiness_addr'];
    employeeStatus = json['employee_status'];
    shiftId = json['shift_id'];
    employeeType = json['employee_type'];
    shortCode = json['short_code'];
    quotationLeader = json['quotation_leader'];
    maritalStatus = json['marital_status'];
    marriageNniversary = json['marriage_nniversary'];
    baskitAlliance = json['baskit_alliance'];
    varible = json['varible'];
    allowChats = json['allow_chats'];
    otherDepartmentChat = json['other_department_chat'];
    groupDepartmentChat = json['group_department_chat'];
    marketPerson = json['market_person'];
    targetStatus = json['target_status'];
    minimumTarget = json['minimum_target'];
    targetDuration = json['target_duration'];
    penaltyStatus = json['penalty_status'];
    penaltyType = json['penalty_type'];
    penaltyVal = json['penalty_val'];
    extraEarnStatus = json['extra_earn_status'];
    customLeaveSetting = json['custom_leave_setting'];
    loginAccess = json['login_access'];
    idCardIssue = json['id_card_issue'];
    attendanceMode = json['attendance_mode'];
    biomatricId = json['biomatric_id'];
    byApplication = json['by_application'];
    selfRequired = json['self_required'];
    workFromOfficeByLocation = json['work_from_office_by_location'];
    specialWorkingDayAbsentCount = json['special_working_day_absent_count'];
    specialWorkingDayExtraSalary = json['special_working_day_extra_salary'];
    dailyWork = json['daily_work'];
    checkIn = json['check_In'];
    checkOut = json['check_out'];
    aadharCard = json['aadhar_card'];
    bloodGroup = json['blood_group'];
    status = json['status'];
    lastLogin = json['last_login'];
    accessType = json['access_type'];
    access = json['access'];
    createdDate = json['created_date'];
    updateDate = json['update_date'];
    mobile = json['mobile'];
    reportFirst = json['report_first'];
    reportMiddle = json['report_middle'];
    reportLast = json['report_last'];
    workType = json['work_type'];
    shiftTitle = json['shift_title'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    businessTitle = json['business_title'];
    teamName = json['team_name'];
    designationname = json['designationname'];
    departmentname = json['departmentname'];
    if (json['departmentaccess'] != null) {
      departmentaccess = <Departmentaccess>[];
      json['departmentaccess'].forEach((v) {
        departmentaccess!.add(new Departmentaccess.fromJson(v));
      });
    }
    skillName = json['skillName'];
    name = json['Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['middle_name'] = this.middleName;
    data['image'] = this.image;
    data['current_address'] = this.currentAddress;
    data['country_id'] = this.countryId;
    data['state_id'] = this.stateId;
    data['city_id'] = this.cityId;
    data['permanent_address'] = this.permanentAddress;
    data['p_country_id'] = this.pCountryId;
    data['p_state_id'] = this.pStateId;
    data['p_city_id'] = this.pCityId;
    data['mobile_no'] = this.mobileNo;
    data['alternate_mobile_no'] = this.alternateMobileNo;
    data['gender'] = this.gender;
    data['date_of_birth'] = this.dateOfBirth;
    data['join_date'] = this.joinDate;
    data['office_email_id'] = this.officeEmailId;
    data['email'] = this.email;
    data['employee_code'] = this.employeeCode;
    data['ctc'] = this.ctc;
    data['finance'] = this.finance;
    data['designation'] = this.designation;
    data['department'] = this.department;
    data['report_to'] = this.reportTo;
    data['report_team'] = this.reportTeam;
    data['about_us'] = this.aboutUs;
    data['skills'] = this.skills;
    data['Qualification'] = this.qualification;
    data['probation_start'] = this.probationStart;
    data['probation_end'] = this.probationEnd;
    data['notice_period_status'] = this.noticePeriodStatus;
    data['provision_status'] = this.provisionStatus;
    data['notice_period_start'] = this.noticePeriodStart;
    data['notice_period_end'] = this.noticePeriodEnd;
    data['notice_period_duration'] = this.noticePeriodDuration;
    data['probation_duration'] = this.probationDuration;
    data['job_title'] = this.jobTitle;
    data['branch_id'] = this.branchId;
    data['bussiness_location'] = this.bussinessLocation;
    data['bussiness_addr'] = this.bussinessAddr;
    data['employee_status'] = this.employeeStatus;
    data['shift_id'] = this.shiftId;
    data['employee_type'] = this.employeeType;
    data['short_code'] = this.shortCode;
    data['quotation_leader'] = this.quotationLeader;
    data['marital_status'] = this.maritalStatus;
    data['marriage_nniversary'] = this.marriageNniversary;
    data['baskit_alliance'] = this.baskitAlliance;
    data['varible'] = this.varible;
    data['allow_chats'] = this.allowChats;
    data['other_department_chat'] = this.otherDepartmentChat;
    data['group_department_chat'] = this.groupDepartmentChat;
    data['market_person'] = this.marketPerson;
    data['target_status'] = this.targetStatus;
    data['minimum_target'] = this.minimumTarget;
    data['target_duration'] = this.targetDuration;
    data['penalty_status'] = this.penaltyStatus;
    data['penalty_type'] = this.penaltyType;
    data['penalty_val'] = this.penaltyVal;
    data['extra_earn_status'] = this.extraEarnStatus;
    data['custom_leave_setting'] = this.customLeaveSetting;
    data['login_access'] = this.loginAccess;
    data['id_card_issue'] = this.idCardIssue;
    data['attendance_mode'] = this.attendanceMode;
    data['biomatric_id'] = this.biomatricId;
    data['by_application'] = this.byApplication;
    data['self_required'] = this.selfRequired;
    data['work_from_office_by_location'] = this.workFromOfficeByLocation;
    data['special_working_day_absent_count'] =
        this.specialWorkingDayAbsentCount;
    data['special_working_day_extra_salary'] =
        this.specialWorkingDayExtraSalary;
    data['daily_work'] = this.dailyWork;
    data['check_In'] = this.checkIn;
    data['check_out'] = this.checkOut;
    data['aadhar_card'] = this.aadharCard;
    data['blood_group'] = this.bloodGroup;
    data['status'] = this.status;
    data['last_login'] = this.lastLogin;
    data['access_type'] = this.accessType;
    data['access'] = this.access;
    data['created_date'] = this.createdDate;
    data['update_date'] = this.updateDate;
    data['mobile'] = this.mobile;
    data['report_first'] = this.reportFirst;
    data['report_middle'] = this.reportMiddle;
    data['report_last'] = this.reportLast;
    data['work_type'] = this.workType;
    data['shift_title'] = this.shiftTitle;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['business_title'] = this.businessTitle;
    data['team_name'] = this.teamName;
    data['designationname'] = this.designationname;
    data['departmentname'] = this.departmentname;
    if (this.departmentaccess != null) {
      data['departmentaccess'] =
          this.departmentaccess!.map((v) => v.toJson()).toList();
    }
    data['skillName'] = this.skillName;
    data['Name'] = this.name;
    return data;
  }
}

class Departmentaccess {
  String? id;
  String? moduleId;
  String? name;
  String? addA;
  String? viewA;
  String? editA;
  String? downloadA;
  String? allData;

  Departmentaccess(
      {this.id,
        this.moduleId,
        this.name,
        this.addA,
        this.viewA,
        this.editA,
        this.downloadA,
        this.allData});

  Departmentaccess.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    moduleId = json['module_id'];
    name = json['name'];
    addA = json['add_a'];
    viewA = json['view_a'];
    editA = json['edit_a'];
    downloadA = json['download_a'];
    allData = json['all_data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['module_id'] = this.moduleId;
    data['name'] = this.name;
    data['add_a'] = this.addA;
    data['view_a'] = this.viewA;
    data['edit_a'] = this.editA;
    data['download_a'] = this.downloadA;
    data['all_data'] = this.allData;
    return data;
  }
}