import 'package:people_repository/src/entities/entities.dart';

class UserSettings {
  final int counterTeamMembers;
  final String userId;

  UserSettings({this.userId, this.counterTeamMembers});

  UserSettings copyWith({int counterTeamMember, String userId}) {
    return UserSettings(
      counterTeamMembers: counterTeamMember,
      userId: userId,
    );
  }

  @override
  int get hashCode => counterTeamMembers.hashCode ^ userId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is UserSettings &&
              runtimeType == other.runtimeType &&
              userId == other.userId &&
              counterTeamMembers == other.counterTeamMembers;

  static UserSettings fromEntity(UserSettingsEntity entity) {
    return UserSettings(
      userId: entity.userId,
      counterTeamMembers: entity.counterTeamMembers,
    );
  }

  @override
  String toString() {
    return 'Settings { userId: $userId, counterTeamMember: $counterTeamMembers';
  }
}
