import 'package:equatable/equatable.dart';

abstract class AuthenticationEvent extends Equatable{
  @override
  List<Object> get props => [];
}
class AppStartedEvent extends AuthenticationEvent{}
// class LoggedInEvent extends AuthenticationEvent{}
// class LoggedOut extends AuthenticationEvent{}

