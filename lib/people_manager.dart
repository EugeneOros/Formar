import 'package:flutter/material.dart';
import './people.dart';

class PeopleManager extends StatefulWidget {
  final String startingPerson;

  PeopleManager({this.startingPerson = 'noname'});

  @override
  State<StatefulWidget> createState() {
    return _PeopleManagerState();
  }
}

class _PeopleManagerState extends State<PeopleManager> {
  List<String> _people = [];

  @override
  void initState() {
    _people.add(widget.startingPerson);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        margin: EdgeInsets.all(10.0),
        child: RaisedButton(
          color: Theme.of(context).secondaryHeaderColor,
            onPressed: () {
              setState(() {
                _people.add("Staszek");
              });
            },
            child: Text('Add person')),
      ),
      People(_people)
    ]);
  }
}
