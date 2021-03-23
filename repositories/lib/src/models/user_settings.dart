import 'package:repositories/src/entities/entities.dart';

class UserSettings {
  final String? userId;
  final int? counterTeamMembers;

  UserSettings({this.userId, this.counterTeamMembers});

  UserSettings copyWith({int? counterTeamMember, String? userId}) {
    return UserSettings(
      userId: userId,
      counterTeamMembers: counterTeamMember,
    );
  }

  static UserSettings fromEntity(UserSettingsEntity entity) {
    return UserSettings(
      userId: entity.userId,
      counterTeamMembers: entity.counterTeamMembers,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserSettings &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          counterTeamMembers == other.counterTeamMembers;

  @override
  int get hashCode => counterTeamMembers.hashCode ^ userId.hashCode;

  @override
  String toString() {
    return 'UserSettings { userId: $userId, counterTeamMember: $counterTeamMembers }';
  }
}
