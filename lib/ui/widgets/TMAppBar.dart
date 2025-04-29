import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ostad_task_management/data/model/user_model.dart';
import 'package:ostad_task_management/ui/controllers/auth_controller.dart';
import 'package:ostad_task_management/ui/screens/login_screen.dart';
import 'package:ostad_task_management/ui/screens/update_profile_screen.dart';

//This function i used but rafat vai actually used the stateless widget,if next time it needed then it will be used

class TMAppBar extends StatefulWidget {
  final bool? fromProfileScreen;

  TMAppBar({Key? key, this.fromProfileScreen}) : super(key: key);

  @override
  _TMAppBarState createState() => _TMAppBarState();
}

class _TMAppBarState extends State<TMAppBar> {
  @override
  Widget build(BuildContext context) {
    final UserModel? userUpdate = AuthController.userModel;
    TextTheme _textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () {
        if (widget.fromProfileScreen ?? false) {
          return;
        }
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => UpdateProfileScreen()),
        ).then((_) {
          // Trigger setState when returning from UpdateProfileScreen
          setState(() {});
        });
      },
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: _shouldShowImage(context, userUpdate?.photo)//AuthController.userModel!.photo
                ? MemoryImage(
              base64Decode( userUpdate?.photo ??AuthController.userModel!.photo ),//
            ): null,
          ),
          SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userUpdate?.fullName ?? AuthController.userModel!.fullName,//AuthController.userModel!.firstName
                style: _textTheme.bodyLarge?.copyWith(color: Colors.white),
              ),
              Text(
                userUpdate?.email ?? AuthController.userModel!.lastName,//AuthController.userModel!.lastName
                style: _textTheme.bodySmall?.copyWith(color: Colors.white),
              ),
            ],
          ),
          Spacer(),
          IconButton(
            onPressed: () => _logoutButton(context),
            icon: Icon(Icons.logout),
          ),
        ],
      ),
    );
  }

  bool _shouldShowImage(BuildContext context, String? photo) {
    return photo != null && photo.isNotEmpty;
  }

  Future<void> _logoutButton(BuildContext context) async {
    await AuthController.clearUserDataAfterLogOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
          (predicate) => false,
    );
  }
}







// Widget TMAppBar(BuildContext context, {bool? fromProfileScreen}) {
//   final UserModel? userUpdate = AuthController.userModel;
//   TextTheme _textTheme = Theme.of(context).textTheme;
//   return GestureDetector(
//     onTap: () {
//       if (fromProfileScreen ?? false) {
//         return;
//       }
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (_) => UpdateProfileScreen()),
//       );
//     },
//     child: Row(
//       children: [
//         CircleAvatar(
//           radius: 20,
//           backgroundImage:
//               _shouldShowImage(context,AuthController.userModel?.photo)
//                   ? MemoryImage(
//                     base64Decode(userUpdate?.photo ??AuthController.userModel!.photo),
//                   )
//                   : null,
//         ),
//         SizedBox(width: 8),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               userUpdate?.firstName ?? AuthController.userModel!.firstName,
//               //AuthController.userModel?.fullName ?? "Unknown",
//               //"Abdur Rahim",
//               style: _textTheme.bodyLarge?.copyWith(color: Colors.white),
//             ),
//             Text(
//               userUpdate?.email ?? AuthController.userModel!.email,
//               //AuthController.userModel?.email ?? "Unknown",
//               //"abdurRahim@gmail.com",
//               style: _textTheme.bodySmall?.copyWith(color: Colors.white),
//             ),
//           ],
//         ),
//         Spacer(),
//         IconButton(
//           onPressed: () => _logoutButton(context),
//           icon: Icon(Icons.logout),
//         ),
//       ],
//     ),
//   );
// }
//
// bool _shouldShowImage(context,String? photo) {
//   return photo != null && photo.isNotEmpty;
// }
//
// Future<void> _logoutButton(BuildContext context) async {
//   await AuthController.clearUserDataAfterLogOut();
//
//   Navigator.pushAndRemoveUntil(
//     context,
//     MaterialPageRoute(builder: (_) => LoginScreen()),
//     (predicate) => false,
//   );
// }


