import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'package:form_it/config/dependency.dart';
import 'package:form_it/pages/add_edit_tournament/widgets/counter_element.dart';
import 'package:form_it/pages/add_edit_tournament/widgets/item_tournament_info.dart';
import 'package:form_it/widgets/emboss_container.dart';
import 'package:form_it/widgets/round_icon_button.dart';
import 'package:form_it/widgets/rounded_input_field.dart';

class TournamentInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return 	Neumorphic(
      style: NeumorphicStyle(
        depth: 0,
        color: Theme.of(context).primaryColorLight,
        boxShape: NeumorphicBoxShape.rect(),
        shape: NeumorphicShape.convex,
        lightSource: LightSource.topLeft,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomLeft,
            colors: [
              Theme.of(context).primaryColorLight,
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor,
              Theme.of(context).accentColor,
            ],
          ),
        ),
        // color: Theme.of(context).primaryColorLight,
        child: ListView(
          children: [
            SizedBox(height: 90),
            RoundedInputField(
              name: "Name",
              hintText: "Enter name of tournament",
              radius: 15,
            ),
            EmbossContainer(
              name: "Points",
              child: Column(
                children: [
                  ItemTournamentInfo(
                    text: "Points for win",
                    secondaryWidget: CounterElement(
                      counter: 2,
                    ),
                  ),
                  ItemTournamentInfo(
                    text: "Points for draw",
                    secondaryWidget: CounterElement(
                      counter: 1,
                    ),
                    drawDivider: true,
                  ),
                  ItemTournamentInfo(
                    text: "Points for loss",
                    secondaryWidget: CounterElement(
                      counter: -1,
                    ),
                    drawDivider: true,
                  )
                ],
              ),
            ),
            EmbossContainer(
              name: "Other",
              child: Column(
                children: [
                  ItemTournamentInfo(
                    text: "Number of encounters",
                    secondaryWidget: CounterElement(counter: 1),
                  ),
                  ItemTournamentInfo(
                    text: "Bonus/penalty points",
                    drawDivider: true,
                    secondaryWidget: Container(
                      width: 90,
                      alignment: Alignment.center,
                      child: RoundIconButton(icon: Icons.arrow_forward_ios_rounded, onPressed: () {},)
                    ),
                  ),
                  ItemTournamentInfo(
                      text: "Ranking criteria",
                      drawDivider: true,
                      secondaryWidget: Container(
                          width: 90,
                          alignment: Alignment.center,
                          child: Text(
                            "Total",
                            style: Theme.of(context).textTheme.subtitle2,
                          ))),
                ],
              ),
            ),
            SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }
}
