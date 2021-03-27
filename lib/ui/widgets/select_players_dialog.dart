import 'package:flutter/material.dart';

class MyDialog extends StatefulWidget {
  const MyDialog({required this.onValueChange, required this.initialValue});

  final String initialValue;
  final void Function(String) onValueChange;

  @override
  State createState() => new MyDialogState();
}

class MyDialogState extends State<MyDialog> {
  late String _selectedId;

  @override
  void initState() {
    super.initState();
    _selectedId = widget.initialValue;
  }

  Widget build(BuildContext context) {
    return new SimpleDialog(
      title: new Text("New Dialog"),
      children: <Widget>[
        new Container(
            padding: const EdgeInsets.all(10.0),
            child: new DropdownButton<String>(
              hint: const Text("Pick a thing"),
              value: _selectedId,
              onChanged: (value) {
                setState(() {
                  _selectedId = value!;
                });
                widget.onValueChange(value!);
              },
              items: <String>['One', 'Two', 'Three', 'Four'].map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text(value),
                );
              }).toList(),
            )),
      ],
    );
  }
}