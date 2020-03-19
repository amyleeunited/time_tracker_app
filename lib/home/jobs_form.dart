import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_app/common_widgets/form_submit_button.dart';
import 'package:time_tracker_app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:time_tracker_app/services/database.dart';
import 'package:flutter/services.dart';


import 'model/job.dart';

class JobsForm extends StatefulWidget {
  @override
  _JobsFormState createState() => _JobsFormState();
}

class _JobsFormState extends State<JobsForm> {


  final TextEditingController _jobNameController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();

  @override
  void dispose() {
    _jobNameController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: _buildChildren(),
      ),
    );
  }

  List<Widget> _buildChildren() {
    return [
//      Form(
//        child: Column(
//          children: <Widget>[
//            TextFormField(
//
//              validator: (value) {
//                if (value.isEmpty) {
//                  return 'Please enter a job';
//                }
//                return null;
//              },
//            ),
//          ],
//        ),
//      ),
      TextField(
        controller: _jobNameController,
        decoration: InputDecoration(
          labelText: 'Job Name',
          hintText: 'Enter a job',
        ),
      ),
      SizedBox(height: 10.0),
      TextField(
        controller: _rateController,
        decoration: InputDecoration(
          labelText: 'Rate Per Hour',
          hintText: 'Enter a rate',
        ),
      ),
      SizedBox(
        height: 10.0,
      ),
      FormSubmitButton(
        text: 'Save',
        onPressed: () => _createJob(context),
      )
    ];
  }

  Future<void> _createJob(BuildContext context) async{
    int rate = int.parse(_rateController.text);
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.createJob(
        Job(
            name: _jobNameController.text,
            ratePerHour: rate,
        ),
      );
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }
  }
}

