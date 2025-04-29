import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:ostad_task_management/data/model/user_model.dart';
import 'package:ostad_task_management/ui/controllers/auth_controller.dart';
import 'package:ostad_task_management/ui/controllers/email_verify_controller.dart';
import 'package:ostad_task_management/ui/screens/forgot_password_pin_verification_screen.dart';
import 'package:ostad_task_management/ui/widgets/background_widget.dart';

import '../../data/service/network_clients.dart';
import '../../data/utils/urls.dart';
import '../widgets/show_snackbarMassage.dart';

class forgot_password_verify_email_screen extends StatefulWidget {
  const forgot_password_verify_email_screen({super.key});

  @override
  State<forgot_password_verify_email_screen> createState() =>
      _forgot_password_verify_email_screenState();
}

class _forgot_password_verify_email_screenState
    extends State<forgot_password_verify_email_screen> {
  //final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  //bool _isEmailVerificationProgress = false;

  final EmailVerifyController _emailVerifyController =
      Get.find<EmailVerifyController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: background_widget(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 80),
                Text(
                  "Your Email Address",
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                SizedBox(height: 4),
                Text(
                  "A 6 digit verification pin will be sent to your email.",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge!.copyWith(color: Colors.grey),
                ),
                SizedBox(height: 24),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        controller:
                            _emailVerifyController
                                .emailController, //_emailController,
                        decoration: InputDecoration(labelText: "Email"),
                        validator: (String? value) {
                          final email = value?.trim() ?? "";
                          if (EmailValidator.validate(email) == false) {
                            return "Give a correct email";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                GetBuilder(
                  init: _emailVerifyController,
                  builder: (controller) {
                    return Visibility(
                      visible: controller.isEmailVerifyInProgress == false,
                      replacement: Center(child: CircularProgressIndicator()),
                      child: ElevatedButton(
                        onPressed: _submitButton,
                        child: Icon(
                          Icons.arrow_circle_right_sharp,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 42),
                Center(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(text: "Have account? "),
                        TextSpan(
                          text: "Sign In",
                          style: TextStyle(color: Colors.green, fontSize: 16),
                          recognizer:
                              TapGestureRecognizer()
                                ..onTap = () {
                                  _onTapSignUpButton(context);
                                },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitButton() {
    if (_formKey.currentState!.validate()) {
      _emailVerificationTesting();
    }
    //Navigator.push(context, MaterialPageRoute(builder: (_)=>forgot_password_pin_verification_screen()));
  }

  void _onTapSignUpButton(BuildContext context) {
    Navigator.pop(context);
  }
  // @override
  // void dispose(){
  //   _emailController.dispose();
  //   super.dispose();
  // }

  // Future<void> _emailVerificationTesting() async {
  //   try{
  //     _isEmailVerificationProgress = true;
  //     setState(() {});
  //
  //     final NetworkResponse response = await NetworkClient.getRequest(
  //       url: Urls.emailverification(_emailController.text),//AuthController.userModel?.email ?? ""
  //
  //     );
  //     if (response.statusCode ==200) {
  //       showsnackbarMassage(context, "successfully sent");
  //       print("submit");
  //       Navigator.push(context, MaterialPageRoute(builder: (_)=>forgot_password_pin_verification_screen(email: _emailController.text.trim(),)));
  //     } else {
  //       showsnackbarMassage(context, response.errorMassage, true);
  //     }
  //     _isEmailVerificationProgress = false;
  //     setState(() {});
  //   }catch(e){
  //     _isEmailVerificationProgress = false;
  //     setState(() {
  //
  //     });
  //     _logger.e(e);
  //   }
  // }
  // Logger _logger = Logger();

  Future<void> _emailVerificationTesting() async {
    //String email = _emailController.text.trim();
    bool isSuccess = await _emailVerifyController.emailVerify();
    try {
      if (isSuccess == true) {
        showsnackbarMassage(context, "successfully sent");
        print("submit");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => forgot_password_pin_verification_screen(),
          ),
        );
      } else {
        showsnackbarMassage(
          context,
          _emailVerifyController.errorMassage!,
          true,
        );
      }
    } catch (e) {
      _logger.e(e);
    }
  }

  Logger _logger = Logger();
}
