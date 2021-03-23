import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserSettingsEntity extends Equatable {
  final String userId;
  final int? counterTeamMembers;

  UserSettingsEntity(this.userId, this.counterTeamMembers);

  Map<String, Object?> toJson() {
    return {
      'userId': userId,
      'counterTeamMembers': counterTeamMembers,
    };
  }

  static UserSettingsEntity fromJson(Map<String, Object> json) {
    return UserSettingsEntity(
      json['userId'] as String,
      json['counterTeamMembers'] as int?,
    );
  }

  static UserSettingsEntity fromSnapshot(DocumentSnapshot snap) {
    return UserSettingsEntity(
      snap.id,
      snap['counterTeamMembers'],
    );
  }

  @override
  List<Object?> get props => [userId, counterTeamMembers];

  @override
  String toString() {
    return 'UserSettingsEntity { userId: $userId, counterTeamMembers: $counterTeamMembers}';
  }
}