import 'package:form_it/config/dependency.dart';
import 'package:form_it/config/constants.dart';
import 'package:form_it/config/helpers.dart';
import 'package:form_it/pages/tournament_info/view/tournament_info.dart';
import 'package:form_it/pages/tournament_statistic/view/tournament_statistic.dart';
import 'package:form_it/pages/tournament_teams/view/tournament_teams.dart';
import 'package:form_it/pages/tournament_matches/view/tournament_matches.dart';
import 'package:form_it/pages/add_edit_tournament/widgets/widgets.dart';
import 'package:form_it/widgets/app_dialog.dart';
import 'package:form_it/widgets/fade_end_listview.dart';
import 'package:form_it/widgets/icon_button_app_bar.dart';
import 'package:repositories/repositories.dart';

final GlobalKey<FormState> _formKeyInfo = GlobalKey<FormState>();
GlobalKey<TournamentInfoState> _keyTournamentInfo = GlobalKey();

typedef OnSaveCallback = Function(
    {String? name,
    List<Team>? teams,
    List<Match>? matches,
    required int winPoints,
    int? drawPoints,
    required int lossPoints,
    required int encountersNum});

class AddEditTournamentPage extends StatefulWidget {
  final bool isEditing;
  final OnSaveCallback onSave;
  final Tournament? tournament;

  const AddEditTournamentPage({
    Key? key,
    required this.isEditing,
    required this.onSave,
    this.tournament,
  }) : super(key: key);

  @override
  _AddEditTournamentPageState createState() => _AddEditTournamentPageState();
}

class _AddEditTournamentPageState extends State<AddEditTournamentPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<Team> teams;
  late List<Match> matches;

  // GlobalKey<TournamentInfoState> _keyTournamentTeams = GlobalKey();

  @override
  void initState() {
    _tabController = new TabController(vsync: this, length: 4, initialIndex: widget.isEditing ? 2 : 0);
    _tabController.addListener(() {
      setState(() {
        FocusScope.of(context).requestFocus(new FocusNode()); //remove focus
        // WidgetsBinding.instance!.addPostFrameCallback((_) => nameController.clear());
      });
    });
    this.teams = widget.tournament != null ? widget.tournament!.teams : [];
    this.matches = widget.tournament != null ? widget.tournament!.matches : [];
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void onAddTeams(List<Team> teams) {
    setState(() {
      this.teams = teams;
    });
  }

  void onChangeMatches(List<Match> matches) {
    setState(() {
      this.matches = matches;
    });
  }

  void saveAndExit() {
    if (_formKeyInfo.currentState != null) {
      if (_formKeyInfo.currentState!.validate()) {
        _formKeyInfo.currentState!.save();
        widget.onSave(
          name: _keyTournamentInfo.currentState!.name,
          teams: teams,
          matches: matches,
          winPoints: _keyTournamentInfo.currentState!.winPoints,
          drawPoints: _keyTournamentInfo.currentState!.drawPoints,
          lossPoints: _keyTournamentInfo.currentState!.lossPoints,
          encountersNum: _keyTournamentInfo.currentState!.encountersNum,
        );
        Navigator.pop(context);
      } else {
        _tabController.index = 0;
      }
    } else {
      widget.onSave(
        name: widget.tournament != null ? widget.tournament!.name : "Tournament",
        teams: teams,
        matches: matches,
        winPoints: widget.tournament != null ? widget.tournament!.winPoints : 2,
        drawPoints: widget.tournament != null ? widget.tournament!.drawPoints : 1,
        lossPoints: widget.tournament != null ? widget.tournament!.lossPoints : 0,
        encountersNum: widget.tournament != null ? widget.tournament!.encountersNum : 1,
      );
      Navigator.of(context).pop(context);
    }
  }

  void onMatchEmptyCheck(Function onOk) {
    if (matches.isEmpty) {
      onOk();
    } else {
      showDialog<bool>(
          context: homeKey.currentContext!,
          builder: (context) {
            return AppDialog(
              title: AppLocalizations.of(context)!.matchesIsNotEmpty,
              actionsHorizontal: [
                TextButton(
                  onPressed: () {
                    onChangeMatches([]);
                    Navigator.of(context).pop(true);
                    onOk();
                  },
                  child: Text(
                    AppLocalizations.of(context)!.yes,
                    style: Theme.of(context).textTheme.button,
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    AppLocalizations.of(context)!.no,
                    style: Theme.of(context).textTheme.button,
                  ),
                ),
              ],
            );
          });
    }
  }

  Future<bool> onWillPop() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AppDialog(
          title: AppLocalizations.of(context)!.doYouWantToLeave,
          content: Container(
            padding: EdgeInsets.only(top: 0, left: 15, right: 15, bottom: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.changesYouMade,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
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
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                MaterialLocalizations.of(context).saveButtonLabel.toLowerCase().capitalize(),
                style: Theme.of(context).textTheme.button,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                saveAndExit();
              },
            ),
          ],
        );
      },
    );
    return false;
  }

  @override
  Widget build(BuildContext context) {
    TournamentInfo tournamentInfo = TournamentInfo(
      key: _keyTournamentInfo,
      formKey: _formKeyInfo,
      tournament: widget.tournament,
      onMatchEmptyCheckCallback: onMatchEmptyCheck,
    );
    tournamentInfo.createElement();
    tournamentInfo.createState();
    return WillPopScope(
      onWillPop: () => onWillPop(),
      child: Scaffold(
        backgroundColor: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? DarkColor : Theme.of(context).primaryColorLight,
        appBar: AppBar(
          elevation: 0.0,
          toolbarHeight: 50,
          shadowColor: Colors.transparent,
          backgroundColor: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? DarkColor : Theme.of(context).primaryColorLight,
          leading: IconButtonAppBar(
            icon: Icons.arrow_back_ios_rounded,
            onPressed: () => onWillPop(),
          ),
          actions: [
            GestureDetector(
              onTap: saveAndExit,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                alignment: Alignment.center,
                child: Text(
                  MaterialLocalizations.of(context).saveButtonLabel.toLowerCase().capitalize(),
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
            )
          ],
        ),
        body: Container(
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
          child: Stack(
            children: [
              TabBarView(
                physics: BouncingScrollPhysics(),
                controller: _tabController,
                children: [
                  tournamentInfo,
                  TournamentTeams(
                    teams: this.teams,
                    onAddTeamsCallback: onAddTeams,
                    onMatchEmptyCheckCallback: onMatchEmptyCheck,
                  ),
                  TournamentMatches(
                    tournament: widget.tournament,
                    teams: this.teams,
                    matches: this.matches,
                    formKeyInfo: _keyTournamentInfo,
                    onChangeMatchesCallback: onChangeMatches,
                  ),
                  TournamentStatistic(
                    matches: matches,
                    teams: this.teams,
                    formKeyInfo: _keyTournamentInfo,
                    tournament: widget.tournament,
                  ),
                ],
              ),
              FadeEndLIstView(
                height: 50,
                width: MediaQuery.of(context).size.width,
                color: Theme.of(context).primaryColorLight,
                isTop: true,
              ),
              FadeEndLIstView(
                height: 30,
                width: MediaQuery.of(context).size.width,
                color: Theme.of(context).colorScheme.secondary,
                isTop: false,
              ),
              TabBarTournament(
                controller: _tabController,
              )
            ],
          ),
        ),
      ),
    );
  }
}
