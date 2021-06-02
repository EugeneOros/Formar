import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:form_it/logic/models/validators.dart';
import 'package:repositories/repositories.dart';
import 'package:rxdart/rxdart.dart';

import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  UserRepository _userRepository;
  bool isHiddenPassword = true;

  LoginBloc({
    required UserRepository userRepository,
  })  : _userRepository = userRepository,
        super(LoginState.empty());

  @override
  Stream<Transition<LoginEvent, LoginState>> transformEvents(Stream<LoginEvent> loginEvents, transitionFunction) {
    final debounceStream = loginEvents.where((loginEvent) {
      return (loginEvent is LoginEventEmailChanged || loginEvent is LoginEventPasswordChanged);
    }).debounceTime(Duration(milliseconds: 300));
    final nonDebounceStream = loginEvents.where((loginEvent) {
      return (loginEvent is! LoginEventEmailChanged && loginEvent is! LoginEventPasswordChanged);
    });
    return super.transformEvents(nonDebounceStream.mergeWith([debounceStream]), transitionFunction);
  }

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    final LoginState currentState = state;
    if (event is LoginEventEmailChanged) {
      yield currentState.update(isEmailValid: Validators.isValidEmail(event.email));
    } else if (event is LoginEventPasswordChanged) {
      yield currentState.update(isPasswordValid: Validators.isValidPassword(event.password));
    } else if (event is LoginEventWithGooglePressed) {
      yield* _mapLoginWithGooglePressedToState();
    } else if (event is LoginEventWithCredentialsPressed) {
      yield* _mapLoginWithCredentialsPressedToState(
        email: event.email,
        password: event.password,
      );
    } else if (event is LoginEventShowHidePassword) {
      isHiddenPassword = !isHiddenPassword;
    }
  }

  Stream<LoginState> _mapLoginWithGooglePressedToState() async* {
    try {
      await _userRepository.signInWithGoogle();
      yield LoginState.success();
    } catch (_) {
      yield LoginState.failure();
    }
  }

  Stream<LoginState> _mapLoginWithCredentialsPressedToState({
    required String email,
    required String password,
  }) async* {
    yield LoginState.loading();
    try {
      await _userRepository.signInWithEmailAndPassword(email, password);
      yield LoginState.success();
    } catch (_) {
      yield LoginState.failure();
    }
  }
}
