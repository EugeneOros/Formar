import 'package:form_it/config/dependency.dart';
import 'package:form_it/config/constants.dart';

class ItemTournamentStatistic extends StatelessWidget {
  final String text;
  final bool drawDivider;
  final Widget? secondaryWidget;

  const ItemTournamentStatistic({Key? key, required this.text, this.drawDivider = false, this.secondaryWidget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 300,
      // constraints: BoxConstraints(maxHeight: 50),
      // padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: drawDivider ? BoxDecoration(border: Border(top: getBorderDivider(context))) : null,
      child: Row(
        children: [
          IntrinsicHeight(
            child: IntrinsicWidth(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  StatisticBox(
                    value: 1,
                    color: Theme.of(context).primaryColorLight,
                  ),
                  StatisticBox(
                    value: 2,
                  ),
                  StatisticBox(
                    value: 1,
                    color: Theme.of(context).primaryColorLight,
                  ),
                  StatisticBox(
                    value: 3,
                  ),
                  StatisticBox(
                    value: 1,
                    color: Theme.of(context).primaryColorLight,
                  ),
                  StatisticBox(
                    value: 2,
                  ),
                  StatisticBox(
                    value: 1,
                    color: Theme.of(context).primaryColorLight,
                  ),
                  StatisticBox(
                    value: 3,
                  ),
                  StatisticBox(
                    value: 1,
                    color: Theme.of(context).primaryColorLight,
                  ),
                  StatisticBox(
                    value: 2,
                  ),
                  StatisticBox(
                    value: 1,
                    color: Theme.of(context).primaryColorLight,
                  ),
                  // StatisticBox(value: 3,),
                ],
              ),
            ),
          ),
          if (secondaryWidget != null) secondaryWidget!,
        ],
      ),
    );
  }
}

class StatisticBox extends StatelessWidget {
  final int value;
  final Color? color;

  const StatisticBox({Key? key, required this.value, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color = this.color ?? (Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? DarkColorAccent : Colors.white);
    return Container(
      padding: EdgeInsets.all(10),
      height: 35,
      width: 40,
      color: color,
      child: Text(
        value.toString(),
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyText2,
      ),
    );
  }
}
