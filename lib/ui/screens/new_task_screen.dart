import 'package:flutter/material.dart';
import 'package:ostad_task_management/data/model/task_list_model.dart';
import 'package:ostad_task_management/data/model/task_status_count_model.dart';
import 'package:ostad_task_management/data/model/task_status_list_model.dart';
import 'package:ostad_task_management/data/service/network_clients.dart';
import 'package:ostad_task_management/data/utils/urls.dart';
import 'package:ostad_task_management/ui/screens/add_new_task_screen.dart';
import 'package:ostad_task_management/ui/widgets/SummeryCard.dart';
import 'package:ostad_task_management/ui/widgets/TMAppBar.dart';
import 'package:ostad_task_management/ui/widgets/TaskCard.dart';
import 'package:ostad_task_management/ui/widgets/show_snackbarMassage.dart';

import '../../data/model/task_model.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  bool _getStatusCountInprogressCount = false;
  List<TaskStatusCountModel> _taskStatusCountList = [];
  bool _getNewTaskInprogress = false;
  List<TaskModel> _newTaskList = [];

  @override
  void initState() {

    super.initState();
    _getAllStatusCount();
    _getNewStatusCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Visibility(
              visible: _getStatusCountInprogressCount == false,
              replacement: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              child: _buildSummery(),
            ),
            Visibility(
              visible: _getNewTaskInprogress ==false,
              replacement: SizedBox(
                height: 300,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              child: ListView.separated(
                separatorBuilder: (context, index) {
                  return SizedBox(height: 10);
                },
                primary: false,
                shrinkWrap: true,
                itemCount: _newTaskList.length,
                itemBuilder: (context, index) {
                  return TaskCard(
                      taskStatus: TaskStatus.sNew,
                      taskModel: _newTaskList[index],
                    refreshList: (){
                      _getNewStatusCount();
                      _getAllStatusCount();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewTask,
        child: Icon(Icons.add),
      ),
    );
  }

  _addNewTask() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddNewTaskScreen()),
    );
  }

  _buildSummery() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 100,
        child: ListView.builder(
          //shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: _taskStatusCountList.length,
          itemBuilder: (context, index) {
            return SummeryCard(
              count: _taskStatusCountList[index].count,
              title: _taskStatusCountList[index].status,
            );
          },
        ),
      ),
    );
  }

  Future<void> _getAllStatusCount() async {
    _getStatusCountInprogressCount = true;
    setState(() {});
    final NetworkResponse response = await NetworkClient.getRequest(
      url: Urls.taskStatusCount,
    );
    if (response.isSuccess) {
      TaskStatusListModel taskStatusListModel = TaskStatusListModel.fromJson(
        response.data ?? {},
      );
      _taskStatusCountList = taskStatusListModel.statusCountList;
    } else {
      showsnackbarMassage(context, response.errorMassage, true);
    }
    _getStatusCountInprogressCount = false;
    setState(() {});
  }

  Future<void> _getNewStatusCount() async {
    _getNewTaskInprogress = true;
    setState(() {});
    final NetworkResponse response = await NetworkClient.getRequest(
      url: Urls.newTaskStatus,
    );
    if (response.isSuccess) {
      TaskListModel taskListModel = TaskListModel.fromJson(
        response.data ?? {},
      );
      _newTaskList = taskListModel.taskList;
    } else {
      showsnackbarMassage(context, response.errorMassage, true);
    }
    _getNewTaskInprogress = false;
    setState(() {});
  }
}
