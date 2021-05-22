import 'package:flutter/material.dart';
import 'package:form_it/config/constants.dart';
import 'package:form_it/config/dependency.dart';
import 'package:form_it/pages/add_edit_tournament/view/tournament_info.dart';
import 'package:form_it/pages/add_edit_tournament/view/tournament_statistic.dart';
import 'package:form_it/pages/add_edit_tournament/view/tournament_teams.dart';
import 'package:form_it/pages/add_edit_tournament/widgets/tab_bar.dart';
import 'package:form_it/widgets/fade_end_listview.dart';
import 'package:form_it/widgets/icon_button_app_bar.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'package:repositories/repositories.dart';

import 'matches.dart';

typedef OnSaveCallback = Function(
    {String? name, List<Team>? teams, required int winPoints, required int drawPoints, required int lossPoints, required int encountersNum});

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

  GlobalKey<TournamentInfoState> _keyTournamentInfo = GlobalKey();
  static final GlobalKey<FormState> _formKeyInfo = GlobalKey<FormState>();

  @override
  void initState() {
    _tabController = new TabController(vsync: this, length: 4, initialIndex: widget.isEditing ? 2 : 0);
    _tabController.addListener(() {
      setState(() {});
    });
    this.teams = widget.isEditing ? widget.tournament!.teams : [];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? DarkColor : Theme.of(context).primaryColorLight,
      appBar: AppBar(
        elevation: 0.0,
        toolbarHeight: 50,
        shadowColor: Colors.transparent,
        backgroundColor: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? DarkColor : Theme.of(context).primaryColorLight,
        leading: IconButtonAppBar(
          icon: Icons.arrow_back_ios_rounded,
          onPressed: () => Navigator.pop(context, false),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              if (_formKeyInfo.currentState!.validate()) {
                _formKeyInfo.currentState!.save();
                widget.onSave(
                  name: _keyTournamentInfo.currentState!.name,
                  teams: teams,
                  winPoints: _keyTournamentInfo.currentState!.winPoints,
                  drawPoints: _keyTournamentInfo.currentState!.drawPoints,
                  lossPoints: _keyTournamentInfo.currentState!.lossPoints,
                  encountersNum: _keyTournamentInfo.currentState!.encountersNum,
                );
                // Navigator.pop(context);
              }
            },
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
      body: Stack(
        children: [
          TabBarView(
            physics: BouncingScrollPhysics(),
            controller: _tabController,
            children: [
              TournamentInfo(
                key: _keyTournamentInfo,
                formKey: _formKeyInfo,
              ),
              TournamentTeams(
                teams: this.teams,
                onAddTeamsCallback: onAddTeams,
              ),
              Matches(),
              TournamentStatistic(),
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
            color: Theme.of(context).accentColor,
            isTop: false,
          ),
          TabBarTournament(
            controller: _tabController,
          )
        ],
      ),
    );
  }
}
