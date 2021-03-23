
import 'dart:async';

import 'package:repositories/repositories.dart';

import 'models/models.dart';

abstract class SettingsRepository {

  Stream<UserSettings> settings();

  Future<void> updateSettings(UserSettings settings);

  Future<void> createSettings();
}
