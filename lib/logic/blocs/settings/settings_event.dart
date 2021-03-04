import 'package:equatable/equatable.dart';
import 'package:people_repository/people_repository.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class LoadSettings extends SettingsEvent {}

class SettingsUpdated extends SettingsEvent {
  final UserSettings settings;

  const SettingsUpdated(this.settings);

  @override
  List<Object> get props => [settings];
}