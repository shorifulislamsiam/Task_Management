import 'package:get/get.dart';
import 'package:ostad_task_management/data/service/network_clients.dart';
import 'package:ostad_task_management/data/utils/urls.dart';
import 'package:flutter/material.dart';

class EmailVerifyController extends GetxController {
  bool _isEmailVerifyInProgress = false;
  bool get isEmailVerifyInProgress => _isEmailVerifyInProgress;

  String? _errorMassage;
  String? get errorMassage => _errorMassage;

  //String? _userEmail;
 // String? get userEmail => _userEmail;
   TextEditingController _emailController = TextEditingController();
   get emailController => _emailController;
   get emailTrimController => _emailController.text;

  Future<bool> emailVerify() async {


    bool isSuccess = false;
    _isEmailVerifyInProgress = true;
    update();

    final NetworkResponse response = await NetworkClient.getRequest(
      url: Urls.emailverification(_emailController.text),
    );

    if(response.isSuccess){
      _errorMassage = null;
      isSuccess = true;
    }else{
      _errorMassage = response.errorMassage;
    }

    _isEmailVerifyInProgress =false;
    update();
    return isSuccess;
  }
}
