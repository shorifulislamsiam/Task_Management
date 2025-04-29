import 'package:get/get.dart';
import 'package:ostad_task_management/data/service/network_clients.dart';
import 'package:ostad_task_management/data/utils/urls.dart';

class SignUpController extends GetxController {
  bool _isSignUpInprogress = false;
  bool get isSignUpInprogress => _isSignUpInprogress;

  String? _errorMassage;
  String? get errorMassage => _errorMassage;

  Future<bool> signUpUser(String email,String firstName, String lastName,String mobileNo, String password) async {
    bool isSuccess = false;
    _isSignUpInprogress = true;
    update();
    Map<String, dynamic> requestBody = {
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "mobile": mobileNo,
      "password": password,
    };
    final NetworkResponse response = await NetworkClient.postRequest(
      url: Urls.registerUrls,
      body: requestBody,
    );
    if(response.isSuccess){
      _errorMassage = null;
      isSuccess = true;
    }else{
      _errorMassage = response.errorMassage;
    }

    _isSignUpInprogress = false;
    update();
    return isSuccess;
  }
}
