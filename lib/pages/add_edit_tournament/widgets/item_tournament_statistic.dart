import 'package:form_it/config/dependency.dart';
import 'package:form_it/config/helpers.dart';
import 'package:repositories/repositories.dart';

class ItemTournamentStatistic extends StatelessWidget {
  final bool drawDivider;
  final Widget? secondaryWidget;
  final TeamStat teamStat;
  final bool hasDraws;

  const ItemTournamentStatistic({Key? key, this.drawDivider = false, this.secondaryWidget, required this.teamStat, this.hasDraws = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<int> statParams = [
      teamStat.points,
      teamStat.wins,
      if (hasDraws) teamStat.draws,
      teamStat.losses,
      teamStat.matchPlayed,
      teamStat.pointsDifference,
      teamStat.setDifference,
      teamStat.extraPoints
    ];
    return Container(
      decoration: drawDivider ? BoxDecoration(border: Border(top: getBorderDivider(context))) : null,
      child: Row(
        children: [
          IntrinsicHeight(
            child: IntrinsicWidth(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: statParams.asMap().map((index, value) {
                  return MapEntry(index, StatisticBox(
                    value: value,
                    color: index % 2 == 0 ? Theme.of(context).primaryColorLight : null,
                  ));
                }).values.toList(),
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
      width: 50,
      color: color,
      child: Text(
        value.toString(),
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyText2,
      ),
    );
  }
}
