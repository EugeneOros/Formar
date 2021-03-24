import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/parser.dart';
import 'package:form_it/ui/shared/colors.dart';
import 'package:form_it/ui/widgets/player_indicator.dart';
import 'package:repositories/repositories.dart';
import 'package:form_it/ui/shared/dependency.dart';

class PersonItem extends StatelessWidget {
  final Function onDelete;
  final GestureTapCallback onEdit;
  final ValueChanged<bool> onSwitchChanged;
  final Player person;
  final SlidableController slidableController;

  PersonItem({
    Key? key,
    required this.onDelete,
    required this.onEdit,
    required this.onSwitchChanged,
    required this.person,
    required this.slidableController,
  }) : super(key: key);

  Color getLevelColor(Level? level) {
    switch (level) {
      case Level.beginner:
        return BeginnerColor;
      case Level.intermediate:
        return IntermediateColor;
      case Level.proficient:
        return ProficientColor;
      case Level.advanced:
        return AdvancedColor;
      case Level.expert:
        return ExpertColor;
      default:
        return Colors.black;
    }
  }

  String getLevelName(Level? level, BuildContext context) {
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
      default:
        return "";
    }
  }

  SvgPicture _getSexIcon(Sex sex) {
    switch (sex) {
      case Sex.man:
        return SvgPicture.asset("assets/man_empty.svg");
      case Sex.woman:
        return SvgPicture.asset("assets/woman_empty.svg");
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.maybeOf(context)!.size;

    return Column(
      children: [
        Slidable(
          controller: slidableController,
          key: Key(person.id!),
          child: GestureDetector(
            onTap: onEdit,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15),
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Theme.of(context).primaryColorLight, width: 1.5)),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          person.nickname,
                          style: Theme.of(context).textTheme.bodyText1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        width: size.width - 120,
                      ),
                      Row(
                        children: [
                          PlayerIndicator(player: person, size: 15),
                          SizedBox(width: 5),
                          Text(
                            getLevelName(person.level, context),
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Spacer(),
                  Container(
                    alignment: Alignment.bottomRight,
                    padding: EdgeInsets.zero,
                    child: Switch(
                      activeColor: Colors.black,
                      value: person.available,
                      onChanged: onSwitchChanged,
                    ),
                  )
                ],
              ),
            ),
          ),
          actionPane: SlidableDrawerActionPane(),
          dismissal: SlidableDismissal(
            child: SlidableDrawerDismissal(),
            onDismissed: (actionType) {
              onDelete();
            },
          ),
          secondaryActions: <Widget>[
            IconSlideAction(
              caption: AppLocalizations.of(context)!.edit,
              color: Theme.of(context).accentColor,
              icon: Icons.edit,
              onTap: onEdit,
            ),
            IconSlideAction(
              caption: AppLocalizations.of(context)!.delete,
              color: Colors.black,
              icon: Icons.delete,
              onTap: () => onDelete(),
            ),
          ],
        ),
      ],
    );
  }
}
