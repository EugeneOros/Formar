part of 'settings_bloc.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final UserSettings? settings;

  const SettingsLoaded([this.settings]);

  @override
  List<Object?> get props => [settings];

  @override
  String toString() => 'SettingsLoaded { settings: $settings }';
}

class SettingsNotLoaded extends SettingsState {}