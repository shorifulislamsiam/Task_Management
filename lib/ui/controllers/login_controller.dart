import 'package:get/get.dart';

import '../../data/model/login_model.dart';
import '../../data/service/network_clients.dart';
import '../../data/utils/urls.dart';
import 'auth_controller.dart';

class LoginController extends GetxController{
  bool _isLoginProgress = false;
  bool get isLoginProgress => _isLoginProgress;
  String? _errorMassage ;
  String? get errorMassage => _errorMassage;

  Future<bool> userLogin(String email, String password) async {
    bool _isSuccess = false;
    _isLoginProgress = true;
    update();
    Map<String, dynamic> requestBody = {
      "email": email,
      "password": password,
    };
    NetworkResponse response = await NetworkClient.postRequest(
      url: Urls.loginrUrls,
      body: requestBody,
    );

    if (response.isSuccess) {
      //TODO: this code is for consume the data
      LoginModel loginModel = LoginModel.fromJson(response.data!);
      //TODO: this code is for save the data locally
       await AuthController .saveUserInformation(loginModel.token, loginModel.userModel);
       _isSuccess = true;
       _errorMassage = null;
    } else {
      _errorMassage = response.errorMassage;
    }
    _isLoginProgress = false;
    update();
    return _isSuccess;
  }
}