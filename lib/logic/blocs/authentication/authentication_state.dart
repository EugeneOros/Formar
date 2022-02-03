part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationState extends Equatable {
  const AuthenticationState();
  @override
  List<Object?> get props => [];
}

class AuthenticationStateInitialized extends AuthenticationState {}

class AuthenticationStateAuthenticated extends AuthenticationState {
  final User? user;

  const AuthenticationStateAuthenticated(this.user);

  @override
  List<Object?> get props => [user];

  @override
  String toString() => "email: ${user!.email}";
}

class AuthenticationStateUnauthenticated extends AuthenticationState {}