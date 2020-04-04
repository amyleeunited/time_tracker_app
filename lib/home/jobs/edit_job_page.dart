import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_app/app/signin/validator.dart';
import 'package:time_tracker_app/common_widgets/platform_alert_dialog.dart';
import 'package:time_tracker_app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:time_tracker_app/home/model/job.dart';
import 'package:time_tracker_app/services/database.dart';

class EditJobPage extends StatefulWidget with NewJobEntryStringValidator {
  EditJobPage({@required this.database, this.job});

  final Database database;
  final Job job;

  static Future<void> show(BuildContext context, {Database database, Job job}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditJobPage(
          database: database,
          job: job,
        ),
      ),
    );
  }

  @override
  _EditJobPageState createState() => _EditJobPageState();
}

class _EditJobPageState extends State<EditJobPage> {
  final TextEditingController _jobNameController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final FocusNode _jobNameFocusNode = FocusNode();
  final FocusNode _rateFocusNode = FocusNode();

  @override
  initState() {
    if (widget.job != null) {
      _jobNameController.text = widget.job.name;
      _rateController.text = (widget.job.ratePerHour).toString();
    }
    super.initState();
  }

  String get _name => _jobNameController.text;

  int get _ratePerHour => int.tryParse(_rateController.text);

//  String _name;
//  int _ratePerHour;

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _jobNameController.dispose();
    _rateController.dispose();
    _jobNameFocusNode.dispose();
    _rateFocusNode.dispose();
    super.dispose();
  }

  void _onJobNameEditingComplete() {
    final newFocus = widget.jobNameStringValidator.isValid(_name)
        ? _rateFocusNode
        : _jobNameFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _saveJob() async {
    if (_validateAndSaveForm()) {
      try {
        final jobs = await widget.database.jobsStream().first;
        final allNames = jobs.map((job) => job.name).toList();
        if(widget.job != null){
          allNames.remove(widget.job.name);
        }
        if (allNames.contains(_name)) {
          PlatformAlertDialog(
            title: 'Name already used',
            content: 'Please enter another job name',
            defaultActionText: 'OK',
          ).show(context);
        } else {
          final id = widget.job?.id ?? documentIdFromCurrentDate();
          await widget.database.setJob(
            Job(name: _name, ratePerHour: _ratePerHour, id: id),
          );
          Navigator.of(context).pop();
        }
      } on PlatformException catch (e) {
        PlatformExceptionAlertDialog(
          title: 'Operation failed',
          exception: e,
        ).show(context);
      }
    }
  }

  

  @override
  Widget build(BuildContext context) {
//    bool _submitEnabled = widget.jobNameStringValidator.isValid(_name) &&
//        widget.rateStringValidator.isValid(_rateController.text) &&
//        !_isLoading;
//
//    print(widget.rateStringValidator.isValid(_rateController.text));

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(widget.job == null ? 'New Jobs' : 'Edit Jobs'),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Save',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
            onPressed: _saveJob,
          )
        ],
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: _buildForm(),
      ),
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
              child: Form(
          key: _formKey,
          child: Column(
            children:
             _buildFormChildren(),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        enabled: _isLoading == false,
        controller: _jobNameController,
        validator: (value) =>
            value.isNotEmpty ? null : "Job Name can\'t be empty",
//        onSaved: (value) => _name = value,
        decoration: InputDecoration(
          labelText: 'Job Name',
        ),
        focusNode: _jobNameFocusNode,
        textInputAction: TextInputAction.next,
//        onChanged: _updateState(),
        onEditingComplete: _onJobNameEditingComplete,
      ),
      TextFormField(
        enabled: _isLoading == false,
        controller: _rateController,
//        onSaved: (value) => _ratePerHour = int.parse(value) ?? 0,
        keyboardType: TextInputType.numberWithOptions(),
        decoration: InputDecoration(
          labelText: 'Rate Per Hour',
        ),
        focusNode: _rateFocusNode,
        textInputAction: TextInputAction.done,
//        onChanged: (rate) => _updateState,
        onEditingComplete: _saveJob,
      ),
    ];
  }
}
