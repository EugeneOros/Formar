import 'package:form_it/config/dependency.dart';
import 'package:flutter/material.dart';
import 'package:form_it/config/palette.dart';
import 'package:repositories/repositories.dart';

typedef void OnLevelCallback(Level newLevel);


class LevelPicker extends StatefulWidget {
  final Level level;
  final OnLevelCallback onLevelChanged;

  const LevelPicker({Key? key, required this.level, required this.onLevelChanged}) : super(key: key);
  @override
  _LevelPickerState createState() => _LevelPickerState();
}

class _LevelPickerState extends State<LevelPicker> {
  @override
  Widget build(BuildContext context) {

    String _getLevelName(Level level) {
      switch (level) {
        case Level.beginner:
          return AppLocalizations.of(context)!.beginner;
        case Level.intermediate:
          return AppLocalizations.of(context)!.intermediate;
        case Level.proficient:
          return AppLocalizations.of(context)!.proficient;
        case Level.advanced:
          return AppLocalizations.of(context)!.advanced;
        case Level.expert:
          return AppLocalizations.of(context)!.expert;
        default:
          return "";
      }
    }

    Color _getLevelColor(Level level) {
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

    return Padding(
      padding: EdgeInsets.only(left: 40.0, right: 20),
      child: Row(
        children: [
          Text(
            AppLocalizations.of(context)!.level,
            style: Theme.of(context).textTheme.bodyText2,
          ),
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: _getLevelColor(widget.level),
                inactiveTrackColor: Colors.black,
                valueIndicatorTextStyle: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.white),
                valueIndicatorShape: RectangularSliderValueIndicatorShape(),
                trackHeight: 3.0,
                valueIndicatorColor: Colors.black,
                thumbColor: Colors.white,
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10.0),
                inactiveTickMarkColor: Colors.transparent,
                activeTickMarkColor: Colors.transparent,
                overlayColor: Theme.of(context).accentColor.withAlpha(50),
              ),
              child: Slider(
                label: _getLevelName(widget.level),
                value: widget.level.index.toDouble(),
                onChanged: (double newLevelIndex) {
                  widget.onLevelChanged(Level.values[newLevelIndex.toInt()]);
                },
                divisions: 4,
                min: 0,
                max: 4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
