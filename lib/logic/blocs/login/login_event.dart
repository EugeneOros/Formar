import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class LoginEvent extends Equatable{}


class LoginButtonPressedEvent extends LoginEvent{
  final String email, password;

  LoginButtonPressedEvent({@required this.email, @required this.password});

  @override
  List<Object> get props => null;
}