import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:ostad_task_management/apps.dart';
import 'package:ostad_task_management/ui/controllers/auth_controller.dart';
import 'package:ostad_task_management/ui/screens/login_screen.dart';

class NetworkResponse {
  final bool isSuccess;
  final int statusCode;
  final Map<String, dynamic>? data;
  final String errorMassage;

  NetworkResponse({
    required this.isSuccess,
    required this.statusCode,
    this.data,
    this.errorMassage = "Something went wrong",
  });
}

class NetworkClient {
  static final Logger _logger = Logger();

  static Future<NetworkResponse> getRequest({required String url}) async {
    try {
      Uri uri = Uri.parse(url);
      Map<String, String>headers={
        "token":AuthController.token??""
      };
      _preRequestLog(url,headers);
      //_logger.i("Url=>$url");
      Response response = await get(uri,headers: headers);
      _postRequestLog(url, response.statusCode,headers: response.headers,responseBody: response.body);
      // _logger.i(
      //   "Status code: ${response.statusCode}\n"
      //   "Header: ${response.headers}\n"
      //   "Response: ${response.body}",
      // );
      if (response.statusCode == 200) {
        final decodeJson = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          data: decodeJson,
        );
      } else if (response.statusCode == 401){
        _moveToLoginScreen();
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMassage: "Un-Authorized user access! Please login again",
        );
      }
      else {
        final decodeJson = jsonDecode(response.body);
        String errorMassage = decodeJson["data"] ?? "something went wrong";
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMassage: errorMassage,
        );
      }
    } catch (e) {
      _postRequestLog(url, -1,errorMassage: e.toString());
      //_logger.e(e.toString());
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMassage: e.toString(),
      );
    }
  }

  static Future<NetworkResponse> postRequest({
    required String url,
    Map<String, dynamic>? body,
  }) async {
    try {
      Uri uri = Uri.parse(url);
      Map<String, String>headers={
        "Content-type": "Application/json",
        "token":AuthController.token??""
      };
      _preRequestLog(url,headers,body: body);
      // _logger.i(
      //   "Url=>$url\n"
      //   "Body=>$body",
      // );
      Response response = await post(
        uri,
        headers: headers,
        body: jsonEncode(body),
      );
      _postRequestLog(url, -1,headers: response.headers,responseBody: response.body);
      // _logger.i(
      //   "Status code: ${response.statusCode}\n"
      //   "Header: ${response.headers}\n"
      //   "Response: ${response.body}",
      // );
      if (response.statusCode == 200) {
        final decodeJson = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          data: decodeJson,
        );
      }else if (response.statusCode == 401){
        _moveToLoginScreen();
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMassage: "Un-Authorized user access! Please login again",
        );
      } else {
        final decodeJson = jsonDecode(response.body);
        String errorMassage = decodeJson["data"] ?? "Something went wrong";
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMassage: errorMassage,
        );
      }
    } catch (e) {
      _postRequestLog(url, -1,errorMassage: e.toString());
      //_logger.e(e.toString());
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMassage: e.toString(),
      );
    }
  }

  static void _preRequestLog(String url,Map<String, String>header, {Map<String, dynamic>? body}) {
    _logger.i(
      "Url=>$url\nHeaders:$header\n"
      "Body=>$body",
    );
  }

  static void _postRequestLog(
    String url,
    int statusCode, {
    Map<String, dynamic>? headers,
    dynamic responseBody,
        dynamic errorMassage,
  }) {
    if(errorMassage != null){
      _logger.e(
        "Url=> $url"
            "Status code: $statusCode}\n"
          "error Massage: $errorMassage}",);
    }else {
      _logger.i(
        "Url=> $url"
            "Status code: $statusCode}\n"
            "Header: $headers}\n"
            "Response: $responseBody}",
      );
    }
  }

  static Future<void> _moveToLoginScreen( )async{
    await AuthController.clearUserDataAfterLogOut();
    Navigator.pushAndRemoveUntil(
      TaskMangerApps.navigatorKey.currentContext!,
       // context,
        MaterialPageRoute(builder: (_)=>LoginScreen()),
            (predicate)=>false);
  }
}
