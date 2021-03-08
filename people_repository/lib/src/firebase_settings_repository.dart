import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:people_repository/people_repository.dart';
import 'package:people_repository/src/settings_repository.dart';
import 'entities/entities.dart';
import 'models/user_settings.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseSettingsRepository implements SettingsRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Stream<UserSettings> settings() {
    User user = _auth.currentUser;
    DocumentReference settingsDoc =
        FirebaseFirestore.instance.collection("users").doc(user.uid);
    return settingsDoc.snapshots().map((snapshot) {
      return UserSettings.fromEntity(UserSettingsEntity.fromSnapshot(snapshot));
    });
  }

  @override
  Future<void> updateSettings(UserSettings userSettings) async {
    User user = _auth.currentUser;
    DocumentReference settingsDocument =
        FirebaseFirestore.instance.collection("users").doc(user.uid);
    return settingsDocument
        .update({"counterTeamMembers": userSettings.counterTeamMembers});
  }

  @override
  Future<void> createSettings() async {
    User user = _auth.currentUser;
    DocumentReference settingsDocument =
    FirebaseFirestore.instance.collection("users").doc(user.uid);
    settingsDocument.get().then((snapshot) {
      if(snapshot.data() == null || !snapshot.data().containsKey("counterTeamMembers")){
        settingsDocument.set({"counterTeamMembers": 6});
        print("yeyyeyeyyeyeyy");
      }
    });
  }
}

// @override
// Future<void> updateCounterTeamMember(int counterTeamMember) async {
//   User user = _auth.currentUser;
//   return FirebaseFirestore.instance
//       .collection("users")
//       .doc(user.uid)
//       .update({"counterTeamMembers": counterTeamMember});
// }
