import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:time_tracker_app/temp/city.dart';

class FirestoreServiceTest{

  FirestoreServiceTest._();

  static final instance = FirestoreServiceTest._();

  Future<void> getDocument() async{
    final path = 'cities';
    final reference = Firestore.instance.collection(path);
    await reference.getDocuments().then((snapshot){
      if(snapshot != null){
        snapshot.documents.forEach((doc) => print(doc.data));
      } else{
        print('Doc does not exist');
      }
    });

//    final snapshots = reference.snapshots();
//    snapshots.listen((snapshot) => print(snapshot.documents));
  }

  Stream<List<City>> cityCollectionStream() {
    final path = 'cities';
    final reference = Firestore.instance.collection(path);
    return reference.snapshots().map((snapshot) =>
        snapshot.documents.map((doc) => City.fromMap(doc.data)).toList());
  }

  Future<void> getSnapshot() async{
    final db = Firestore.instance;
    final path = 'cities';
    final reference = db.collection(path);
    await reference.where('Country', isEqualTo:'Australia').snapshots().forEach((snapshot) =>
        snapshot.documents.forEach((doc)=> print(doc.data['Name'])));
  }

  Future<void> setCities (City city) async{
    final db = Firestore.instance;
    final path = 'cities/Melbourne';
    await db.document(path).setData(city.toMap()).then((data) =>print('Cities added'));
//    await db.collection(path).add(city.toMap());
  }

  Future<void> upDateDocs() async{
    final db = Firestore.instance;
    final path = 'cities/Sydney';
    await db.document(path).updateData({
      'Country': 'Australia',
    }).then((data) => print('Success'));
  }

  Future<void> deleteDoc() async{
    final db = Firestore.instance;
    final path = '/country/Malaysia/state/Selangor/city/WUK9XTNTGTOTDEejIYrP';
    await db.document(path).delete().then((data) => print('Document deleted'));
  }
}