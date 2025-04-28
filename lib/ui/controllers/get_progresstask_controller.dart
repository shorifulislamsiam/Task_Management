import 'package:get/get.dart';

import '../../data/model/task_list_model.dart';
import '../../data/model/task_model.dart';
import '../../data/service/network_clients.dart';
import '../../data/utils/urls.dart';

class GetProgressTaskController extends GetxController {
  bool _getProgressTaskInprogress = false;
  bool get getProgressTaskInprogress => _getProgressTaskInprogress;

  String? _errorMassage;
  String? get errorMassage => _errorMassage;

  List<TaskModel> _progressTaskList = [];
  List<TaskModel> get progressTaskList => _progressTaskList;

  Future<bool> getProgressStatusCount() async {
    bool isSuccess = false;
    _getProgressTaskInprogress = true;
    update();
    final NetworkResponse response = await NetworkClient.getRequest(
      url: Urls.progressTaskStatus,
    );
    if (response.isSuccess) {
      TaskListModel taskListModel = TaskListModel.fromJson(response.data ?? {});
      _progressTaskList = taskListModel.taskList;
      isSuccess = true;
      _errorMassage = null;
    } else {
      _errorMassage = response.errorMassage;
    }
    _getProgressTaskInprogress = false;
    update();
    return isSuccess;
  }
}
