class Autogenerated {
  bool? status;
  List<TaskData>? taskData;

  Autogenerated({this.status, this.taskData});

  Autogenerated.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['TaskData'] != null) {
      taskData = <TaskData>[];
      json['TaskData'].forEach((v) {
        taskData!.add(new TaskData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.taskData != null) {
      data['TaskData'] = this.taskData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TaskData {
  int? id;
  String? tCatId;
  String? tLabelId;
  String? projectId;
  String? departmentId;
  String? title;
  String? description;
  String? duration;
  String? assignedBy;
  Null? lastUpdateBy;
  String? priority;
  String? amount;
  String? receptType;
  String? timeOfRecept;
  String? receptCycle;
  String? startDate;
  String? dueDate;
  String? depentent;
  String? status;
  String? createdAt;
  String? updatedAt;

  TaskData(
      {this.id,
        this.tCatId,
        this.tLabelId,
        this.projectId,
        this.departmentId,
        this.title,
        this.description,
        this.duration,
        this.assignedBy,
        this.lastUpdateBy,
        this.priority,
        this.amount,
        this.receptType,
        this.timeOfRecept,
        this.receptCycle,
        this.startDate,
        this.dueDate,
        this.depentent,
        this.status,
        this.createdAt,
        this.updatedAt});

  TaskData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tCatId = json['t_cat_id'];
    tLabelId = json['t_label_id'];
    projectId = json['project_id'];
    departmentId = json['department_id'];
    title = json['title'];
    description = json['description'];
    duration = json['duration'];
    assignedBy = json['assigned_by'];
    lastUpdateBy = json['last_update_by'];
    priority = json['priority'];
    amount = json['amount'];
    receptType = json['recept_type'];
    timeOfRecept = json['time_of_recept'];
    receptCycle = json['recept_cycle'];
    startDate = json['start_date'];
    dueDate = json['due_date'];
    depentent = json['depentent'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['t_cat_id'] = this.tCatId;
    data['t_label_id'] = this.tLabelId;
    data['project_id'] = this.projectId;
    data['department_id'] = this.departmentId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['duration'] = this.duration;
    data['assigned_by'] = this.assignedBy;
    data['last_update_by'] = this.lastUpdateBy;
    data['priority'] = this.priority;
    data['amount'] = this.amount;
    data['recept_type'] = this.receptType;
    data['time_of_recept'] = this.timeOfRecept;
    data['recept_cycle'] = this.receptCycle;
    data['start_date'] = this.startDate;
    data['due_date'] = this.dueDate;
    data['depentent'] = this.depentent;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}