import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class NumberPickerHorizontal extends StatefulWidget {
  final Function handleValueChange;
  final int initValue;

  const NumberPickerHorizontal({Key key, this.handleValueChange, this.initValue}) : super(key: key);
  @override
  _NumberPickerHorizontalState createState() => _NumberPickerHorizontalState();
}

class _NumberPickerHorizontalState extends State<NumberPickerHorizontal> {
  int currentCount;

  @override
  void initState() {
    currentCount = widget.initValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.center,
        children: [ NumberPicker.horizontal(
          haptics: true,
          selectedTextStyle: Theme.of(context).textTheme.bodyText1,
          textStyle: Theme.of(context).textTheme.bodyText2,
            initialValue: currentCount,
            minValue: 1,
            maxValue: 100,
            step: 1,
            itemExtent: 45,
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  width: 1.5,
                  style: BorderStyle.solid,
                  color: Theme.of(context).primaryColor,
                ),
                right: BorderSide(
                  width: 1.5,
                  style: BorderStyle.solid,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            listViewHeight: 30,
            onChanged: (value) {
              setState(() => currentCount = value);
              widget.handleValueChange(value);
            }
        ),]
      ),
    );
  }
}
