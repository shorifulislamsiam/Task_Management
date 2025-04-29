import 'dart:convert';
import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:ostad_task_management/data/model/user_model.dart';
import 'package:ostad_task_management/ui/controllers/auth_controller.dart';
import 'package:ostad_task_management/ui/widgets/TMAppBar.dart';
import 'package:ostad_task_management/ui/widgets/background_widget.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/service/network_clients.dart';
import '../../data/utils/urls.dart';
import '../widgets/show_snackbarMassage.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    UserModel userModel = AuthController.userModel!;
    _emailController.text = userModel.email;
    _firstNameController.text = userModel.firstName;
    _lastNameController.text = userModel.lastName;
    _mobileController.text = userModel.mobile;
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isUpdateUserProfile = false;
  final ImagePicker _imagePicker = ImagePicker();
  XFile ? _pickedImages;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: TMAppBar( fromProfileScreen: true),
        toolbarHeight: kToolbarHeight,
      ),
      body: background_widget(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  SizedBox(height: 32),

                  Text("Update Profile"),
                  SizedBox(height: 24),
                  _buildPhotoPickerWidget(),
                  SizedBox(height: 8),

                  TextFormField(
                    controller: _emailController,
                    textInputAction: TextInputAction.next,
                    enabled: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(hintText: 'Email'),
                    validator: (String? value) {
                      String email = value?.trim() ?? "";
                      if (EmailValidator.validate(email) == false) {
                        return "Give a validate email";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _firstNameController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(hintText: 'First Name'),
                    validator: (String? value) {
                      //String firstName = value?.trim()??"";
                      if (value?.isEmpty == true) {
                        return "Give a First Name";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _lastNameController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(hintText: 'Last Name'),
                    validator: (String? value) {
                      //String firstName = value?.trim()??"";
                      if (value?.isEmpty == true) {
                        return "Give a Last Name";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _mobileController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(hintText: 'Phone'),
                    validator: (String? value) {
                      RegExp regEx = RegExp(r"^(?:\\+88|88)?(01[3-9]\\d{8})$");
                      String phone = value?.trim() ?? "";
                      if (regEx.hasMatch(phone) ) {
                        return "Enter a valid mobile number";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(hintText: 'Password'),
                  ),
                  SizedBox(height: 18),
                  Visibility(
                    visible: _isUpdateUserProfile == false,
                    replacement: Center(
                      child: CircularProgressIndicator(),
                    ),
                    child: ElevatedButton(
                      onPressed: _ontapSubmitButton,
                      child: Icon(Icons.arrow_circle_right_outlined),
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

  void _ontapSubmitButton() {
    if (_formKey.currentState!.validate()) {}
    _UpdateUserProfile();
  }

  Future<void> _UpdateUserProfile() async {
    _isUpdateUserProfile = true;
    setState(() {});
    Map<String, dynamic> requestBody = {
      "email": _emailController.text.trim(),
      "firstName": _firstNameController.text,
      "lastName": _lastNameController.text,
      "mobile": _mobileController.text.trim(),
      "photo": _pickedImages
      //"password": _passwordController.text,
    };
    if (_passwordController.text.isNotEmpty) {
      requestBody["password"] = _passwordController.text;
    }
    if(_pickedImages != null){
      List<int> imageBytes = await _pickedImages!.readAsBytes();
      String encodedImage = base64Encode(imageBytes);
      requestBody["photo"] = encodedImage;
    }

    NetworkResponse response = await NetworkClient.postRequest(
      url: Urls.updateUserProfile,
      body: requestBody,
    );
    _isUpdateUserProfile = false;
    setState(() {});
    if (response.isSuccess) {


      //
      updateUserData();
      //


      _passwordController.clear();
      showsnackbarMassage(context, "User profile updated successfully");
    } else {
      showsnackbarMassage(context, response.errorMassage, true);
    }
  }


/////
 Future<void>updateUserData()async{
   UserModel updatedUserModel = UserModel.fromJson({
     "email": _emailController.text.trim(),
     "firstName": _firstNameController.text,
     "lastName": _lastNameController.text,
     "mobile": _mobileController.text.trim(),
     "photo": _pickedImages
   }
   );
   // Save the updated user information in SharedPreferences
   await AuthController.updateUserModel(updatedUserModel);

   // Refresh the UI by updating the user model and TextFields
   setState(() {
     AuthController.userModel = updatedUserModel;
     _emailController.text = updatedUserModel.email;
     _firstNameController.text = updatedUserModel.firstName;
     _lastNameController.text = updatedUserModel.lastName;
     _mobileController.text = updatedUserModel.mobile;
     _pickedImages = updatedUserModel.photo as XFile?;
   });
 }


  //////
  Future<void> _pickImage() async {
    XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery);
    if (image != null) {
      _pickedImages = image ;//File(image.path);
      setState(() {});
    }
  }

  Widget _buildPhotoPickerWidget() {
    return GestureDetector(
      onTap: _pickImage, //(){},
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              height: 50,
              width: 80,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
              alignment: Alignment.center,
              child: Text("Photo", style: TextStyle(color: Colors.white)),
            ),
            SizedBox(width: 8),
            Text(_pickedImages?.name ?? "Select Your Photo"),
          ],
        ),
      ),
    );
  }
  @override
  void dispose(){
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
