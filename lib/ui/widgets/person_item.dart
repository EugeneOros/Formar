import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:form_it/ui/shared/colors.dart';
import 'package:people_repository/people_repository.dart';

class PersonItem extends StatelessWidget {
  final DismissDirectionCallback onDismissed;
  final GestureTapCallback onTap;
  final ValueChanged<bool> onCheckboxChanged;
  final Person todo;

  PersonItem({
    Key key,
    @required this.onDismissed,
    @required this.onTap,
    @required this.onCheckboxChanged,
    @required this.todo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Dismissible(
          key: Key('__todo_item_${todo.id}'),
          onDismissed: onDismissed,
          child: Container(
            margin: EdgeInsets.only(right: 20.0, left: 20.0),
            decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: SecondaryColor, width: 1.5)),
            ),
            child: ListTile(
              onTap: onTap,
              leading: Checkbox(
                value: todo.complete,
                onChanged: onCheckboxChanged,
              ),
              title: Hero(
                tag: '${todo.id}__heroTag',
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    todo.task,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              ),
              subtitle: todo.note.isNotEmpty
                  ? Text(
                      todo.note,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.subtitle1,
                    )
                  : null,
            ),
          ),
          direction: DismissDirection.endToStart,
          //DismissDirection.startToEnd
          background: Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 20.0),
            color: Colors.black,
            child: Icon(Icons.delete, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
