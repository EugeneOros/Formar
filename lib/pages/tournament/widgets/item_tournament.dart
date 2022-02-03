import 'package:form_it/config/dependency.dart';
import 'package:form_it/config/constants.dart';
import 'package:form_it/config/helpers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_it/logic/blocs/teams/bloc.dart';
import 'package:form_it/logic/blocs/tournament/bloc.dart';
import 'package:form_it/pages/add_edit_tournament/view/add_edit_tournament_page.dart';
import 'package:repositories/repositories.dart';

class ItemTournament extends StatelessWidget {
  final Function onDelete;
  final Tournament tournament;
  final SlidableController? slidableController;
  final UserRepository userRepository;

  const ItemTournament({Key? key, required this.tournament, this.slidableController, required this.userRepository, required this.onDelete})
      : super(key: key);

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
                        List<Match>? matches,
                        required int winPoints,
                        int? drawPoints,
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
                            matches: matches)),
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
      // actionPane: SlidableDrawerActionPane(),
      // controller: slidableController,
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
                      surfaceIntensity: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? 0 : 0.3,
                      boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(15)),
                      lightSource: LightSource.topRight,
                      shadowDarkColor:
                          Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? DarkColorShadowDark : Colors.grey.withOpacity(0.7),
                      shadowLightColor:
                          Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? DarkColorShadowLight : Colors.white.withOpacity(0.7),
                      color: Theme.of(context).canvasColor),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? DarkColorAccent : Theme.of(context).primaryColor,
                          Provider.of<AppStateNotifier>(context, listen: false).isDarkMode
                              ? DarkColorAccent
                              : Theme.of(context).colorScheme.secondary,
                        ],
                      ),
                    ),
                    padding: EdgeInsets.only(left: 140, right: 25),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tournament.name,
                          style: Theme.of(context).textTheme.headline2,
                        ),
                        SizedBox(
                          height: 7,
                        ),
                        Text(
                          (AppLocalizations.of(context)!.leader +
                                  ": " +
                                  (tournament.teams.isEmpty
                                      ? AppLocalizations.of(context)!.unknown
                                      : Tournament.getLeaderList(
                                              matches: tournament.matches,
                                              teams: tournament.teams,
                                              pointsForWins: tournament.winPoints,
                                              pointsForDraw: tournament.drawPoints,
                                              pointsForLoss: tournament.lossPoints)[0]
                                          .team
                                          .name))
                              .replaceAll(' ', '\u00A0'),
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.subtitle2,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/league_icon.svg',
                        width: 60,
                      ),
                      Text(
                        AppLocalizations.of(context)!.roundRobin,
                        style: Theme.of(context).textTheme.subtitle2,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // secondaryActions: <Widget>[
      //   Container(
      //     margin: EdgeInsets.only(right: 15),
      //     alignment: Alignment.center,
      //     child: GestureDetector(
      //       onTap: () => onDelete(),
      //       child: Neumorphic(
      //         style: NeumorphicStyle(
      //             depth: 2,
      //             intensity: 1,
      //             shape: NeumorphicShape.concave,
      //             boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(15)),
      //             lightSource: LightSource.topLeft,
      //             shadowDarkColor:
      //                 Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? DarkColorShadowDark : Colors.grey.withOpacity(0.7),
      //             shadowLightColor:
      //                 Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? DarkColorShadowLight : Colors.white.withOpacity(0.7),
      //             color: Theme.of(context).primaryColor),
      //         child: Container(
      //           child:
      //               Icon(Icons.delete, color: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? LightPink : Colors.black, size: 20),
      //           width: 50,
      //           height: 50,
      //         ),
      //       ),
      //     ),
      //   )
      // ],
    );
  }
}
