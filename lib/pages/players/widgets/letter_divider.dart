import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:form_it/config/palette.dart';
import 'package:form_it/logic/models/app_state_notifier.dart';
import 'package:provider/provider.dart';

class LetterDivider extends StatelessWidget {
  final String letter;
  final String? secondaryString;

  const LetterDivider({Key? key, required this.letter, this.secondaryString}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      style: NeumorphicStyle(
          depth: -3,
          intensity: 0.6,
          shape: NeumorphicShape.flat,
          shadowDarkColorEmboss: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ?  DarkColorShadowDark : Colors.grey,
          shadowLightColorEmboss: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ?  DarkColorShadowLight  :Colors.white,
          // intensity: 1,
          surfaceIntensity: 1,
          boxShape: NeumorphicBoxShape.rect(),
          // depth: -15,
          lightSource: LightSource.topLeft,
          color: Colors.transparent //Theme.of(context).primaryColorLight,
          ),
      child: Container(
        height: 20,
        // color: Colors.grey[200],
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                letter,
                style: Theme.of(context).textTheme.subtitle2,
              ),
            ),
            Spacer(),
            if (secondaryString != null)
              Container(
                width: 100,
                child: Center(
                  child: Text(secondaryString!,
                      // players.where((player) => player.available == true).length.toString() + "/" + players.length.toString(),
                      style: Theme.of(context).textTheme.subtitle2),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
