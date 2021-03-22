import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class RegisterEvent extends Equatable {
  const RegisterEvent();
  @override
  List<Object> get props => [];
}

class RegisterEventEmailChanged extends RegisterEvent {
  final String email;
  RegisterEventEmailChanged({required this.email});
  @override
  List<Object> get props => [email];
  @override
  String toString() => 'EmailChanged { email :$email }';
}

class RegisterEventPasswordChanged extends RegisterEvent {
  final String password;
  RegisterEventPasswordChanged({required this.password});
  @override
  List<Object> get props => [password];
  @override
  String toString() => 'PasswordChanged { password: $password }';
}

class RegisterEventPressed extends RegisterEvent {
  final String email;
  final String password;
  RegisterEventPressed({required this.email, required this.password});
  @override
  List<Object> get props => [email, password];
  @override
  String toString() {
    return 'Submitted { email: $email, password: $password }';
  }
}

class ShowHidePassword extends RegisterEvent {}