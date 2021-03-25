import 'package:flutter/material.dart';
import 'package:form_it/ui/widgets/filtered_players_list.dart';

class PeoplePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FilteredPeopleList(),
    );
  }

}