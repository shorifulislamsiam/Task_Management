
import 'package:get/get.dart';
import 'package:ostad_task_management/ui/controllers/add_newtask_controller.dart';
import 'package:ostad_task_management/ui/controllers/email_verify_controller.dart';
import 'package:ostad_task_management/ui/controllers/forgot_password_pinverify_controller.dart';
import 'package:ostad_task_management/ui/controllers/get_alltask_controller.dart';
import 'package:ostad_task_management/ui/controllers/get_cancalledtask_controller.dart';
import 'package:ostad_task_management/ui/controllers/get_completedtask_controller.dart';
import 'package:ostad_task_management/ui/controllers/get_newtask_controller.dart';
import 'package:ostad_task_management/ui/controllers/get_progresstask_controller.dart';
import 'package:ostad_task_management/ui/controllers/login_controller.dart';
import 'package:ostad_task_management/ui/controllers/reset_password_controller.dart';

class ControllerBinder extends Bindings{
  @override
  void dependencies() {
    Get.put(LoginController());
    Get.lazyPut(()=>GetNewTaskController());
    Get.lazyPut(()=>GetAllTaskController());
    Get.lazyPut(()=>GetProgressTaskController());
    Get.lazyPut(()=>GetCompletedTaskController());
    Get.lazyPut(()=> GetCancelledTaskController());
    Get.lazyPut(()=>AddNewTaskController());
    Get.lazyPut(()=> EmailVerifyController());
    Get.lazyPut(()=>ForgotPasswordPinVerifyController());
    Get.lazyPut(()=>ResetPasswordController());
  }

}