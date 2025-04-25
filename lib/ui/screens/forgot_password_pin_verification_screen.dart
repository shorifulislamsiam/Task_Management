import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:ostad_task_management/ui/controllers/auth_controller.dart';
import 'package:ostad_task_management/ui/screens/reset_password_screen.dart';
import 'package:ostad_task_management/ui/widgets/background_widget.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../data/service/network_clients.dart';
import '../../data/utils/urls.dart';
import '../widgets/show_snackbarMassage.dart';

class forgot_password_pin_verification_screen extends StatefulWidget {
  const forgot_password_pin_verification_screen({super.key, required this.email});
  final String email;
  @override
  State<forgot_password_pin_verification_screen> createState() => _forgot_password_pin_verification_screenState();
}

class _forgot_password_pin_verification_screenState extends State<forgot_password_pin_verification_screen> {
  TextEditingController _pinCodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPinCodeInprogress = false;
  // @override
  // void initState(){
  //   super.initState();
  //   _pinCodeController = TextEditingController();
  // }
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
                  "PIN Verification",
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                SizedBox(height: 4,),
                Text(
                  "A 6 digit verification pin will be sent to your email.",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.grey),
                ),
                SizedBox(height: 24),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      PinCodeTextField(
                        length: 6,
                        obscureText: false,
                        animationType: AnimationType.fade,
                        keyboardType: TextInputType.number,
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(5),
                          fieldHeight: 50,
                          fieldWidth: 40,
                          activeFillColor: Colors.white,
                          selectedFillColor: Colors.white,
                          inactiveFillColor: Colors.white,
                        ),
                        animationDuration: const Duration(milliseconds: 300),
                        backgroundColor: Colors.transparent,
                        enableActiveFill: true,
                        controller: _pinCodeController,
                        appContext: context,
                        validator: (String? value){

                          if(value?.isEmpty == true){
                            return "give the otp";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _submitButton,
                  child: Icon(
                    Icons.arrow_circle_right_sharp,
                    color: Colors.white,
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
  void _submitButton(){
    if(_formKey.currentState!.validate()){
      _pinVerificationTesting();
    }
   // Navigator.push(context, MaterialPageRoute(builder: (_)=>ResetPasswordScreen()));
  }

  void _onTapSignUpButton(BuildContext context) {
    Navigator.pop(context);
  }
  // @override
  // void dispose(){
  //   _pinCodeController.dispose();
  //   super.dispose();
  // }


  Future<void> _pinVerificationTesting() async {
    //final int otp =  int.parse(_pinCodeController.text.trim());
    final String otp =  _pinCodeController.text.trim();
    try{
      _isPinCodeInprogress = true;
      setState(() {});

      final NetworkResponse response = await NetworkClient.getRequest(
        url: Urls.pinVerification(widget.email, otp),//AuthController.userModel?.email ?? ""

      );
      if (response.statusCode ==200) {
        showsnackbarMassage(context, "successfully sent");
        print("submit");
        Navigator.push(context, MaterialPageRoute(builder: (_)=>ResetPasswordScreen(email: widget.email, otp: otp,)));
      } else {
        showsnackbarMassage(context, response.errorMassage, true);
      }
      _isPinCodeInprogress = false;
      setState(() {});
    }catch(e){
      _isPinCodeInprogress = false;
      setState(() {

      });
      _logger.e(e);
    }
  }
  Logger _logger = Logger();


}
