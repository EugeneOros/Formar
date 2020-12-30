import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

abstract class SignUpState extends Equatable{}


class SignUpInitialState extends SignUpState{
  @override
  List<Object> get props => null;
}


class SignUpLoadingState extends SignUpState{
  @override
  List<Object> get props => null;
}


class SignUpSuccessfulState extends SignUpState{
  final User user;

  SignUpSuccessfulState({@required this.user});

  @override
  List<Object> get props => null;
}


class SignUpFailureState extends SignUpState{
  final massage;

  SignUpFailureState({@required this.massage});

  @override
  List<Object> get props => null;
}