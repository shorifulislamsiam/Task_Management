import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ostad_task_management/ui/controllers/auth_controller.dart';
import 'package:ostad_task_management/ui/screens/login_screen.dart';
import 'package:ostad_task_management/ui/screens/main_bottom_nav_screen.dart';
import 'package:ostad_task_management/ui/utils/assetspaths.dart';
import 'package:ostad_task_management/ui/widgets/background_widget.dart';

class splash_screen extends StatefulWidget {
  const splash_screen({super.key});

  @override
  State<splash_screen> createState() => _splash_screenState();
}

class _splash_screenState extends State<splash_screen> {
  @override
  void initState() {
    super.initState();
    _goToLoginPage();
  }

  void _goToLoginPage() async {
    await Future.delayed(Duration(seconds: 3));
    final bool isLoggedIn = await AuthController.checkIfUserLoggedInOrNot();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => isLoggedIn? MainBottomNavScreen(): LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: background_widget(
          child: Center(child: SvgPicture.asset("assets/images/logo.svg")),
        ),
      ),
    );
  }
}
