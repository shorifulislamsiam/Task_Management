
import 'package:ostad_task_management/data/model/user_model.dart';

class LoginModel{
  late final String status;
  late final String token;
  late final UserModel userModel;

  LoginModel.fromJson(Map<String,dynamic>jsonData){
    status = jsonData["status"] ?? "";
    userModel = UserModel.fromJson(jsonData["data"]?? {});
    token = jsonData["token"]?? "";
  }
}