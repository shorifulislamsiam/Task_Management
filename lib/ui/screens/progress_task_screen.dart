import 'package:flutter/material.dart';
import 'package:ostad_task_management/ui/widgets/TaskCard.dart';

import '../../data/model/task_list_model.dart';
import '../../data/model/task_model.dart';
import '../../data/service/network_clients.dart';
import '../../data/utils/urls.dart';
import '../widgets/show_snackbarMassage.dart';

class ProgressTaskScreen extends StatefulWidget {
  const ProgressTaskScreen({super.key});

  @override
  State<ProgressTaskScreen> createState() => _ProgressTaskScreenState();
}

class _ProgressTaskScreenState extends State<ProgressTaskScreen> {
  bool _getProgressTaskInprogress = false;
  List<TaskModel> _progressTaskList = [];
  @override
  void initState() {
    super.initState();
    _getProgressStatusCount();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Visibility(
        visible: _getProgressTaskInprogress == false,
        replacement: Center(
          child: CircularProgressIndicator(),
        ),
        child: ListView.separated(
          separatorBuilder: (context, index){
            return SizedBox(height: 10,);
          },
          itemCount: _progressTaskList.length,
          itemBuilder: (context,index){
             return TaskCard(
               taskStatus: TaskStatus.progress,
               taskModel: _progressTaskList[index],
               refreshList: _getProgressStatusCount,
             );
          },
        ),
      ),
    );
  }
  Future<void> _getProgressStatusCount() async {
    _getProgressTaskInprogress = true;
    setState(() {});
    final NetworkResponse response = await NetworkClient.getRequest(
      url: Urls.progressTaskStatus,
    );
    if (response.isSuccess) {
      TaskListModel taskListModel = TaskListModel.fromJson(response.data ?? {});
      _progressTaskList = taskListModel.taskList;
    } else {
      showsnackbarMassage(context, response.errorMassage, true);
    }
    _getProgressTaskInprogress = false;
    setState(() {});
  }
}

