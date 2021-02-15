import 'package:flutter/material.dart';
import 'package:form_it/ui/shared/colors.dart';

class TournamentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
        alignment: Alignment.center,
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              SecondaryAssentColor,
              SecondaryPinkColor,
              SecondaryBlueColor,
            ],
          ),
        ),
        child: Text(
          "Not Available",
          style: TextStyle(
              color: PrimaryColor,
              fontWeight: FontWeight.w800,
              fontSize: 20.0),
        ));
  }
}
