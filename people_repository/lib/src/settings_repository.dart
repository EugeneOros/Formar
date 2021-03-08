
import 'dart:async';

import 'package:people_repository/people_repository.dart';

import 'models/models.dart';

abstract class SettingsRepository {

  Stream<UserSettings> settings();

  Future<void> updateSettings(UserSettings settings);

  Future<void> createSettings();
}
