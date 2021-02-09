import 'package:flutter/material.dart';
import 'package:form_it/ui/shared/colors.dart';
import 'package:people_repository/people_repository.dart';

class DeletePersonSnackBar extends SnackBar {
  DeletePersonSnackBar({
    Key key,
    @required Person todo,
    @required VoidCallback onUndo,
  }) : super(
          key: key,
          content: Text(
            'Deleted ${todo.task}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          backgroundColor: Colors.black,
          duration: Duration(seconds: 2),
          action: SnackBarAction(
            label: 'Undo',
            textColor: SecondaryColor,
            onPressed: onUndo,
          ),
        );
}
