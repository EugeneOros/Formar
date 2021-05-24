import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_it/config/constants.dart';
import 'package:form_it/config/dependency.dart';
import 'package:form_it/widgets/round_icon_button.dart';
import 'package:repositories/repositories.dart';

class ItemTournament extends StatelessWidget {
  final Tournament tournament;
  final SlidableController? slidableController;

  const ItemTournament({Key? key, required this.tournament, this.slidableController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      controller: slidableController,
      key: Key(tournament.id!),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          alignment: Alignment.center,
          color: Colors.red,
          // height: 80,
          // width: MediaQuery.of(context).size.width,
          child: Text("jlkj"),
          // Stack(
          //   alignment: Alignment.centerRight,
          //   children: [
          //     Container(
          //       child: Neumorphic(
          //         style: NeumorphicStyle(
          //             depth: 2,
          //             intensity: 1,
          //             shape: NeumorphicShape.concave,
          //             boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(15)),
          //             lightSource: LightSource.topLeft,
          //             shadowDarkColorEmboss:
          //                 Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? DarkColorShadowDark : Colors.grey.withOpacity(0.7),
          //             shadowLightColorEmboss:
          //                 Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? DarkColorShadowLight : Colors.white.withOpacity(0.7),
          //             color: Theme.of(context).primaryColor),
          //         child: Container(
          //           // padding: EdgeInsets.symmetric(vertical: 20, horizontal: 120),
          //           child: Text(tournament.name),
          //         ),
          //       ),
          //     ),
          //     Positioned.fill(
          //       left: 10,
          //       child: SvgPicture.asset('assets/league_icon.svg', height: 80,),
          //     ),
          //   ],
          // ),
        ),
      ),
      secondaryActions: <Widget>[
        Container(
          margin: EdgeInsets.all(17),
          child: Neumorphic(
            style: NeumorphicStyle(
                depth: 2,
                intensity: 1,
                shape: NeumorphicShape.concave,
                boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(15)),
                lightSource: LightSource.topLeft,
                shadowDarkColorEmboss:
                Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? DarkColorShadowDark : Colors.grey.withOpacity(0.7),
                shadowLightColorEmboss:
                Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? DarkColorShadowLight : Colors.white.withOpacity(0.7),
                color: Theme.of(context).primaryColor),
            child: Container(
              // height: 30,
              // width:  30,
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment:  CrossAxisAlignment.center,
                children: [
                  Icon(Icons.delete, color: Colors.black, size: 20),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
