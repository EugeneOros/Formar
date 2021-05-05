import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_it/config/dependency.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:form_it/config/constants.dart';
import 'package:form_it/logic/blocs/people/bloc.dart';
import 'package:form_it/pages/add_edit_player/view/add_edit_player_page.dart';
import 'package:form_it/pages/players/widgets/player_indicator.dart';
import 'package:form_it/widgets/app_dialog.dart';
import 'package:repositories/repositories.dart';

class PlayerItem extends StatelessWidget {
  final Function onDelete;
  final ValueChanged<bool> onSwitchChanged;
  final List<Team> teams;

  final Player player;
  final SlidableController? slidableController;
  final bool drawDivider;

  PlayerItem({
    Key? key,
    required this.onDelete,
    required this.onSwitchChanged,
    required this.player,
    required this.teams,
    this.slidableController,
    this.drawDivider = false,
  }) : super(key: key);

  String _getLevelName(Level level) {
    switch (level) {
      case Level.beginner:
        return AppLocalizations.of(homeKey.currentContext!)!.beginner;
      case Level.intermediate:
        return AppLocalizations.of(homeKey.currentContext!)!.intermediate;
      case Level.proficient:
        return AppLocalizations.of(homeKey.currentContext!)!.proficient;
      case Level.advanced:
        return AppLocalizations.of(homeKey.currentContext!)!.advanced;
      case Level.expert:
        return AppLocalizations.of(homeKey.currentContext!)!.expert;
    }
  }

  void _onEdit() {
    Navigator.of(homeKey.currentContext!).push(
      MaterialPageRoute(
        builder: (context) {
          return AddEditPlayerScreen(
            onSave: (nickname, level, sex) {
              BlocProvider.of<PeopleBloc>(context).add(
                UpdatePerson(
                  player.copyWith(nickname: nickname, level: level, sex: sex),
                ),
              );
            },
            isEditing: true,
            person: player,
          );
        },
      ),
    );
  }

  void _onShowTeams() {
    showDialog(
      context: homeKey.currentContext!,
      builder: (BuildContext context) {
        return AppDialog(
          title: teams.length >= 1 ? AppLocalizations.of(context)!.teamsNames : AppLocalizations.of(context)!.noTeam,
          content: teams.length >= 1
              ? Container(
                  constraints: BoxConstraints(minWidth: 50, maxWidth: 350),
                  decoration: BoxDecoration(
                    border: Border(top: borderSideDivider),
                  ),
                  width: MediaQuery.of(context).size.width / 1.7,
                  height: MediaQuery.of(context).size.height / 6,
                  child: ListView(
                    shrinkWrap: true,
                    children: teams.map((e) {
                      return Container(
                        margin: EdgeInsets.zero,
                        padding: EdgeInsets.zero,
                        height: 37,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          alignment: Alignment.center,
                          child: Text(
                            e.name,
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                )
              : Container(),
          actionsVertical: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  MaterialLocalizations.of(context).okButtonLabel,
                  style: Theme.of(context).textTheme.button,
                ))
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      controller: slidableController,
      actionPane: SlidableDrawerActionPane(),
      key: Key(player.id!),
      child: GestureDetector(
        onTap: _onEdit,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          margin: EdgeInsets.symmetric(horizontal: 20.0),
          decoration: drawDivider ? BoxDecoration(border: Border(top: borderSideDivider)) : null,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      player.nickname,
                      style: Theme.of(context).textTheme.bodyText1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        PlayerIndicator(player: player, size: 15),
                        SizedBox(width: 5),
                        Text(
                          _getLevelName(player.level),
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Transform.scale(
                scale: 0.8,
                child: CupertinoSwitch(
                  activeColor: Colors.black,
                  value: player.available,
                  onChanged: onSwitchChanged,
                ),
              )
            ],
          ),
        ),
      ),
      dismissal: SlidableDismissal(
        child: SlidableDrawerDismissal(),
        onWillDismiss: (actionType) => onDelete(),
      ),
      secondaryActions: <Widget>[
        SlideAction(
          child: Text(
            AppLocalizations.of(context)!.showTeams,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.caption,
          ),
          color: Theme.of(context).accentColor,
          onTap: _onShowTeams,
        ),
        SlideAction(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.delete, color: Colors.white),
              Text(
                MaterialLocalizations.of(context).deleteButtonTooltip,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.caption!.copyWith(color: Colors.white),
              ),
            ],
          ),
          color: Colors.black,
          onTap: () => onDelete(),
        ),
      ],
    );
  }
}
