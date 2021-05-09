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

import 'matches.dart';

class AddEditTournamentPage extends StatefulWidget {
  @override
  _AddEditTournamentPageState createState() => _AddEditTournamentPageState();
}

class _AddEditTournamentPageState extends State<AddEditTournamentPage> with SingleTickerProviderStateMixin {

  late TabController _tabController;

  //
  @override
  void initState() {
    _tabController = new TabController(vsync: this, length: 4);
    _tabController.addListener(() {
      setState(() {
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        toolbarHeight: 50,
        shadowColor: Colors.transparent,
        backgroundColor: Theme.of(context).primaryColorLight,
        leading: IconButtonAppBar(
          icon: Icons.arrow_back_ios_rounded,
          onPressed: () => Navigator.pop(context, false),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              // if (_formKey.currentState!.validate()) {
              //   _formKey.currentState!.save();
              //   widget.onSave(_name, _players);
              //   Navigator.pop(context);
              // }
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
          TabBarView(controller: _tabController, children: [
            TournamentInfo(),
            TournamentTeams(),
            Matches(),
            TournamentStatistic(),
          ]),
          FadeEndLIstView(
            height: 50,
            width: MediaQuery.of(context).size.width,
            color: Theme.of(context).primaryColorLight,
            isTop: true,
          ),
          // FadeEndLIstView(
          //   height: 30,
          //   width: MediaQuery.of(context).size.width,
          //   color: Theme.of(context).accentColor,
          //   isTop: false,
          // ),
          TabBarTournament(
            controller: _tabController,
          )
        ],
      ),
    );
  }
}

// class TabBar extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }
