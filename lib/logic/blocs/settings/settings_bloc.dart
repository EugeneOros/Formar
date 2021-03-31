import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:form_it/logic/blocs/authentication/authentication_bloc.dart';
import 'package:form_it/logic/blocs/authentication/authentication_state.dart';
import 'package:repositories/repositories.dart';

import 'bloc.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository _settingsRepository;
  StreamSubscription? _settingsSubscription;
  StreamSubscription? _authenticationSubscription;
  int currentPlayerCount = 1;


  SettingsBloc(
      {required SettingsRepository settingsRepository, required AuthenticationBloc authenticationBloc})
      : _settingsRepository = settingsRepository,
        super(SettingsLoading()) {
    _authenticationSubscription = authenticationBloc.listen((state) {
      if (state is AuthenticationStateAuthenticated) {
        add(LoadSettings());
      }
    });
  }


  @override
  Stream<SettingsState> mapEventToState(SettingsEvent event) async* {
    if (event is LoadSettings) {
      yield* _mapLoadSettingsToState();
    }  else if (event is SettingsUpdated) {
      yield* _mapSettingsUpdateToState(event);
    } else if (event is UpdateSettings) {
      yield* _mapUpdateSettingsToState(event);
    } else if (event is SetCurrentPlayerCount){
      currentPlayerCount = event.currentPlayerCount;
    }
  }

  Stream<SettingsState> _mapLoadSettingsToState() async* {
    _settingsSubscription?.cancel();
    _settingsRepository.createSettings();
    _settingsSubscription = _settingsRepository.settings().listen(
          (settings) => add(SettingsUpdated(settings)),
    );
  }

  Stream<SettingsState> _mapSettingsUpdateToState(SettingsUpdated event) async* {
    yield SettingsLoaded(event.settings);
  }


  Stream<SettingsState> _mapUpdateSettingsToState(UpdateSettings event) async* {
    _settingsRepository.updateSettings(event.updatedSettings);
  }

  @override
  Future<void> close() {
    _settingsSubscription?.cancel();
    _authenticationSubscription?.cancel();
    return super.close();
  }
}