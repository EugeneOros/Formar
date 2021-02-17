import 'package:flutter/material.dart';
import 'package:form_it/ui/shared/colors.dart';
import 'package:people_repository/people_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DeletePersonSnackBar extends SnackBar {
  DeletePersonSnackBar({
    Key key,
    @required Person todo,
    @required VoidCallback onUndo,
  }) : super(
          key: key,
          content: Text(
            'Deleted ${todo.nickname}', //AppLocalizations.of().deleted +
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
