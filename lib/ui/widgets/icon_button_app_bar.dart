import 'package:flutter/material.dart';

class IconButtonAppBar extends StatelessWidget {
  final Function onPressed;
  final IconData icon;

  const IconButtonAppBar({Key? key, required this.onPressed, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: IconButton(
        padding: EdgeInsets.all(0),
        icon: Icon(icon, color: Colors.black, size: 23,),
        onPressed: () => onPressed(),
      ),
    );
  }
}
