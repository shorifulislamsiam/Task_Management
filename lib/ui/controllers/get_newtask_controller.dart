import 'package:get/get.dart';
import 'package:ostad_task_management/data/model/task_model.dart';

import '../../data/model/task_list_model.dart';
import '../../data/service/network_clients.dart';
import '../../data/utils/urls.dart';

class GetNewTaskController extends GetxController {
  bool _getNewTaskInprogress = false;
  bool get getNewTaskInprogress => _getNewTaskInprogress;
  String? _errorMassage;
  String? get errorMassage => _errorMassage;
  List<TaskModel> _newTaskList = [];
  List<TaskModel> get newTaskList => _newTaskList;
  Future<bool> getNewStatusCount() async {
    bool isSuccess = false;
    _getNewTaskInprogress = true;
    update();
    final NetworkResponse response = await NetworkClient.getRequest(
      url: Urls.newTaskStatus,
    );
    if (response.isSuccess) {
      TaskListModel taskListModel = TaskListModel.fromJson(response.data ?? {});
      _newTaskList = taskListModel.taskList;
      isSuccess = true;
      _errorMassage = null;
    } else {
      _errorMassage = response.errorMassage;
    }
    _getNewTaskInprogress = false;
    update();
    return isSuccess;
  }
}
