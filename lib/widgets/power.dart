import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_it/config/dependency.dart';

class Power extends StatelessWidget {
  final int power;

  const Power({Key? key, required this.power}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Container(
          width: 20,
          height: 20,
          child: SvgPicture.asset(
            "assets/power.svg",
            color: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? LightBlue : Colors.black,
          ),
        ),
        Text(
          power.toString(),
          style: Theme.of(context).textTheme.bodyText2,
        ),
      ],
    );
  }
}
