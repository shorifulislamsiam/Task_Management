import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ostad_task_management/ui/utils/assetspaths.dart';
class background_widget extends StatelessWidget {
  const background_widget({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SvgPicture.asset(
          AssetPath.backgroundSvgImage,
          fit: BoxFit.cover,
        ),
        SafeArea(child: child),
      ],
    );
  }
}
