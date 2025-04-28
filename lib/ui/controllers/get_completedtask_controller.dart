import 'package:get/get.dart';

import '../../data/model/task_list_model.dart';
import '../../data/model/task_model.dart';
import '../../data/service/network_clients.dart';
import '../../data/utils/urls.dart';

class GetCompletedTaskController extends GetxController {
  bool _getCompletedTaskInprogress = false;
  bool get getCompletedTaskInprogress => _getCompletedTaskInprogress;

  String? _errorMassage;
  String? get errorMassage => _errorMassage;

  List<TaskModel> _completedTaskList = [];
  List<TaskModel> get completedTaskList => _completedTaskList;

  Future<bool> getProgressStatusCount() async {
    bool isSuccess = false;
    _getCompletedTaskInprogress = true;
    update();
    final NetworkResponse response = await NetworkClient.getRequest(
      url: Urls.completedTaskStatus,
    );
    if (response.isSuccess) {
      TaskListModel taskListModel = TaskListModel.fromJson(response.data ?? {});
      _completedTaskList = taskListModel.taskList;
      isSuccess = true;
      _errorMassage = null;
    } else {
      _errorMassage = response.errorMassage;
    }
    _getCompletedTaskInprogress = false;
    update();
    return isSuccess;
  }
}