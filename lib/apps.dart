import 'package:flutter/material.dart';
import 'package:ostad_task_management/ui/screens/splash_screen.dart';

class TaskMangerApps extends StatelessWidget {
  const TaskMangerApps({super.key});
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: TaskMangerApps.navigatorKey,
      theme: ThemeData(
        colorSchemeSeed: Colors.green,
        inputDecorationTheme: InputDecorationTheme(
          contentPadding: EdgeInsets.symmetric(horizontal: 18),
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          )
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            fixedSize: Size.fromWidth(double.maxFinite),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        textTheme: TextTheme(
          displayMedium: TextStyle(fontSize: 24,color: Colors.black,fontWeight: FontWeight.bold)
        )
      ),

      home: splash_screen(),
      debugShowCheckedModeBanner: false,
      // initialRoute: "/",
      // routes: {
      //   "/":(context)=>splash_screen(),
      //   "/":(context)=>splash_screen(),
      // },
    );
  }
}
