import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:form_it/logic/blocs/register/register_event.dart';
import 'package:form_it/logic/blocs/register/register_state.dart';
import 'package:form_it/logic/services/user_repository.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final UserRepository _userRepository;

  RegisterBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(RegisterState.empty());

  @override
  Stream<Transition<RegisterEvent, RegisterState>> transformEvents(
      Stream<RegisterEvent> regEvents, transitionFunction) {
    final debounceStream = regEvents.where((event) {
      return (event is RegisterEventEmailChanged ||
          event is RegisterEventPasswordChanged);
    }).debounceTime(Duration(milliseconds: 300));
    final nonDebounceStream = regEvents.where((loginEvent) {
      return (loginEvent is! RegisterEventEmailChanged &&
          loginEvent is! RegisterEventPasswordChanged);
    });
    return super.transformEvents(
        nonDebounceStream.mergeWith([debounceStream]), transitionFunction);
  }

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
    if (event is RegisterEventEmailChanged) {
      yield state.update(isEmailValid: Validators.isValidEmail(event.email));
    } else if (event is RegisterEventPasswordChanged) {
      yield state.update(isPasswordValid: Validators.isValidPassword(event.password));
    } else if (event is RegisterEventPressed) {
      yield* _mapSignUpWithCredentialsPressedToState(
        email: event.email,
        password: event.password,
      );
    }
  }
  Stream<RegisterState> _mapSignUpWithCredentialsPressedToState({
    String email,
    String password,
  }) async* {
    yield RegisterState.loading();
    try {
      await _userRepository.signUpWithEmailAndPassword(email, password);
      yield RegisterState.success();
    } catch (_) {
      yield RegisterState.failure();
    }
  }
}

class Validators {
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );
  static final RegExp _passwordRegExp = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$',
  );

  static isValidEmail(String email) {
    return email.length > 0;//return _emailRegExp.hasMatch(email);
  }

  static isValidPassword(String password) {
    return password.length >= 6;// return _passwordRegExp.hasMatch(password);
  }
}
