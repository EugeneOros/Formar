import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:repositories/repositories.dart';

typedef void OnSexCallback(Sex newSex);

class SexPicker extends StatefulWidget {
  final Sex sex;
  final OnSexCallback onSexChanged;

  const SexPicker({Key? key, required this.sex, required this.onSexChanged}) : super(key: key);

  @override
  _SexPickerState createState() => _SexPickerState();
}

class _SexPickerState extends State<SexPicker> {
  @override
  Widget build(BuildContext context) {
    SvgPicture _getSvgPicture(Sex sex) {
      switch (sex) {
        case Sex.man:
          return SvgPicture.asset(sex == widget.sex ? "assets/man_black.svg" : "assets/man_empty.svg");
        case Sex.woman:
          return SvgPicture.asset(sex == widget.sex ? "assets/woman_black.svg" : "assets/woman_empty.svg");
      }
    }

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      alignment: WrapAlignment.center,
      children: Sex.values
          .map(
            (sex) => Padding(
              padding: EdgeInsets.all(15.0),
              child: GestureDetector(
                onTap: () => widget.onSexChanged(sex),
                child: Container(
                  height: 40,
                  width: 40,
                  color: Colors.transparent,
                  child: _getSvgPicture(sex),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
