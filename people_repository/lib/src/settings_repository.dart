
import 'dart:async';

import 'package:people_repository/people_repository.dart';

import 'models/models.dart';

abstract class SettingsRepository {
  // Future<void> updateCounterTeamMember(int counterTeamMember);

  Stream<UserSettings> settings();

  Future<void> updateSettings(UserSettings person);
}
