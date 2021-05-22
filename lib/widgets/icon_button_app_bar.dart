import 'package:flutter/material.dart';
import 'package:form_it/config/dependency.dart';

class IconButtonAppBar extends StatelessWidget {
  final Function onPressed;
  final IconData icon;
  final String? tooltip;

  const IconButtonAppBar({Key? key, required this.onPressed, required this.icon, this.tooltip, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: IconButton(
        padding: EdgeInsets.all(0),
        splashRadius: 23,
        tooltip: tooltip,
        icon: Icon(icon, color: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? LightBlue : Colors.black, size: 23,),
        iconSize: 10,
        onPressed: () => onPressed(),
      ),
    );
  }
}
