import 'package:equatable/equatable.dart';
// import 'package:form_it/logic/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

abstract class AuthenticationState extends Equatable{
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthInitialState extends AuthenticationState {}

class AuthenticatedState extends AuthenticationState {
  final User user;

  const AuthenticatedState({@required this.user});

  @override
  List<Object> get props => [];

}

class UnauthenticatedState extends AuthenticationState {}