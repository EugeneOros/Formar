import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:form_it/ui/shared/colors.dart';
import 'package:people_repository/people_repository.dart';

import 'delete_people_snack_bar.dart';

class PersonItem extends StatelessWidget {
  final Function onDelete;
  final GestureTapCallback onEdit;
  final ValueChanged<bool> onSwitchChanged;
  final Person person;
  final SlidableController slidableController;

  PersonItem({
    Key key,
    @required this.onDelete,
    @required this.onEdit,
    @required this.onSwitchChanged,
    @required this.person,
    @required this.slidableController,
  }) : super(key: key);

  Color getLevelColor(Level level) {
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.maybeOf(context).size;
    return Column(
      children: [
        Slidable(
          controller: slidableController,
          key: Key(person.id),
          child: Container(
            margin: EdgeInsets.only(right: 20.0, left: 20.0),
            decoration: BoxDecoration(
              border:
                  Border(bottom: BorderSide(color: SecondaryColor, width: 1.5)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          person.nickname,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                          ),
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
                            person.level.toString().split('.').last,
                            style: TextStyle(
                              // fontFamily: 'Navicons',
                              fontSize: 15.0,
                              fontWeight: FontWeight.w300,
                              color:
                                  Colors.black, //getLevelColor(person.level),
                            ),
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
              caption: "Edit",
              color: SecondaryColor,
              icon: Icons.edit,
              onTap: onEdit,
            ),
            IconSlideAction(
              caption: "Delete",
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
