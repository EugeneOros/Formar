import 'package:flutter/material.dart';


class People extends StatelessWidget {
  final List<String> people;

  People(this.people);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: people
          .map((person) => Card(
                child: Column(
                  children: <Widget>[
                    Image.asset('assets/me.jpg'),
                    Text(person)
                  ],
                ),
              ))
          .toList(),
    );
  }
}
