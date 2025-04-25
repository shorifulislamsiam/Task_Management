import 'package:ostad_task_management/data/model/task_status_count_model.dart';

class TaskStatusListModel {
  late final String status;
  late final List<TaskStatusCountModel> statusCountList;

  TaskStatusListModel.fromJson(Map<String, dynamic> jsonData) {
    status = jsonData["status"];
    if (jsonData["data"] != null) {
      List<TaskStatusCountModel> list = [];
      for(Map<String, dynamic> data in jsonData["data"]){
        list.add(TaskStatusCountModel.fromJson(data));
      }
      statusCountList = list;
    } else {
      statusCountList = [];
    }
  }
}
