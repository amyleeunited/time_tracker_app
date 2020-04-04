import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_app/common_widgets/platform_alert_dialog.dart';
import 'package:time_tracker_app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:time_tracker_app/home/job_entries/job_entries_page.dart';
import 'package:time_tracker_app/home/jobs/edit_job_page.dart';
import 'package:time_tracker_app/home/jobs/jobs_list_tile.dart';
import 'package:time_tracker_app/home/jobs/list_items_builder.dart';
import 'package:time_tracker_app/home/model/job.dart';
import 'package:time_tracker_app/services/auth.dart';
import 'package:time_tracker_app/services/database.dart';
import 'package:flutter/services.dart';

class JobsPage extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await PlatformAlertDialog(
      title: 'Logout',
      cancelActionText: 'Cancel',
      content: 'Are you sure you want to logout?',
      defaultActionText: 'Logout',
    ).show(context);
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  Future<void> _delete(BuildContext context, Job job) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.deleteJob(job);
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Jobs'),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Logout',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
            onPressed: () => _confirmSignOut(context),
//            onPressed: _signOut,
          )
        ],
      ),
      body: _buildContent(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
        ),
        onPressed: () => EditJobPage.show(context, database:database, job: null),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Job>>(
      stream: database.jobsStream(),
      builder: (context, snapshot) {
        return ListItemsBuilder(
            snapshot: snapshot,
            itemBuilder: (context, job) => Dismissible(
                  background: Container(color: Colors.red),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) => _delete(context, job),
                  child: JobsListTile(
                    job: job,
                    onTap: () => JobEntriesPage.show(context, job),
                  ),
                  key: Key('job-${job.id}'),
                ));
      },
    );
  }
}
