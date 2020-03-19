import 'package:flutter/material.dart';
import 'package:time_tracker_app/app/signin/email_sign_in_form_change_notifier.dart';

class EmailSignInPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Sign in',
          ),
          elevation: 4.0,
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Card(
            child: SingleChildScrollView(
                child: EmailSignInFormChangeNotifier.create(context)),
          ),
        ));
  }


}
