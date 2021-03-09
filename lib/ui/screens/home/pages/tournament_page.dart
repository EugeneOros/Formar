import 'package:flutter/material.dart';
import 'package:form_it/ui/shared/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TournamentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
        alignment: Alignment.center,
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).accentColor,
              Theme.of(context).primaryColor,
            ],
          ),
        ),
        child: Text(
          AppLocalizations.of(context).notAvailable,
          style: Theme.of(context).textTheme.headline1,
        ));
  }
}
