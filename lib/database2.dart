import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:time_tracker_app/services/api_path.dart';

abstract class Database2 {
}

class FireStoreDatabase2 implements Database2 {

  FireStoreDatabase2({@required this.uid}) : assert(uid != null);
  final String uid;

  Future<void> createJob(Job job) => setData(
      path: APIPath.job(uid, 'job_abc'),
      data: job.toMap(),
    );


  Future<void> setData({String path, Map<String, dynamic> data}) async {
    final reference = Firestore.instance.document(path);
    await reference.setData(data);
  }

  Future<Stream<List<T>>> collectionStream<T>(
      {@required String path,
       @required T builder(Map<String, dynamic> data)
      }) async {
    final reference = Firestore.instance.collection(path);
    final snapshot = reference.snapshots();
    return snapshot.map((snapshot) =>snapshot.documents.map((snapshot) => builder(snapshot.data)).toList());
  }

  Future<Stream<List<Job>>> jobStream() => collectionStream(
      path: APIPath.jobs(uid),
      builder: (data) => Job.fromMap(data));

}

class Job {

  Job({this.ratePerHour, this.name});

  final String name;
  final int ratePerHour;

  factory Job.fromMap(Map<String, dynamic> data){
    if(data == null){
      return null;
    }
    final name = data['name'];
    final ratePerHour = data['ratePerHour'];
    return Job(
      name: name,
      ratePerHour: ratePerHour,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Name': name,
      'RatePerHour': ratePerHour
    };
  }
}