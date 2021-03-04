import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:people_repository/people_repository.dart';

class UserSettingsEntity extends Equatable {
  final String userId;
  final int counterTeamMembers;

  UserSettingsEntity(this.userId, this.counterTeamMembers);

  Map<String, Object> toJson() {
    return {
      'counterTeamMembers': counterTeamMembers,
      'userId': userId,
    };
  }

  @override
  String toString() {
    return 'UserSettingsEntity { counterTeamMembers: $counterTeamMembers userId: $userId }';
  }

  static UserSettingsEntity fromJson(Map<String, Object> json) {
    return UserSettingsEntity(
      json['userId'] as String,
      json['counterTeamMembers'] as int,
    );
  }

  static UserSettingsEntity fromSnapshot(DocumentSnapshot snap) {
    return UserSettingsEntity(
      snap.id,
      snap['counterTeamMembers'],
    );
  }

  // Map<String, Object> toDocument() {
  //   return {
  //     'name': name,
  //     'capacity': counterTeamMembers,
  //     'membersNames': membersNames,
  //   };
  // }

  @override
  List<Object> get props => [userId, counterTeamMembers];
}