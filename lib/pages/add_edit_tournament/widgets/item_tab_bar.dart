import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_it/config/dependency.dart';

class ItemAppBar extends StatelessWidget {
  final IconData icon;
  final String text;

  const ItemAppBar({Key? key, required this.icon, required this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 35,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FaIcon(icon, size: 13,),
          SizedBox(height: 5,),
          Text(text)
        ],
      ),
    );
  }
}
