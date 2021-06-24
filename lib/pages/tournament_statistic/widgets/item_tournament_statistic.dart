import 'package:form_it/config/dependency.dart';
import 'package:form_it/config/helpers.dart';
import 'package:repositories/repositories.dart';

class ItemTournamentStatistic extends StatelessWidget {
  final bool drawDivider;
  final Widget? secondaryWidget;
  final TeamStat teamStat;
  final bool hasDraws;
  final double height;

  const ItemTournamentStatistic({Key? key, this.drawDivider = false, this.secondaryWidget, required this.teamStat, this.hasDraws = true, this.height=35})
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
      height: height,
      decoration: drawDivider ? BoxDecoration(border: Border(top: getBorderDivider(context))) : null,
      child: IntrinsicHeight(
        child: IntrinsicWidth(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: statParams
                .asMap()
                .map((index, value) {
                  return MapEntry(
                      index,
                      StatisticBox(
                        height: height,
                        value: value,
                        color: index % 2 == 0 ? Theme.of(context).primaryColorLight : null,
                      ));
                })
                .values
                .toList(),
          ),
        ),
      ),
    );
  }
}

class StatisticBox extends StatelessWidget {
  final int value;
  final Color? color;
  final double height;

  const StatisticBox({Key? key, required this.value, this.color, this.height=35}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color = this.color ?? (Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? DarkColorAccent : Colors.white);
    return Container(
      padding: EdgeInsets.all(10),
      height: height,
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
