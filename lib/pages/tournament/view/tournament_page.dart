import 'package:form_it/config/dependency.dart';

// import 'package:form_it/pages/tournament_tab/widgets/widgets.dart';

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
              Theme.of(context).primaryColorLight,
              // Theme.of(context).accentColor,
              Theme.of(context).primaryColorLight,
            ],
          ),
        ),
        child: Text(
          AppLocalizations.of(context)!.notAvailable,
          style: Theme.of(context).textTheme.headline1,
        ));
  }
}
