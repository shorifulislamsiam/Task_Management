import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ostad_task_management/data/service/network_clients.dart';
import 'package:ostad_task_management/data/utils/urls.dart';
import 'package:ostad_task_management/ui/widgets/show_snackbarMassage.dart';

import '../../data/model/task_model.dart';

enum TaskStatus { sNew, progress, completed, cancelled }

class TaskCard extends StatefulWidget {
  const TaskCard({
    super.key,
    required this.taskStatus,
    required this.taskModel,
    required this.refreshList,
  });

  final TaskStatus taskStatus;
  final TaskModel taskModel;
  final VoidCallback refreshList;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {

  bool _inProgress = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.taskModel.title,
              //"Title will be here",
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            Text(widget.taskModel.description), //"Description will be here"
            Text(DateFormat("dd MMMM yyyy, hh:mm:ss").format(DateTime.parse(widget.taskModel.createdDate))),
            //Text(widget.taskModel.createdDate), //"Date: 17/03/25"
            Row(
              children: [
                Chip(
                  label: Text(widget.taskModel.status),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  backgroundColor: _getStatusChipColor(),
                  side: BorderSide.none,
                ),
                Spacer(),
                Visibility(
                  visible: _inProgress ==false,
                  replacement: Center(
                    child: CircularProgressIndicator(),
                  ),
                  child: Row(
                    children: [
                      IconButton(onPressed: _deleteTaskStatus, icon: Icon(Icons.delete)),
                      IconButton(
                        onPressed: _showUpdateStatusDialog,
                        icon: Icon(Icons.edit),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusChipColor() {
    late Color color;
    switch (widget.taskStatus) {
      case TaskStatus.sNew:
        color = Colors.blue;
      case TaskStatus.progress:
        color = Colors.purple;
      case TaskStatus.completed:
        color = Colors.green;
      case TaskStatus.cancelled:
        color = Colors.red;
    }
    return color;
  }

  void _showUpdateStatusDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Update Status"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: () {
                  _popDialog();
                  if (isSelected("New")) return;
                  _changedTaskStatus("New");
                },
                title: Text("New"),
                trailing: isSelected("New") ? Icon(Icons.done) : null,
              ),
              ListTile(
                onTap: () {
                  _popDialog();
                  if (isSelected("Progress")) return;
                  _changedTaskStatus("Progress");
                },
                title: Text("Progress"),
                trailing: isSelected("Progress") ? Icon(Icons.done) : null,
              ),
              ListTile(
                onTap: () {
                  _popDialog();
                  if (isSelected("Completed")) return;
                  _changedTaskStatus("Completed");
                },
                title: Text("Completed"),
                trailing: isSelected("Completed") ? Icon(Icons.done) : null,
              ),
              ListTile(
                onTap: () {
                  _popDialog();
                  if (isSelected("Cancelled")) return;
                  _changedTaskStatus("Cancelled");
                },
                title: Text("Cancelled"),
                trailing: isSelected("Cancelled") ? Icon(Icons.done) : null,
              ),
            ],
          ),
        );
      },
    );
  }

  void _popDialog(){
    Navigator.pop(context);
  }

  bool isSelected(String status) => widget.taskModel.status == status;

  Future<void> _changedTaskStatus(String status) async {
    _inProgress = true;
    setState(() {});
    final NetworkResponse response = await NetworkClient.getRequest(
      url: Urls.updateTaskStatus(widget.taskModel.id, status),
    );
    _inProgress = false;
    setState(() {

    });
    if (response.isSuccess) {
      widget.refreshList();
    } else {
      setState(() {});
      showsnackbarMassage(context, response.errorMassage, true);
    }
  }
  Future<void> _deleteTaskStatus() async {
    _inProgress = true;
    setState(() {});
    final NetworkResponse response = await NetworkClient.getRequest(
      url: Urls.deleteTaskStatus(widget.taskModel.id),
    );
    _inProgress = false;
    setState(() {

    });
    if (response.isSuccess) {
      widget.refreshList();
    } else {
      setState(() {});
      showsnackbarMassage(context, response.errorMassage, true);
    }
  }

}

// Widget TaskCard(context, Color color, {final taskStatus}) {
//   return Card(
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           "Title will be here",
//           style: Theme.of(
//             context,
//           ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
//         ),
//         Text("Description will be here"),
//         Text("Date: 17/03/25"),
//         Row(
//           children: [
//             Chip(
//               label: Text(taskStatus!),//Text("New"),
//               padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(50),
//               ),
//               backgroundColor: color,
//               side: BorderSide.none,
//             ),
//             Spacer(),
//             IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
//             IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
//           ],
//         ),
//       ],
//     ),
//   );
// }
