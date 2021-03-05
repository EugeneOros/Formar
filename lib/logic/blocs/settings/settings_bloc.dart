import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:form_it/logic/blocs/authentication/authentication_bloc.dart';
import 'package:form_it/logic/blocs/authentication/authentication_state.dart';
import 'package:meta/meta.dart';
import 'package:form_it/logic/blocs/people/bloc.dart';
import 'package:people_repository/people_repository.dart';

import 'bloc.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository _settingsRepository;
  StreamSubscription _settingsSubscription;
  StreamSubscription _authenticationSubscription;
  final AuthenticationBloc _authenticationBloc;


  SettingsBloc(
      {@required SettingsRepository settingsRepository, @required AuthenticationBloc authenticationBloc})
      : assert(settingsRepository != null),
        _authenticationBloc = authenticationBloc,
        _settingsRepository = settingsRepository,
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
    }
  }

  Stream<SettingsState> _mapLoadSettingsToState() async* {
    _settingsSubscription?.cancel();
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