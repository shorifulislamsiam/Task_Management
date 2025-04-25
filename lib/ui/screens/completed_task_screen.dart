import 'package:flutter/material.dart';
import 'package:ostad_task_management/ui/widgets/TaskCard.dart';

import '../../data/model/task_list_model.dart';
import '../../data/model/task_model.dart';
import '../../data/service/network_clients.dart';
import '../../data/utils/urls.dart';
import '../widgets/show_snackbarMassage.dart';

class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {
  bool _getCompletedTaskInprogress = false;
  List<TaskModel> _completedTaskList = [];
  @override
  void initState() {
    super.initState();
    _getCompletedStatusCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Visibility(
        visible: _getCompletedTaskInprogress == false,
        replacement: Center(child: CircularProgressIndicator()),
        child: ListView.separated(
          separatorBuilder: (context, index) {
            return SizedBox(height: 10);
          },
          itemCount: _completedTaskList.length,
          itemBuilder: (context, index) {
            return TaskCard(
              taskStatus: TaskStatus.completed,
              taskModel: _completedTaskList[index],
              refreshList: _getCompletedStatusCount,
            );
          },
        ),
      ),
    );
  }

  Future<void> _getCompletedStatusCount() async {
    _getCompletedTaskInprogress = true;
    setState(() {});
    final NetworkResponse response = await NetworkClient.getRequest(
      url: Urls.completedTaskStatus,
    );
    if (response.isSuccess) {
      TaskListModel taskListModel = TaskListModel.fromJson(response.data ?? {});
      _completedTaskList = taskListModel.taskList;
    } else {
      showsnackbarMassage(context, response.errorMassage, true);
    }
    _getCompletedTaskInprogress = false;
    setState(() {});
  }
}
