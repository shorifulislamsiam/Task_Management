import 'package:flutter/material.dart';
import 'package:ostad_task_management/ui/widgets/TaskCard.dart';

import '../../data/model/task_list_model.dart';
import '../../data/model/task_model.dart';
import '../../data/service/network_clients.dart';
import '../../data/utils/urls.dart';
import '../widgets/show_snackbarMassage.dart';

class CancelTaskScreen extends StatefulWidget {
  const CancelTaskScreen({super.key});

  @override
  State<CancelTaskScreen> createState() => _CancelTaskScreenState();
}

class _CancelTaskScreenState extends State<CancelTaskScreen> {
  bool _getCancelTaskInprogress = false;
  List<TaskModel> _calcelTaskList = [];
  @override
  void initState() {
    super.initState();
    _getCancelStatusCount();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Visibility(
        visible: _getCancelTaskInprogress == false,
        replacement: Center(
          child: CircularProgressIndicator(),
        ),
        child: ListView.separated(
          separatorBuilder: (context, index){
            return SizedBox(height: 10,);
          },
          itemCount: _calcelTaskList.length,
          itemBuilder: (context, index){
             return TaskCard(
               taskStatus: TaskStatus.cancelled,
               taskModel: _calcelTaskList[index],
               refreshList: _getCancelStatusCount,);
          },
        ),
      ),
    );
  }
  Future<void> _getCancelStatusCount() async {
    _getCancelTaskInprogress = true;
    setState(() {});
    final NetworkResponse response = await NetworkClient.getRequest(
      url: Urls.cancelTaskStatus,
    );
    if (response.isSuccess) {
      TaskListModel taskListModel = TaskListModel.fromJson(response.data ?? {});
      _calcelTaskList = taskListModel.taskList;
    } else {
      showsnackbarMassage(context, response.errorMassage, true);
    }
    _getCancelTaskInprogress = false;
    setState(() {});
  }
}
