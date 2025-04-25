import 'package:flutter/material.dart';
import 'package:ostad_task_management/ui/screens/cancel_task_screen.dart';
import 'package:ostad_task_management/ui/screens/completed_task_screen.dart';
import 'package:ostad_task_management/ui/screens/new_task_screen.dart';
import 'package:ostad_task_management/ui/screens/progress_task_screen.dart';
import 'package:ostad_task_management/ui/widgets/TMAppBar.dart';

class MainBottomNavScreen extends StatefulWidget {
  const MainBottomNavScreen({super.key});

  @override
  State<MainBottomNavScreen> createState() => _MainBottomNavScreenState();
}

class _MainBottomNavScreenState extends State<MainBottomNavScreen> {
  int _selectedIndex = 0;
  List<Widget> _navigationScreen = [
    NewTaskScreen(),
    ProgressTaskScreen(),
    CompletedTaskScreen(),
    CancelTaskScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: TMAppBar(),
        toolbarHeight: kToolbarHeight,

      ),
      body: _navigationScreen[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          _selectedIndex = index;
          setState(() {});
        },
        destinations: [
          NavigationDestination(
              icon: Icon(Icons.new_label),
              label: "New",
          ),
          NavigationDestination(
            icon: Icon(Icons.downloading),
            label: "progress",
          ),
          NavigationDestination(
              icon: Icon(Icons.done),
              label: "Complete",
          ),
          NavigationDestination(
            icon: Icon(Icons.cancel_outlined),
            label: "Cancelled",
          ),
        ],
      ),
    );
  }
}
