import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ItemAppBar extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool drawDivider;

  const ItemAppBar({Key? key, required this.icon, required this.text, this.drawDivider = false}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // decoration: drawDivider ? BoxDecoration(border: Border(right: borderSideDivider)) : null,
      height: 35,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FaIcon(icon, size: 13),
          SizedBox(height: 5,),
          Text(text, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w300))
        ],
      ),
    );
  }
}
