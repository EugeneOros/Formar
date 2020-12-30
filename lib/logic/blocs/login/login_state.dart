import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

abstract class LoginState extends Equatable{}


class LoginInitialState extends LoginState{
  @override
  List<Object> get props => null;
}


class LoginLoadingState extends LoginState{
  @override
  List<Object> get props => null;
}


class LoginSuccessfulState extends LoginState{
  final User user;

  LoginSuccessfulState({@required this.user});

  @override
  List<Object> get props => null;
}


class LoginFailureState extends LoginState{
  final massage;

  LoginFailureState({@required this.massage});

  @override
  List<Object> get props => null;
}