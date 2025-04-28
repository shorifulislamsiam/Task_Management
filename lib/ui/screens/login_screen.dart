
import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ostad_task_management/ui/controllers/login_controller.dart';
import 'package:ostad_task_management/ui/screens/forgot_password_verify_email_screen.dart';
import 'package:ostad_task_management/ui/screens/main_bottom_nav_screen.dart';
import 'package:ostad_task_management/ui/screens/signup_screen.dart';
import 'package:ostad_task_management/ui/widgets/background_widget.dart';
import 'package:ostad_task_management/ui/widgets/obsecure.dart';

import '../widgets/show_snackbarMassage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  obsecure _isObsecureText = obsecure();
  final LoginController loginController = Get.find<LoginController>();

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
                  "Get Started With",
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
                        decoration: InputDecoration(labelText: "Email"),
                        validator: (String? value) {
                          String email = value?.trim() ?? "";
                          if (EmailValidator.validate(email) == false) {
                            return "Give the correct email";
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
                          // IconButton(
                          //   icon: Icon(
                          //     _isobsecure
                          //         ? Icons.visibility_off
                          //         : Icons.visibility,
                          //   ),
                          //   onPressed: () {
                          //     setState(() {
                          //       _isobsecure = !_isobsecure;
                          //     });
                          //   },
                          // ),
                        ),
                        validator: (String? value) {
                          if ((value?.isEmpty == true) || (value!.length < 6)) {
                            return "The password should be more than 6 charecter";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                GetBuilder<LoginController>(
                  builder: (controller) {
                    return Visibility(
                      visible: controller.isLoginProgress == false,
                      replacement: Center(child: CircularProgressIndicator()),
                      child: ElevatedButton(
                        onPressed: _signInButton,
                        child: Icon(
                          Icons.arrow_circle_right_sharp,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 32),
                Center(
                  child: TextButton(
                    onPressed: _forgotButton,
                    child: Text("Forget Password"),
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(text: "Don't have account? "),
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

  void _signInButton() {
    if (_formKey.currentState!.validate()) {
      _userLogin();
    }
  }

  Future<void> _userLogin() async {
    final bool isSuccess = await loginController.userLogin(
      _emailController.text.trim(),
      _passwordController.text,
    );
    if (isSuccess) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => MainBottomNavScreen()),
        (predicate) => false,
      );
    } else {
      showsnackbarMassage(context, loginController.errorMassage!, true);
    }
  }

  void _forgotButton() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => forgot_password_verify_email_screen()),
    );
  }

  void _onTapSignUpButton(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const signup_screen()),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
