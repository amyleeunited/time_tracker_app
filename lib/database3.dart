import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:time_tracker_app/services/api_path.dart';

abstract class Database3 {
  Future<void> createJob(Job job);
  void jobsStream(Map<String, dynamic> data);
}

class FireStoreDatabase3 implements Database3 {
  FireStoreDatabase3({@required this.uid});

  final String uid;

  Future<void> setData({String path, Map<String, dynamic> data}) async {
    final reference = Firestore.instance.document(path);
    await reference.setData(data);
  }

  Future<void> createJob(Job job) => setData(
        path: APIPath.job(uid, 'job_abc'),
        data: job.toMap(),
      );


  Stream<List<T>> collectionStream<T>({String path, T builder(Map<String, dynamic> data)}){
    final reference = Firestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.documents.map((snapshot) => builder(snapshot.data)).toList());
  }

  void jobsStream(Map<String, dynamic> data) => collectionStream(
    path: APIPath.jobs(uid),
    builder: (data) => Job.fromMap(data),
  );
}

class Job {
  Job({@required this.name, @required this.ratePerHour});

  final String name;
  final int ratePerHour;

  factory Job.fromMap(Map<String, dynamic> data) {
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
      'RatePerHour': ratePerHour,
    };
  }
}
