import 'package:get/get.dart';
import 'package:ostad_task_management/data/service/network_clients.dart';
import 'package:ostad_task_management/data/utils/urls.dart';
import 'package:ostad_task_management/ui/controllers/email_verify_controller.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPinVerifyController extends GetxController {
  bool _isPinVerifyInProgress = false;
  bool get isPinVerifyInprogress => _isPinVerifyInProgress;

  String? _errorMassage;
  String? get errorMassage => _errorMassage;
  EmailVerifyController _emailVerifyController = Get.find<EmailVerifyController>();
  TextEditingController _pinCodeController = TextEditingController();
  get pinCodeController => _pinCodeController;
  get pinTrimCodeController => _pinCodeController.text;

  Future<bool> pinVerify( ) async {
    bool isSuccess = false;
    _isPinVerifyInProgress = true;
    update();

    final NetworkResponse response = await NetworkClient.getRequest(
      url: Urls.pinVerification(_emailVerifyController.emailTrimController, _pinCodeController.text),
    );
    if(response.isSuccess){
      _errorMassage = null;
      isSuccess = true;
    }else{
      _errorMassage = response.errorMassage;
    }
    _isPinVerifyInProgress = false;
    update();
    return isSuccess;
  }
}
