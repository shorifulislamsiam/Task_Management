import 'package:flutter/material.dart';
import 'package:ostad_task_management/data/service/network_clients.dart';
import 'package:ostad_task_management/data/utils/urls.dart';
import 'package:ostad_task_management/ui/widgets/TMAppBar.dart';
import 'package:ostad_task_management/ui/widgets/show_snackbarMassage.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isAddNewTaskProgress = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        //leading: IconButton(onPressed: (){Navigator.pop(context);},icon: Icon( Icons.arrow_back)),
        title: TMAppBar(),
        toolbarHeight: kToolbarHeight,
      ),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30),
                  Text(
                    "Add New Task",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 24),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(labelText: "Subject"),
                    controller: _subjectController,
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return "Give a subject";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    textInputAction: TextInputAction.done,
                    controller: _detailsController,
                    maxLines: 6,
                    decoration: InputDecoration(labelText: "Description"),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return "Give a subject";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 30),
                  Visibility(
                    visible: _isAddNewTaskProgress ==false,
                    replacement: Center(
                      child: CircularProgressIndicator(),
                    ),
                    child: ElevatedButton(
                      onPressed: _onTapAddNewSubmitButton,
                      child: Icon(
                        Icons.arrow_circle_right_sharp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onTapAddNewSubmitButton() {
    if (_formKey.currentState!.validate()) {
      _addNewTask();
    }
  }

  Future<void> _addNewTask() async {
    _isAddNewTaskProgress = true;
    setState(() {});
    Map<String, dynamic> requestBody = {
      "title": _subjectController.text.trim(),
      "description": _detailsController.text.trim(),
      "status": "New",
    };
    final NetworkResponse response = await NetworkClient.postRequest(
      url: Urls.createNewTask,
      body: requestBody,
    );
    _isAddNewTaskProgress = false;
    setState(() { });
    if(response.isSuccess){
      _clearTextFields();
      showsnackbarMassage(context, "New task added");

    }else{
      showsnackbarMassage(context, response.errorMassage);
    }
  }

  void _clearTextFields(){
    _subjectController.clear();
    _detailsController.clear();
  }
  @override
  void dispose() {
    _subjectController.dispose();
    _detailsController.dispose();
    super.dispose();
  }
}
