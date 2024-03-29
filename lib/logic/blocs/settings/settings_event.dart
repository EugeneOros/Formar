part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class LoadSettings extends SettingsEvent {}

class UpdateSettings extends SettingsEvent {
  final UserSettings updatedSettings;

  const UpdateSettings(this.updatedSettings);

  @override
  List<Object> get props => [updatedSettings];

  @override
  String toString() => 'UpdateSettings { updatedSettings: $updatedSettings }';
}

class SettingsUpdated extends SettingsEvent {
  final UserSettings settings;

  const SettingsUpdated(this.settings);

  @override
  List<Object> get props => [settings];
}

class SetCurrentPlayerCount extends SettingsEvent {
  final currentPlayerCount;

  const SetCurrentPlayerCount(this.currentPlayerCount);
}
