import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
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
      padding: EdgeInsets.only(left: 10.0, top: 10),
      child: Row(
        children: [
          Text(
            AppLocalizations.of(context)!.level,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          SizedBox(width: 20),
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: _getLevelColor(widget.level),
                inactiveTrackColor: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? DarkColorShadowDark : Colors.white,
                valueIndicatorTextStyle: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.white),
                valueIndicatorShape: RectangularSliderValueIndicatorShape(),
                trackHeight: 3.0,
                valueIndicatorColor: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? DarkColorShadowDark : Colors.black,
                thumbColor: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? LightBlue : Colors.white,
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10.0),
                inactiveTickMarkColor: Colors.transparent,
                activeTickMarkColor: Colors.transparent,
                overlayColor: Theme.of(context).accentColor.withAlpha(50),
                trackShape: CustomTrackShape(),
              ),
              child:
              Slider(
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
          SizedBox(width: 5),
        ],
      ),
    );
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight!;
    final double trackLeft = offset.dx;
    final double trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
