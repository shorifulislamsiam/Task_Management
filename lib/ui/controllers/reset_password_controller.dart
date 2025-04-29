import 'package:get/get.dart';
import 'package:ostad_task_management/data/service/network_clients.dart';
import 'package:ostad_task_management/data/utils/urls.dart';
import 'package:ostad_task_management/ui/controllers/email_verify_controller.dart';
import 'package:ostad_task_management/ui/controllers/forgot_password_pinverify_controller.dart';

class ResetPasswordController extends GetxController {
  bool _isResetPasswordInProgress = false;
  bool get isResetPasswordInProgress => _isResetPasswordInProgress;

  String? _errorMassage;
  String? get errorMassage => _errorMassage;

  final EmailVerifyController _emailVerifyController =
      Get.find<EmailVerifyController>();
  final ForgotPasswordPinVerifyController _forgotPasswordPinVerifyController =
      Get.find<ForgotPasswordPinVerifyController>();

  Future<bool> resetPassword(String password) async {
    bool isSuccess = false;
    _isResetPasswordInProgress = true;
    update();
    Map<String,dynamic> requestBody = {
      "email": _emailVerifyController.emailTrimController,
      "OTP": _forgotPasswordPinVerifyController.pinTrimCodeController,
      "password": password,
    };
    NetworkResponse response = await NetworkClient.postRequest(
      url: Urls.resetPassword,
      body: requestBody,
    );
    if(response.isSuccess){
      _errorMassage = null;
      isSuccess = true;
    }else{
      _errorMassage = response.errorMassage;
    }
    _isResetPasswordInProgress = false;
    update();
    return isSuccess;
  }
}
