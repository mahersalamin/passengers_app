

import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreService {
  // get collection
  final CollectionReference passengers =
      FirebaseFirestore.instance.collection('passengers');

  // add passengers
  Future addPassengers (date, option, passengersList){
    return passengers.add({
      'date':date,
      'option':option,
      'data':passengersList
    });
  }

  // get notes
  Stream<QuerySnapshot> getAll(){
    final allStream = passengers.orderBy('date',descending: true).snapshots();
    return allStream;
  }

  // delete

  Future<void> delete(String docId){
    return passengers.doc(docId).delete();
  }

}
