import 'package:form_it/config/dependency.dart';
import 'package:flutter_svg/svg.dart';

enum AppTab {players, teams, tournament, settings}

extension AppTabExtension on AppTab{

  String getName(context) {
    switch (this) {
      case AppTab.players:
        return AppLocalizations.of(context)!.players;
      case AppTab.teams:
        return AppLocalizations.of(context)!.teams;
      case AppTab.tournament:
        return AppLocalizations.of(context)!.tournament;
      case AppTab.settings:
        return AppLocalizations.of(context)!.settings;
    }
  }

  SvgPicture? getIcon(bool isActive) {
    switch (this) {
      case AppTab.players:
        return  SvgPicture.asset(isActive ? "assets/players_fill.svg" : "assets/players_empty.svg");
      case AppTab.teams:
        return SvgPicture.asset(isActive ? "assets/team_fill.svg" : "assets/team_empty.svg");
      case AppTab.tournament:
        return SvgPicture.asset(isActive ? "assets/tournament_fill.svg" : "assets/tournament_empty.svg");
      case AppTab.settings:
        return SvgPicture.asset(isActive ? "assets/settings_fill.svg" : "assets/settings_empty.svg");
    }
  }
}