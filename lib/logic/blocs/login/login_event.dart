import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class LoginEvent extends Equatable {
  const LoginEvent();
  @override
  List<Object> get props => [];
}

class LoginEventEmailChanged extends LoginEvent {
  final String email;
  const LoginEventEmailChanged({required this.email});
  @override
  List<Object> get props => [email];
  @override
  String toString() => 'EmailChanged { email :$email }';
}


class LoginEventPasswordChanged extends LoginEvent {
  final String password;
  const LoginEventPasswordChanged({required this.password});
  @override
  List<Object> get props => [password];
  @override
  String toString() => 'PasswordChanged { password: $password }';
}


class LoginEventSubmitted extends LoginEvent {
  final String email;
  final String password;
  const LoginEventSubmitted({required this.email, required this.password});
  @override
  List<Object> get props => [email, password];
  @override
  String toString() {
    return 'Submitted { email: $email, password: $password }';
  }
}

class LoginEventWithGooglePressed extends LoginEvent {}

class LoginEventWithCredentialsPressed extends LoginEvent {
  final String email;
  final String password;
  const LoginEventWithCredentialsPressed({required this.email, required this.password});
  @override
  List<Object> get props => [email, password];
  @override
  String toString() {
    return 'LoginWithCredentialsPressed { email: $email, password: $password }';
  }
}

class ShowHidePassword extends LoginEvent {}
