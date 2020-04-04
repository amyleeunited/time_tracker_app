// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
// import 'package:time_tracker_app/app/signin/validator.dart';
// import 'package:time_tracker_app/common_widgets/platform_alert_dialog.dart';
// import 'package:time_tracker_app/common_widgets/platform_exception_alert_dialog.dart';
// import 'package:time_tracker_app/home/model/job.dart';
// import 'package:time_tracker_app/services/database.dart';
// import 'package:time_tracker_app/temp/city.dart';

// class MyEditJobPage extends StatefulWidget with NewJobEntryStringValidator {
//   MyEditJobPage({@required this.database, this.job});

//   final Database database;
//   final Job job;

//   static Future<void> show(BuildContext context, {Job job}) async {
//     final database = Provider.of<Database>(context, listen: false);
//     await Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) => MyEditJobPage(
//           database: database,
//           job: job,
//         ),
//       ),
//     );
//   }

//   @override
//   _MyEditJobPageState createState() => _MyEditJobPageState();
// }

// class _MyEditJobPageState extends State<MyEditJobPage> {
//   final TextEditingController _jobNameController = TextEditingController();
//   final TextEditingController _rateController = TextEditingController();
//   final FocusNode _jobNameFocusNode = FocusNode();
//   final FocusNode _rateFocusNode = FocusNode();

//   @override
//   initState() {
//     if (widget.job != null) {
//       _jobNameController.text = widget.job.name;
//       _rateController.text = (widget.job.ratePerHour).toString();
//     }
//     super.initState();
//   }

//   String get _name => _jobNameController.text;

//   int get _ratePerHour => int.tryParse(_rateController.text);

// //  String _name;
// //  int _ratePerHour;

//   final _formKey = GlobalKey<FormState>();
//   bool _isLoading = false;

//   @override
//   void dispose() {
//     _jobNameController.dispose();
//     _rateController.dispose();
//     _jobNameFocusNode.dispose();
//     _rateFocusNode.dispose();
//     super.dispose();
//   }

//   void _onJobNameEditingComplete() {
//     final newFocus = widget.jobNameStringValidator.isValid(_name)
//         ? _rateFocusNode
//         : _jobNameFocusNode;
//     FocusScope.of(context).requestFocus(newFocus);
//   }

//   bool _validateAndSaveForm() {
//     final form = _formKey.currentState;
//     if (form.validate()) {
//       form.save();
//       return true;
//     }
//     return false;
//   }

  // Future<void> _saveJob() async {
  //   if (_validateAndSaveForm()) {
  //     try {
  //       final jobs = await widget.database.jobsStream().first;
  //       final allNames = jobs.map((job) => job.name).toList();
  //       if (allNames.contains(_name)) {
  //         PlatformAlertDialog(
  //           title: 'Name already used',
  //           content: 'Please enter another job name',
  //           defaultActionText: 'OK',
  //         ).show(context);
  //       } else {
  //         await widget.database.setJob(
  //           Job(name: _name, ratePerHour: _ratePerHour),
  //         );
  //         Navigator.of(context).pop();
  //       }
  //     } on PlatformException catch (e) {
  //       PlatformExceptionAlertDialog(
  //         title: 'Operation failed',
  //         exception: e,
  //       ).show(context);
  //     }
  //   }
  // }

  // @override
  // Widget build(BuildContext context) {
//    bool _submitEnabled = widget.jobNameStringValidator.isValid(_name) &&
//        widget.rateStringValidator.isValid(_rateController.text) &&
//        !_isLoading;
//
//    print(widget.rateStringValidator.isValid(_rateController.text));

  //   return Scaffold(
  //     backgroundColor: Colors.grey[200],
  //     appBar: AppBar(
  //       title: Text(widget.job == null ? 'My City' : 'My Edit City'),
  //       centerTitle: true,
  //       actions: <Widget>[
  //         FlatButton(
  //           child: Text(
  //             'Save',
  //             style: TextStyle(
  //               fontSize: 18.0,
  //               color: Colors.white,
  //             ),
  //           ),
  //           // onPressed: _saveJob,
  //         )
  //       ],
  //     ),
  //     // body: _buildContent(),
  //   );
  // }

  // Widget _buildContent() {
  //   return Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: Container(
  //       child: Column(      
  //         children: <Widget>[
  //           Container(
  //         child: StreamBuilder<List<City>>(
  //           stream: widget.database.cityCollectionStream(),
  //           builder: (context, snapshot) {
  //             // if(snapshot.hasError)
  //             //   return Text('Error: ${snapshot.error}');
  //             //   switch(snapshot.connectionState){
  //             //       case ConnectionState.none: return Text('Not connected');
  //             //       case ConnectionState.waiting: return Text('Still waiting');
  //             //       case ConnectionState.active: return Text('Connection active');
  //             //       case ConnectionState.done: return Text('Done');
  //             if (snapshot.hasData){
  //               print('Snapshot has data');
  //               final city = snapshot.data;
  //               final children = city.map((city)=> ListTile(title: Text(city.name))).toList();
  //               return ListView(
  //                 scrollDirection: Axis.vertical,
  //                 children: children,
  //                 shrinkWrap: true,
  //                 );            
  //             } 
  //             return CircularProgressIndicator();

          
  //           }     
  //         ),
  //       ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  //  void setCities() {
  //   widget.database.setCities(City(
  //     country: 'Australia',
  //     name: 'Melbourne',
  //     capital: false,
  //   ));
  // }

//  _updateState() {
//    setState(() {});
//  }
// }
