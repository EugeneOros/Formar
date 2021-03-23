import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_it/ui/shared/colors.dart';
import 'package:repositories/repositories.dart';

class PlayerIndicator extends StatelessWidget {
  final Player player;
  final double size;
  PlayerIndicator({required this.player, this.size = 15});

  Color getLevelColor(Level? level) {
    switch (level) {
      case Level.beginner:
        return BeginnerColor;
      case Level.intermediate:
        return IntermediateColor;
      case Level.proficient:
        return ProficientColor;
      case Level.advanced:
        return AdvancedColor;
      case Level.expert:
        return ExpertColor;
      default:
        return Colors.black;
    }
  }

  SvgPicture _getSexIcon(Sex sex){
    switch(sex){
      case Sex.man:
        return SvgPicture.asset("assets/man_empty.svg");
      case Sex.woman:
        return SvgPicture.asset("assets/woman_empty.svg");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(2),
        // margin: EdgeInsets.only(
        //     right: 5.0),
        alignment: Alignment.topCenter,
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: getLevelColor(player.level),
          shape: BoxShape.circle,
        ),
        child: _getSexIcon(player.sex)
    );
  }
}
