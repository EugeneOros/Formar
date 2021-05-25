import 'package:form_it/config/dependency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_it/config/constants.dart';
import 'package:form_it/logic/blocs/teams/bloc.dart';
import 'package:form_it/logic/blocs/tournament/bloc.dart';
import 'package:form_it/pages/add_edit_tournament/view/add_edit_tournament_page.dart';
import 'package:repositories/repositories.dart';

class ItemTournament extends StatelessWidget {
  final Tournament tournament;
  final SlidableController? slidableController;
  final UserRepository userRepository;

  const ItemTournament({Key? key, required this.tournament, this.slidableController, required this.userRepository}) : super(key: key);

  void _onEdit() {
    Navigator.of(homeKey.currentContext!).push(getPageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => BlocBuilder<TeamsBloc, TeamsState>(
              builder: (context, state) {
                List<Team> teams = [];
                if (state is TeamsLoaded) {
                  teams = state.teams;
                }
                return Provider<List<Team>>.value(
                  value: teams,
                  child: AddEditTournamentPage(
                    onSave: (
                        {String? name,
                        List<Team>? teams,
                        required int winPoints,
                        required int drawPoints,
                        required int lossPoints,
                        required int encountersNum}) {
                      BlocProvider.of<TournamentsBloc>(context).add(
                        UpdateTournament(tournament.copyWith(
                          ownerId: userRepository.getUser()!.uid,
                          name: name!,
                          teams: teams,
                          winPoints: winPoints,
                          drawPoints: drawPoints,
                          lossPoints: lossPoints,
                          encountersNum: encountersNum,
                        )),
                      );
                    },
                    isEditing: true,
                    tournament: tournament,
                  ),
                );
              },
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      controller: slidableController,
      key: Key(tournament.id!),
      child: GestureDetector(
        onTap: _onEdit,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                width: MediaQuery.of(context).size.width,
                height: 70,
                child: Neumorphic(
                  style: NeumorphicStyle(
                      depth: 2,
                      intensity: 1,
                      shape: NeumorphicShape.concave,
                      boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(15)),
                      lightSource: LightSource.topLeft,
                      shadowDarkColorEmboss:
                          Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? DarkColorShadowDark : Colors.grey.withOpacity(0.7),
                      shadowLightColorEmboss:
                          Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? DarkColorShadowLight : Colors.white.withOpacity(0.7),
                      color: Theme.of(context).primaryColor),
                  child: Container(
                    padding: EdgeInsets.only(left: 140),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tournament.name,
                          style: Theme.of(context).textTheme.headline2,
                        ),
                        Text(
                          "Leader: " + (tournament.teams.isEmpty ? "Unknown" : tournament.teams[0].name),
                          style: Theme.of(context).textTheme.bodyText2,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                left: 0,
                top: 0,
                child: Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(left: 30),
                  child: SvgPicture.asset(
                    'assets/league_icon.svg',
                    width: 100,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      secondaryActions: <Widget>[
        Container(
          margin: EdgeInsets.all(17),
          child: Neumorphic(
            style: NeumorphicStyle(
                depth: 2,
                intensity: 1,
                shape: NeumorphicShape.concave,
                boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(15)),
                lightSource: LightSource.topLeft,
                shadowDarkColorEmboss:
                    Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? DarkColorShadowDark : Colors.grey.withOpacity(0.7),
                shadowLightColorEmboss:
                    Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? DarkColorShadowLight : Colors.white.withOpacity(0.7),
                color: Theme.of(context).primaryColor),
            child: Container(
              // height: 30,
              // width:  30,
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.delete, color: Colors.black, size: 20),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
