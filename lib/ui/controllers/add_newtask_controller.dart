import 'package:get/get.dart';
import 'package:ostad_task_management/data/service/network_clients.dart';
import 'package:ostad_task_management/data/utils/urls.dart';

class AddNewTaskController extends GetxController {
  bool _isAddTaskInProgress = false;
  bool get isAddTaskInProgress => _isAddTaskInProgress;

  String? _errorMassage;
  String? get errorMassage => _errorMassage;
  Future<bool> addNewTask(String title, String description, String status) async {
    bool isSuccess = false;
    _isAddTaskInProgress = true;
    update();
    Map<String, dynamic> requestBody = {
      "title": title,
      "description": description,
      "status": status,
    };
    NetworkResponse response =await NetworkClient.postRequest(
        url: Urls.createNewTask,
        body: requestBody
    );
    if(response.isSuccess){
      _errorMassage = null;
      isSuccess = true;
    }else{
      _errorMassage = response.errorMassage;
    }
    _isAddTaskInProgress = false;
    update();
    return isSuccess;
  }
}
