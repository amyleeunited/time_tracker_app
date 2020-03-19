import 'package:flutter/material.dart';
import 'package:time_tracker_app/home/jobs_form.dart';

class NewJobPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Save',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
            onPressed: () => _saveJob(),
          )
        ],
        title: Text(
          'New Job',
        ),
        centerTitle: true,
        elevation: 4.0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Card(
          child: SingleChildScrollView(
            child: JobsForm(),
          ),
        ),
      ),
    );
  }

  void _saveJob() {

  }
}
