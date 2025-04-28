import 'package:get/get.dart';
import 'package:ostad_task_management/data/model/task_status_count_model.dart';

import '../../data/model/task_status_list_model.dart';
import '../../data/service/network_clients.dart';
import '../../data/utils/urls.dart';

class GetAllTaskController extends GetxController{
  bool _getAllNewStatusCountInprogressCount =false;
  bool get getAllNewTaskInprogress => _getAllNewStatusCountInprogressCount;

  String? _errorMassage;
  String? get errorMassage => _errorMassage;

  List<TaskStatusCountModel> _taskStatusCountList =[];
  List<TaskStatusCountModel> get allNewTaskList => _taskStatusCountList;

  Future<bool> getAllStatusCount() async {
    bool isSuccess = false;
    _getAllNewStatusCountInprogressCount = true;
    update();
    final NetworkResponse response = await NetworkClient.getRequest(
      url: Urls.taskStatusCount,
    );
    if (response.isSuccess) {
      TaskStatusListModel taskStatusListModel = TaskStatusListModel.fromJson(
        response.data ?? {},
      );
      _taskStatusCountList =taskStatusListModel.statusCountList;
    } else {
      _errorMassage = response.errorMassage;
    }
    _getAllNewStatusCountInprogressCount = false;
    update();
    return isSuccess;
  }

}