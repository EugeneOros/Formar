import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

abstract class SettingsState extends Equatable{}


class LogOutInitialState extends SettingsState{
  @override
  List<Object> get props => null;
}


class LogOutSuccessfulState extends SettingsState{
  @override
  List<Object> get props => null;
}

