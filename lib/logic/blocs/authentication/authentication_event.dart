import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

// abstract class AuthenticationEvent extends Equatable{
//   @override
//   List<Object> get props => [];
// }
// class AppStartedEvent extends AuthenticationEvent{}
// class LoggedInEvent extends AuthenticationEvent{}
// class LoggedOut extends AuthenticationEvent{}

@immutable
abstract class AuthenticationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AppStarted extends AuthenticationEvent {}

class LoggedIn extends AuthenticationEvent {}

class LoggedOut extends AuthenticationEvent {}