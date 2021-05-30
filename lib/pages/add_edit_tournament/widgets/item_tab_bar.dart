import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_it/config/dependency.dart';

class ItemAppBar extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool drawDivider;
  final bool isSelected;

  const ItemAppBar({Key? key, required this.icon, required this.text, this.drawDivider = false, this.isSelected = false}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Color color = Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? (isSelected ? LightPink : LightBlue) : Colors.black;
    return Container(
      width: double.infinity,
      // decoration: drawDivider ? BoxDecoration(border: Border(right: borderSideDivider)) : null,
      height: 35,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FaIcon(icon, size: 13, color: color,),
          SizedBox(height: 5,),
          Text(text, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w300, color: color))
        ],
      ),
    );
  }
}
