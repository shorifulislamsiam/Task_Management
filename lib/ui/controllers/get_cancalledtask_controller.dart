
import 'package:get/get.dart';
import 'package:ostad_task_management/data/model/task_list_model.dart';
import 'package:ostad_task_management/data/model/task_model.dart';
import 'package:ostad_task_management/data/service/network_clients.dart';
import 'package:ostad_task_management/data/utils/urls.dart';

class GetCancelledTaskController extends GetxController{
  bool _isGetCancalledTaskInProgress = false;
  bool get isGetCancalledTaskInProgress => _isGetCancalledTaskInProgress;

  String? _errorMassage;
  String? get errorMassage=> _errorMassage;

  List<TaskModel> _cancalledTaskList = [];
  List<TaskModel> get cancalledTaskList => _cancalledTaskList;

  Future<bool> getCancalledTask() async{
    bool isSuccess = false;
    _isGetCancalledTaskInProgress = true;
    update();
    final NetworkResponse response = await NetworkClient.getRequest(url: Urls.cancelTaskStatus);
     if(response.isSuccess){
       TaskListModel taskListModel = await TaskListModel.fromJson(response.data ?? {});
       _cancalledTaskList = taskListModel.taskList;
       _errorMassage = null;
       isSuccess = true;
     }else{
       _errorMassage = response.errorMassage;
     }
     _isGetCancalledTaskInProgress = false;
     update();
     return isSuccess;
  }


}