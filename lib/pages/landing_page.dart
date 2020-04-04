import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_app/app/signin/sign_in_page.dart';
import 'package:time_tracker_app/home/jobs/jobs_page.dart';
import 'package:time_tracker_app/services/auth.dart';
import 'package:time_tracker_app/services/database.dart';

class LandingPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return StreamBuilder<User>(
      stream: auth.onAuthStateChanged,
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.active){
          User user = snapshot.data;
//          print('user');
          if(user == null) {
            return SignInPage.create(context);
          }
          return Provider<Database>(
              create: (_) => FirestoreDatabase(uid: user.uid),
              child: JobsPage());
        } else return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );

  }
}
