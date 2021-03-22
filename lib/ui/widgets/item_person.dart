import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:form_it/ui/shared/colors.dart';
import 'package:people_repository/people_repository.dart';
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
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: Theme.of(context).primaryColorLight , width: 1.5)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
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
                            Container(
                              margin: EdgeInsets.only(
                                  right: 5.0, left: 1.0, bottom: 2.0),
                              alignment: Alignment.topCenter,
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: getLevelColor(person.level),
                                shape: BoxShape.circle,
                              ),
                            ),
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
