import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:repositories/repositories.dart';
import 'entities/entities.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebasePlayersRepository implements PlayersRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<CollectionReference> getPlayerCollection() async {
    User user = _auth.currentUser!;
    return FirebaseFirestore.instance.collection(user.uid.toString());
  }

  @override
  Future<DocumentReference> addNewPlayer(Player player) async {
    User user = _auth.currentUser!;
    CollectionReference playersCollection = FirebaseFirestore.instance.collection("users").doc(user.uid).collection("peoples");
    return playersCollection.add(player.toEntity().toDocument());
  }

  @override
  Future<void> deletePlayer(Player player) async {
    User user = _auth.currentUser!;
    CollectionReference playersCollection = FirebaseFirestore.instance.collection("users").doc(user.uid).collection("peoples");
    return playersCollection.doc(player.id).delete();
  }

  @override
  Stream<List<Player>> players() {
    User user = _auth.currentUser!;
    CollectionReference playersCollection = FirebaseFirestore.instance.collection("users").doc(user.uid).collection("peoples");
    return playersCollection.snapshots().map((snapshot) {
      List<Player> players = snapshot.docs.map((doc) => Player.fromEntity(PlayerEntity.fromSnapshot(doc))).toList();
      players.sort((p1, p2) => p1.compareTo(p1.nickname.toUpperCase(), p2.nickname.toUpperCase()));
      return players;
    });
  }

  Future<List<Player>> currentPlayersList() async {
    User user = _auth.currentUser!;
    CollectionReference playersCollection = FirebaseFirestore.instance.collection("users").doc(user.uid).collection("peoples");
    List<Player> players;
    QuerySnapshot querySnapshot = await playersCollection.get();
    players = querySnapshot.docs.map((doc) => Player.fromEntity(PlayerEntity.fromSnapshot(doc))).toList();
    return players;
  }

  @override
  Future<void> updatePlayer(Player player) {
    User user = _auth.currentUser!;
    CollectionReference playersCollection = FirebaseFirestore.instance.collection("users").doc(user.uid).collection("peoples");
    return playersCollection.doc(player.id).update(player.toEntity().toDocument());
  }

  Future getPlayer(String playerID) async {
    List<Player> players = await currentPlayersList();
    for (Player p in players) {
      if (p.id == playerID) {
        return p;
      }
    }
    return null;
  }
}
