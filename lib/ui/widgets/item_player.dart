import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:form_it/ui/shared/constants.dart';
import 'package:form_it/ui/widgets/player_indicator.dart';
import 'package:repositories/repositories.dart';
import 'package:form_it/ui/shared/dependency.dart';

class PlayerItem extends StatelessWidget {
  final Function onDelete;
  final GestureTapCallback onEdit;
  final ValueChanged<bool> onSwitchChanged;
  final GestureTapCallback onShowTeams;

  final Player player;
  final SlidableController? slidableController;
  final bool drawDivider;

  PlayerItem({
    Key? key,
    required this.onDelete,
    required this.onEdit,
    required this.onShowTeams,
    required this.onSwitchChanged,
    required this.player,
    this.slidableController,
    this.drawDivider = false,
  }) : super(key: key);

  String getLevelName(Level level, BuildContext context) {
    switch (level) {
      case Level.beginner:
        return AppLocalizations.of(context)!.beginner;
      case Level.intermediate:
        return AppLocalizations.of(context)!.intermediate;
      case Level.proficient:
        return AppLocalizations.of(context)!.proficient;
      case Level.advanced:
        return AppLocalizations.of(context)!.advanced;
      case Level.expert:
        return AppLocalizations.of(context)!.expert;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Slidable(
          controller: slidableController,
          actionPane: SlidableDrawerActionPane(),
          key: Key(player.id!),
          child: GestureDetector(
            onTap: onEdit,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              decoration: drawDivider
                  ? BoxDecoration(
                      border: Border(top: borderSideDivider),
                    )
                  : null,
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
                              getLevelName(player.level, context),
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
            // onDismissed: (_) => onDelete(),
            onWillDismiss: (actionType){
              return onDelete();
            },
          ),
          secondaryActions: <Widget>[
            SlideAction(
              child: Text(
                AppLocalizations.of(context)!.showTeams,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.caption,
              ),
              color: Theme.of(context).accentColor,
              onTap: () {
                onShowTeams();
                // showDialog(
                //     context: context,
                //     builder: (BuildContext context) {
                //       return AppDialog(
                //         title: "Teams names",
                //         content: ListView.builder(itemCount: ,itemBuilder: (context, index){
                //           return Text(index);
                //         }),
                //         actionsVertical: [
                //           TextButton(
                //               onPressed: () => Navigator.of(context).pop(),
                //               child: Text(
                //                 MaterialLocalizations.of(context).okButtonLabel,
                //                 style: Theme.of(context).textTheme.button,
                //               ))
                //         ],
                //       );
                //     });
              },
            ),
            SlideAction(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
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
        ),
      ],
    );
  }
}
