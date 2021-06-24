import 'package:form_it/config/dependency.dart';
import 'package:form_it/config/constants.dart';

class ItemTournamentTeams extends StatelessWidget {
  final String text;
  final bool drawDivider;
  final Widget? secondaryWidget;

  const ItemTournamentTeams({Key? key, required this.text, this.drawDivider = false, this.secondaryWidget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: 50),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: drawDivider ? BoxDecoration(border: Border(top: borderSideDivider)) : null,
      child: Row(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: Theme.of(context).textTheme.bodyText2,
                  overflow: TextOverflow.ellipsis,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  // decoration: BoxDecoration(border: Border(right: borderSideDivider)),
                ),
                // Power(
                //   power: 12,
                // ),
              ],
            ),
          ),
          if (secondaryWidget != null) secondaryWidget!,
        ],
      ),
    );
  }
}
