import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:ostad_task_management/data/service/network_clients.dart';
import 'package:ostad_task_management/data/utils/urls.dart';
import 'package:ostad_task_management/ui/screens/login_screen.dart';
import 'package:ostad_task_management/ui/screens/main_bottom_nav_screen.dart';
import 'package:ostad_task_management/ui/widgets/background_widget.dart';
import 'package:ostad_task_management/ui/widgets/obsecure.dart';
import 'package:ostad_task_management/ui/widgets/show_snackbarMassage.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({
    super.key,
    required this.email,
    required this.otp,
  });
  final String email;
  final String otp;
  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmNewPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final obsecure _isObsecureText = obsecure();
  bool _isResetPasswordInprogress = false;
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
                  "Set Password",
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                SizedBox(height: 4),
                Text(
                  "Minimum length password 8 character with Letter and number combination",
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
                        controller: _newPasswordController,
                        obscureText: _isObsecureText.isobsecure,
                        decoration: InputDecoration(
                          labelText: "New Password",
                          suffixIcon: _isObsecureText.obsecureText(() {
                            setState(() {
                              _isObsecureText.toggleObsecure();
                            });
                          }),
                        ),
                        validator: (String? value) {
                          if ((value?.isEmpty ?? true) || (value!.length < 6)) {
                            return "Give a strong Password more than 6 digit";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        obscureText: _isObsecureText.isobsecure,
                        controller: _confirmNewPasswordController,
                        decoration: InputDecoration(
                          labelText: "Confirm New Password",
                          suffixIcon: _isObsecureText.obsecureText(() {
                            setState(() {
                              _isObsecureText.toggleObsecure();
                            });
                          }),
                        ),
                        validator: (String? value) {
                          if ((value?.isEmpty ?? true) ||
                              (value!.length < 6) ||
                              (_newPasswordController.text != value)) {
                            return "Give a strong Password more than 6 digit";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Visibility(
                  visible: _isResetPasswordInprogress == false,
                  replacement: Center(child: CircularProgressIndicator()),
                  child: ElevatedButton(
                    onPressed: _submitButton,
                    child: Icon(
                      Icons.arrow_circle_right_sharp,
                      color: Colors.white,
                    ),
                  ),
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
      _resetPassword();
    }
  }

  void _onTapSignUpButton(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
      (pre) => false,
    );
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    try {
      _isResetPasswordInprogress = true;
      setState(() {});
      Map<String, dynamic> requestBody = {
        "email": widget.email.trim(),
        "OTP": widget.otp.trim(),
        "password": _confirmNewPasswordController.text.trim(),
      };
      NetworkResponse response = await NetworkClient.postRequest(
        url: Urls.resetPassword,
        body: requestBody,
      );
      _isResetPasswordInprogress = false;
      setState(() {});
      if (response.isSuccess) {
        _logger.d("successfully clicked");
        showsnackbarMassage(context, "Password reset successfully");
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => MainBottomNavScreen()),
          (predicate) => false,
        );
      } else {
        showsnackbarMassage(context, response.errorMassage, true);
      }
    } catch (e) {
      _logger.e(e);
    }
  }

  Logger _logger = Logger();
}
