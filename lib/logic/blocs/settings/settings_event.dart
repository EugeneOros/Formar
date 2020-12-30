import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class SettingsEvent extends Equatable{}


class LogOutButtonPressedEvent extends SettingsEvent{
  @override
  List<Object> get props => null;
}