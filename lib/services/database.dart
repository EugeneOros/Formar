import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  CollectionReference currentPlayersCollection;

  DatabaseService({this.uid});

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection("users");

  Future createUserData(String name) async {
    currentPlayersCollection = FirebaseFirestore.instance.collection("users").doc(uid).collection("players");
    currentPlayersCollection.doc("1").set({"isPlaying" : true});
    return await usersCollection.doc(uid).set({
      "name": name,
    });
  }
}
