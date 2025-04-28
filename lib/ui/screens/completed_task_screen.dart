import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ostad_task_management/ui/controllers/get_completedtask_controller.dart';
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
  final GetCompletedTaskController getCompletedTaskController = Get.find<GetCompletedTaskController>();
  @override
  void initState() {
    super.initState();
    _getCompletedStatusCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder(
        init: getCompletedTaskController,
        builder: (controller) {
          return Visibility(
            visible: controller.getCompletedTaskInprogress == false,
            replacement: Center(child: CircularProgressIndicator()),
            child: ListView.separated(
              separatorBuilder: (context, index) {
                return SizedBox(height: 10);
              },
              itemCount: controller.completedTaskList.length,
              itemBuilder: (context, index) {
                return TaskCard(
                  taskStatus: TaskStatus.completed,
                  taskModel: controller.completedTaskList[index],
                  refreshList: _getCompletedStatusCount,
                );
              },
            ),
          );
        }
      ),
    );
  }

  Future<void> _getCompletedStatusCount() async {
    bool isSuccess = await getCompletedTaskController.getProgressStatusCount();
    if (!isSuccess) {
      showsnackbarMassage(context, getCompletedTaskController.errorMassage!, true);
    }
  }
}
