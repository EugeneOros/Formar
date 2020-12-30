import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_it/logic/blocs/authentication/authentication_event.dart';
import 'package:form_it/logic/blocs/authentication/authentication_state.dart';
import 'package:form_it/logic/services/auth.dart';
import 'dart:async';
import 'package:meta/meta.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthService _authService;

  AuthenticationBloc({@required AuthService authService})
      : assert(AuthService != null),
        _authService = authService,
        super(AuthInitialState());

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async*{
    if(event is AppStartedEvent){
      try {
        if(await _authService.isSignedIn()){
          var user = await _authService.currentUser();
          yield AuthenticatedState(user: user);
        }else{
          yield UnauthenticatedState();
        }
      } catch (e) {
        yield UnauthenticatedState();
      }
    }

  }

  // Stream<AuthenticationState> _mapLoggedInToState() async* {
  //   // yield Authenticated(await _authService.getUser());
  // }
  //
  // Stream<AuthenticationState> _mapLoggedOutToState() async* {
  //   yield UnauthenticatedState();
  //   _authService.signOut();
  // }
  //
  // Stream<AuthenticationState>  _mapAppStartedToState() async* {
  //   yield UnauthenticatedState();
  //   _authService.signOut();
  // }
}
