import 'package:form_it/config/dependency.dart';
import 'package:form_it/pages/add_edit_tournament/widgets/counter_element.dart';
import 'package:form_it/pages/add_edit_tournament/widgets/item_tournament_info.dart';
import 'package:form_it/widgets/app_dialog.dart';
import 'package:form_it/widgets/emboss_container.dart';
import 'package:form_it/widgets/round_icon_button.dart';
import 'package:form_it/widgets/rounded_input_field.dart';
import 'package:repositories/repositories.dart';

typedef void OnMatchEmptyCheckCallback(Function newMatchesSchedule);

class TournamentInfo extends StatefulWidget {
  final Tournament? tournament;
  final GlobalKey<FormState> formKey;
  final OnMatchEmptyCheckCallback onMatchEmptyCheckCallback;

  const TournamentInfo({
    Key? key,
    this.tournament,
    required this.formKey,
    required this.onMatchEmptyCheckCallback,
  }) : super(key: key);

  @override
  TournamentInfoState createState() => TournamentInfoState();
}

class TournamentInfoState extends State<TournamentInfo> with AutomaticKeepAliveClientMixin {
  String? name;
  late int winPoints;
  late int drawPoints;
  late int lossPoints;
  late int encountersNum;

  @override
  void initState() {
    super.initState();
    if (widget.tournament == null) {
      winPoints = 2;
      drawPoints = 1;
      lossPoints = 0;
      encountersNum = 1;
    } else {
      name = widget.tournament!.name;
      winPoints = widget.tournament!.winPoints;
      drawPoints = widget.tournament!.drawPoints;
      lossPoints = widget.tournament!.lossPoints;
      encountersNum = widget.tournament!.encountersNum;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Neumorphic(
      style: NeumorphicStyle(
        depth: 0,
        surfaceIntensity: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? 0 : 0.25,
        color: Theme.of(context).primaryColorLight,
        boxShape: NeumorphicBoxShape.rect(),
        shape: NeumorphicShape.convex,
        lightSource: LightSource.topLeft,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomLeft,
            colors: [
              Theme.of(context).primaryColorLight,
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor,
              Theme.of(context).colorScheme.secondary,
            ],
          ),
        ),
        // color: Theme.of(context).primaryColorLight,
        child: Form(
          key: widget.formKey,
          child: ListView(
            children: [
              SizedBox(height: 90),
              RoundedInputField(
                name: AppLocalizations.of(context)!.name,
                hintText: AppLocalizations.of(context)!.enterNameOfTournament,
                radius: 15,
                initialValue: name,
                onSaved: (value) => name = value,
                validator: (val) {
                  return val!.trim().isEmpty ? AppLocalizations.of(context)!.enterSomeText : null;
                },
              ),
              EmbossContainer(
                name: AppLocalizations.of(context)!.points,
                padding: EdgeInsets.only(top: 25),
                child: Column(
                  children: [
                    ItemTournamentInfo(
                      text: AppLocalizations.of(context)!.pointsForWin,
                      secondaryWidget: CounterElement(
                        counter: winPoints,
                        onChange: (value) {
                          setState(() {
                            winPoints = value;
                          });
                        },
                      ),
                    ),
                    ItemTournamentInfo(
                      text: AppLocalizations.of(context)!.pointsForDraw,
                      secondaryWidget: CounterElement(
                        counter: drawPoints,
                        onChange: (value) {
                          setState(() {
                            drawPoints = value;
                          });
                        },
                      ),
                      drawDivider: true,
                    ),
                    ItemTournamentInfo(
                      text: AppLocalizations.of(context)!.pointsForLoss,
                      secondaryWidget: CounterElement(
                        counter: lossPoints,
                        onChange: (value) {
                          setState(() {
                            lossPoints = value;
                          });
                        },
                      ),
                      drawDivider: true,
                    )
                  ],
                ),
              ),
              EmbossContainer(
                name: AppLocalizations.of(context)!.other,
                padding: EdgeInsets.only(top: 25),
                child: Column(
                  children: [
                    ItemTournamentInfo(
                      text: AppLocalizations.of(context)!.numbersOfEncounters,
                      secondaryWidget: CounterElement(
                        counter: encountersNum,
                        isPositive: true,
                        onChange: (value) => widget.onMatchEmptyCheckCallback(
                          () => setState(() {
                            encountersNum = value;
                          }),
                        ),
                      ),
                    ),
                    // ItemTournamentInfo(
                    //   text: AppLocalizations.of(context)!.bonusPenaltyPoints,
                    //   drawDivider: true,
                    //   secondaryWidget: Container(
                    //       width: 90,
                    //       alignment: Alignment.center,
                    //       child: RoundIconButton(
                    //         icon: Icons.arrow_forward_ios_rounded,
                    //         onPressed: () {
                    //           showDialog(
                    //             context: context,
                    //             builder: (BuildContext context) {
                    //               return AppDialog(
                    //                 title: AppLocalizations.of(context)!.info,
                    //                 content: Container(
                    //                   padding: EdgeInsets.only(top: 0, left: 15, right: 15, bottom: 15),
                    //                   child: Column(
                    //                     mainAxisAlignment: MainAxisAlignment.start,
                    //                     crossAxisAlignment: CrossAxisAlignment.start,
                    //                     children: [
                    //                       Text(
                    //                         AppLocalizations.of(context)!.p + " - " + AppLocalizations.of(context)!.points,
                    //                         style: Theme.of(context).textTheme.bodyText2,
                    //                       ),
                    //                       Text(AppLocalizations.of(context)!.w + " - " + AppLocalizations.of(context)!.wins),
                    //                       Text(AppLocalizations.of(context)!.d + " - " + AppLocalizations.of(context)!.draws),
                    //                       Text(AppLocalizations.of(context)!.l + " - " + AppLocalizations.of(context)!.losses),
                    //                       Text(AppLocalizations.of(context)!.mp + " - " + AppLocalizations.of(context)!.matchesPlayed),
                    //                       Text(AppLocalizations.of(context)!.pd + " - " + AppLocalizations.of(context)!.pointsDifference),
                    //                       Text(AppLocalizations.of(context)!.sd + " - " + AppLocalizations.of(context)!.setsDifference),
                    //                       Text(AppLocalizations.of(context)!.ep + " - " + AppLocalizations.of(context)!.extraPoints),
                    //                     ],
                    //                   ),
                    //                 ),
                    //                 actionsHorizontal: [
                    //                   TextButton(
                    //                     child: Text(
                    //                       MaterialLocalizations.of(context).okButtonLabel,
                    //                       style: Theme.of(context).textTheme.button,
                    //                     ),
                    //                     onPressed: () {
                    //                       Navigator.of(context).pop();
                    //                     },
                    //                   ),
                    //                 ],
                    //               );
                    //             },
                    //           );
                    //         },
                    //       )),
                    // ),
                    ItemTournamentInfo(
                      text: AppLocalizations.of(context)!.aboutScheduling,
                      drawDivider: true,
                      secondaryWidget: Container(
                          width: 90,
                          alignment: Alignment.center,
                          child: RoundIconButton(
                            icon: Icons.arrow_forward_ios_rounded,
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AppDialog(
                                    title: AppLocalizations.of(context)!.roundRobin,
                                    content: Container(
                                      padding: EdgeInsets.only(top: 0, left: 15, right: 15, bottom: 15),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            AppLocalizations.of(context)!.whatIsRoundRobin,
                                            style: Theme.of(context).textTheme.bodyText2,
                                          ),
                                          //   Text(AppLocalizations.of(context)!.w + " - " + AppLocalizations.of(context)!.wins),
                                          //   Text(AppLocalizations.of(context)!.d + " - " + AppLocalizations.of(context)!.draws),
                                          //   Text(AppLocalizations.of(context)!.l + " - " + AppLocalizations.of(context)!.losses),
                                          //   Text(AppLocalizations.of(context)!.mp + " - " + AppLocalizations.of(context)!.matchesPlayed),
                                          //   Text(AppLocalizations.of(context)!.pd + " - " + AppLocalizations.of(context)!.pointsDifference),
                                          //   Text(AppLocalizations.of(context)!.sd + " - " + AppLocalizations.of(context)!.setsDifference),
                                          //   Text(AppLocalizations.of(context)!.ep + " - " + AppLocalizations.of(context)!.extraPoints),
                                        ],
                                      ),
                                    ),
                                    actionsHorizontal: [
                                      TextButton(
                                        child: Text(
                                          MaterialLocalizations.of(context).okButtonLabel,
                                          style: Theme.of(context).textTheme.button,
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          )),
                    ),
                    // ItemTournamentInfo(
                    //     text: "Ranking criteria",
                    //     drawDivider: true,
                    //     secondaryWidget: Container(
                    //         width: 90,
                    //         alignment: Alignment.center,
                    //         child: Text(
                    //           "Total",
                    //           style: Theme.of(context).textTheme.subtitle2,
                    //         ))),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
