import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ostad_task_management/data/model/task_status_count_model.dart';
import 'package:ostad_task_management/ui/controllers/get_alltask_controller.dart';
import 'package:ostad_task_management/ui/controllers/get_newtask_controller.dart';
import 'package:ostad_task_management/ui/screens/add_new_task_screen.dart';
import 'package:ostad_task_management/ui/widgets/SummeryCard.dart';
import 'package:ostad_task_management/ui/widgets/TaskCard.dart';
import 'package:ostad_task_management/ui/widgets/show_snackbarMassage.dart';


class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {

  final GetNewTaskController getNewTaskController = Get.find<GetNewTaskController>();
  final GetAllTaskController getAllTaskController = Get.find<GetAllTaskController>();


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
            GetBuilder(
              init: getAllTaskController,
              builder: (controller) {
                return Visibility(
                  visible: controller.getAllNewTaskInprogress == false,
                  replacement: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  child: _buildSummery(),
                );
              }
            ),
            GetBuilder(
              init: getNewTaskController,
              builder: (controller) {
                return Visibility(
                  visible: controller.getNewTaskInprogress == false,
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
                    itemCount: controller.newTaskList.length,
                    itemBuilder: (context, index) {
                      return TaskCard(
                          taskStatus: TaskStatus.sNew,
                          taskModel: controller.newTaskList[index],
                        refreshList: (){
                          _getNewStatusCount();
                          _getAllStatusCount();
                        },
                      );
                    },
                  ),
                );
              }
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
        child: GetBuilder(
          init: getAllTaskController,
          builder: (controller) {
            return ListView.builder(
              //shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: controller.allNewTaskList.length,
              itemBuilder: (context, index) {
                return SummeryCard(
                  count: controller.allNewTaskList[index].count,
                  title: controller.allNewTaskList[index].status,
                );
              },
            );
          }
        ),
      ),
    );
  }

  // Future<void> _getAllStatusCount() async {
  //   _getStatusCountInprogressCount = true;
  //   setState(() {});
  //   final NetworkResponse response = await NetworkClient.getRequest(
  //     url: Urls.taskStatusCount,
  //   );
  //   if (response.isSuccess) {
  //     TaskStatusListModel taskStatusListModel = TaskStatusListModel.fromJson(
  //       response.data ?? {},
  //     );
  //     _taskStatusCountList = taskStatusListModel.statusCountList;
  //   } else {
  //     showsnackbarMassage(context, response.errorMassage, true);
  //   }
  //   _getStatusCountInprogressCount = false;
  //   setState(() {});
  // }

  Future<void> _getAllStatusCount() async {
    bool isSuccess = await getAllTaskController.getAllStatusCount();
    if (!isSuccess) {
      showsnackbarMassage(context, getAllTaskController.errorMassage!, true);
    }
  }

  Future<void> _getNewStatusCount() async {
    bool isSuccess = await getNewTaskController.getNewStatusCount();
    if (!isSuccess) {
      showsnackbarMassage(context, getNewTaskController.errorMassage!, true);
    }
  }
}
