import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ostad_task_management/data/service/network_clients.dart';
import 'package:ostad_task_management/data/utils/urls.dart';
import 'package:ostad_task_management/ui/controllers/signup_controller.dart';
import 'package:ostad_task_management/ui/screens/login_screen.dart';
import 'package:ostad_task_management/ui/widgets/background_widget.dart';
import 'package:ostad_task_management/ui/widgets/obsecure.dart';
import 'package:ostad_task_management/ui/widgets/show_snackbarMassage.dart';

class signup_screen extends StatefulWidget {
  const signup_screen({super.key});

  @override
  State<signup_screen> createState() => _signup_screenState();
}

class _signup_screenState extends State<signup_screen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final obsecure _isObsecureText = obsecure();
  //bool _isRegistrationSucess = false;

  final SignUpController _signUpController = Get.find<SignUpController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: background_widget(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 80),
                  Text(
                    "Join With Us",
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  SizedBox(height: 24),
                  Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: [
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
                          //autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(labelText: "Email"),
                          validator: (String? value) {
                            String email = value?.trim() ?? "";
                            if (EmailValidator.validate(email) ==false ) {
                              return "Enter Your Email";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 8),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.name,
                          controller: _firstNameController,
                          decoration: InputDecoration(labelText: "First Name"),
                          validator: (String? value) {
                            if (value?.trim().isEmpty?? true) {
                              return "Enter Your First Name";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 8),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.name,
                          controller: _lastNameController,
                          decoration: InputDecoration(labelText: "Last Name"),
                          validator: (String? value) {
                            if (value?.trim().isEmpty ?? true) {
                              return "Enter Your Last Name";
                            }
                            return null;
                          },

                        ),
                        SizedBox(height: 8),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.phone,
                          controller: _mobileController,
                          decoration: InputDecoration(labelText: "Mobile"),
                          validator: (String? value) {
                            RegExp regEx= RegExp(r"^(?:\\+88|88)?(01[3-9]\\d{8})$");
                            String phone = value?.trim() ?? "";
                            if (regEx.hasMatch(phone)) {
                              return "Enter Your valid phone number";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 8),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: _passwordController,
                          obscureText: _isObsecureText.isobsecure,
                          decoration: InputDecoration(
                            labelText: "Password",
                            suffixIcon: _isObsecureText.obsecureText(() {
                              setState(() {
                                _isObsecureText.toggleObsecure();
                              });
                            }),
                          ),
                          validator: (String? value) {
                            if ((value?.isEmpty ?? true) || (value!.length <6)) {
                              return "Enter Your Password more than 6 letter";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  GetBuilder(
                    init: _signUpController,
                    builder: (controller) {
                      return Visibility(
                        visible: controller.isSignUpInprogress == false,
                        replacement: Center(
                          child: CircularProgressIndicator(),
                        ),
                        child: ElevatedButton(
                          onPressed: _onTapSubmitButton,
                          child: Icon(
                            Icons.arrow_circle_right_sharp,
                            color: Colors.white,
                          ),
                        ),
                      );
                    }
                  ),
                  SizedBox(height: 32),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(color: Colors.black),
                        children: [
                          TextSpan(text: "Have account? "),
                          TextSpan(
                            text: "log In",
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
      ),
    );
  }

  void _onTapSubmitButton() {
    if (_formKey.currentState!.validate()) {
      _registerUser();
    }
  }

  // Future<void> _registerUser() async {
  //   _isRegistrationSucess =true;
  //   setState(() { });
  //   Map<String,dynamic> requestBody ={
  //     "email": _emailController.text.trim(),
  //     "firstName": _firstNameController.text,
  //     "lastName": _lastNameController.text,
  //     "mobile": _mobileController.text.trim(),
  //     "password": _passwordController.text,
  //   };
  //   NetworkResponse response = await NetworkClient.postRequest(url: Urls.registerUrls, body: requestBody);
  //   _isRegistrationSucess =false;
  //   setState(() {
  //
  //   });
  //   if(response.isSuccess){
  //     showsnackbarMassage(context, "User registerd successfully");
  //   }else{
  //     showsnackbarMassage(context, response.errorMassage,true);
  //   }
  // }
  Future<void> _registerUser() async {
    bool isSuccess = await _signUpController.signUpUser(
        _emailController.text.trim(),
        _firstNameController.text.trim(),
        _lastNameController.text.trim(),
        _mobileController.text.trim(),
        _passwordController.text,
    );
    if(isSuccess == true){
      showsnackbarMassage(context, "User registerd successfully");
      Get.to(LoginScreen());
    }else{
      showsnackbarMassage(context, _signUpController.errorMassage!,true);
    }
  }

  void _onTapSignUpButton(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
