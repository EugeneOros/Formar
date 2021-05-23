import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_it/config/dependency.dart';
import 'package:form_it/widgets/app_radio.dart';
import 'package:repositories/repositories.dart';

typedef void OnSexCallback(Sex newSex);

class SexPicker extends StatefulWidget {
  final Sex sex;
  final OnSexCallback onSexChanged;
  final String? heroTag;

  const SexPicker({Key? key, required this.sex, required this.onSexChanged, this.heroTag}) : super(key: key);

  @override
  _SexPickerState createState() => _SexPickerState();
}

class _SexPickerState extends State<SexPicker> {
  @override
  Widget build(BuildContext context) {
    SvgPicture _getSvgPicture(Sex sex) {
      switch (sex) {
        case Sex.man:
          return SvgPicture.asset(
            sex == widget.sex ? "assets/man_black.svg" : "assets/man_empty.svg",
            color: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? LightPink : Colors.black,
          );
        case Sex.woman:
          return SvgPicture.asset(
            sex == widget.sex ? "assets/woman_black.svg" : "assets/woman_empty.svg",
            color: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? LightPink : Colors.black,

          );
      }
    }

    return Padding(
      padding: EdgeInsets.only(left: 10.0),
      child: Row(
        children: [
          Text(
            AppLocalizations.of(context)!.sex,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          Expanded(
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.center,
              children: Sex.values
                  .map(
                    (sex) => Padding(
                      padding: EdgeInsets.all(15.0),
                      child: widget.heroTag != null && sex == widget.sex
                          ? Hero(
                              tag: widget.heroTag!,
                              child: Container(
                                height: 37,
                                width: 37,
                                child: AppRadio(
                                  style: AppRadioStyle(
                                    selectedDepth: -2,
                                    unselectedDepth: 3,
                                    shape: NeumorphicShape.concave,
                                    intensity: 0.8,
                                    selectedColor: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode
                                        ? DarkColorAccent
                                        : Theme.of(context).primaryColorLight,
                                    unselectedColor: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode
                                        ? DarkColorAccent
                                        : Theme.of(context).primaryColorLight,
                                    boxShape: NeumorphicBoxShape.circle(),
                                  ),
                                  groupValue: widget.sex,
                                  value: sex,
                                  child: _getSvgPicture(sex),
                                  onChanged: (Sex? val) => widget.onSexChanged(sex),
                                ),
                              ),
                            )
                          : Container(
                              height: 37,
                              width: 37,
                              child: AppRadio(
                                style: AppRadioStyle(
                                  selectedDepth: -2,
                                  unselectedDepth: 3,
                                  shape: NeumorphicShape.concave,
                                  intensity: 0.8,
                                  selectedColor: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode
                                      ? DarkColorAccent
                                      : Theme.of(context).primaryColorLight,
                                  unselectedColor: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode
                                      ? DarkColorAccent
                                      : Theme.of(context).primaryColorLight,
                                  boxShape: NeumorphicBoxShape.circle(),
                                ),
                                groupValue: widget.sex,
                                value: sex,
                                child: _getSvgPicture(sex),
                                onChanged: (Sex? val) => widget.onSexChanged(sex),
                              ),
                            ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
