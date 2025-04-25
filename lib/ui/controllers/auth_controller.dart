import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:ostad_task_management/data/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController{
  static String? token;
  static UserModel? userModel;

  static const String _tokenKey = "token";
  static const String _userDataKey = "user-data";

  //To save the login info locally via Shared_preference
  static Future<void> saveUserInformation(String accessToken,UserModel user)async{
    SharedPreferences sharedPreferences =await SharedPreferences.getInstance();
    sharedPreferences.setString(_tokenKey, accessToken);
    sharedPreferences.setString(_userDataKey, jsonEncode(user.toJson()));

    token = accessToken;
    userModel = user;
  }
  //To get the login info from locally via Shared_preference

  static Future<void> getUserInformation()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? accessToken= sharedPreferences.getString(_tokenKey);
    String? savedUserModelString = sharedPreferences.getString(_userDataKey);
    if(savedUserModelString != null){
      UserModel savedUserModel = UserModel.fromJson(jsonDecode(savedUserModelString));
      userModel = savedUserModel;
    }
    token = accessToken;
  }

  //check if user already logged in
  static Future<bool> checkIfUserLoggedInOrNot()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userAccessToken = sharedPreferences.getString(_tokenKey);
    if(userAccessToken != null){
      await getUserInformation();
      return true;
    }
    return false;
  }

  static Future<void> clearUserDataAfterLogOut() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
    token = null;
    userModel = null;
  }
////
  static Future<void> updateUserModel(UserModel updatedUserModel) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(_userDataKey, jsonEncode(updatedUserModel.toJson()));
    userModel = updatedUserModel;
  }

////


}