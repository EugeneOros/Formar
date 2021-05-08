import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'package:form_it/config/constants.dart';

class ItemTournamentInfo extends StatelessWidget {
  final String text;
  final bool drawDivider;
  final Widget? secondaryWidget;

  const ItemTournamentInfo({Key? key, required this.text, this.drawDivider = false, this.secondaryWidget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: 50),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: drawDivider ? BoxDecoration(border: Border(top: borderSideDivider)) : null,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text,
                  style: Theme.of(context).textTheme.bodyText2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (secondaryWidget != null) secondaryWidget!,
        ],
      ),
    );
  }
}
