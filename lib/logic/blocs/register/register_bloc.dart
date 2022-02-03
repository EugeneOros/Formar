import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_it/logic/models/validators.dart';
import 'package:meta/meta.dart';
import 'package:repositories/repositories.dart';
import 'package:rxdart/rxdart.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final UserRepository _userRepository;
  bool isHiddenPassword = true;

  RegisterBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(RegisterState.empty());

  @override
  Stream<Transition<RegisterEvent, RegisterState>> transformEvents(Stream<RegisterEvent> regEvents, transitionFunction) {
    final debounceStream = regEvents.where((event) {
      return (event is RegisterEventEmailChanged || event is RegisterEventPasswordChanged);
    }).debounceTime(Duration(milliseconds: 300));
    final nonDebounceStream = regEvents.where((loginEvent) {
      return (loginEvent is! RegisterEventEmailChanged && loginEvent is! RegisterEventPasswordChanged);
    });
    return super.transformEvents(nonDebounceStream.mergeWith([debounceStream]), transitionFunction);
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
    } else if (event is RegisterEventShowHidePassword) {
      isHiddenPassword = !isHiddenPassword;
    }
  }

  Stream<RegisterState> _mapSignUpWithCredentialsPressedToState({
    required String email,
    required String password,
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
