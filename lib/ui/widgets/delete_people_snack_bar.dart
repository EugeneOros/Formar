import 'package:flutter/material.dart';
import 'package:form_it/ui/shared/colors.dart';
import 'package:people_repository/people_repository.dart';
import 'package:form_it/ui/shared/dependency.dart';

class DeletePersonSnackBar extends SnackBar {
  DeletePersonSnackBar({
    Key? key,
    required Person player,
    required VoidCallback onUndo,
    required BuildContext context,
  }) : super(
          key: key,
          content: Text(
            AppLocalizations.of(context)!.deleted + " " + player.nickname!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          backgroundColor: Colors.black,
          duration: Duration(seconds: 3),
          action: SnackBarAction(
            label: AppLocalizations.of(context)!.undo,
            textColor: SecondaryColor,
            onPressed: onUndo,
          ),
        );
}
