import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ostad_task_management/ui/controllers/get_cancalledtask_controller.dart';
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
  final GetCancelledTaskController getCancelledTaskController = Get.find<GetCancelledTaskController>();

  @override
  void initState() {
    super.initState();
    _getCancelStatusCount();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder(
        init: getCancelledTaskController,
        builder: (controller) {
          return Visibility(
            visible: controller.isGetCancalledTaskInProgress == false,
            replacement: Center(
              child: CircularProgressIndicator(),
            ),
            child: ListView.separated(
              separatorBuilder: (context, index){
                return SizedBox(height: 10,);
              },
              itemCount: controller.cancalledTaskList.length,
              itemBuilder: (context, index){
                 return TaskCard(
                   taskStatus: TaskStatus.cancelled,
                   taskModel: controller.cancalledTaskList[index],//_calcelTaskList[index],
                   refreshList: _getCancelStatusCount,);
              },
            ),
          );
        }
      ),
    );
  }
  Future<void> _getCancelStatusCount() async {
    bool isSuccess = await getCancelledTaskController.getCancalledTask();
    if (!isSuccess) {
      showsnackbarMassage(context, getCancelledTaskController.errorMassage!, true);
    }
  }
}
